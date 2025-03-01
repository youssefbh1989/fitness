
import 'dart:async';
import 'dart:io';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../../core/utils/analytics_service.dart';

enum SubscriptionType {
  monthly,
  yearly,
}

class SubscriptionInfo {
  final String id;
  final String title;
  final String description;
  final double price;
  final String currencyCode;
  final SubscriptionType type;
  final String? introductoryPrice;
  final int? trialDays;

  SubscriptionInfo({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.currencyCode,
    required this.type,
    this.introductoryPrice,
    this.trialDays,
  });
}

class PurchaseService {
  // Product IDs for subscriptions
  static const String kMonthlySubscriptionId = 'fitbody_premium_monthly';
  static const String kYearlySubscriptionId = 'fitbody_premium_yearly';
  
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  final AnalyticsService _analyticsService;
  
  // Subscription product details
  List<ProductDetails> _products = [];
  
  // Stream controller for purchase updates
  final StreamController<List<PurchaseDetails>> _purchaseController = 
      StreamController<List<PurchaseDetails>>.broadcast();
  Stream<List<PurchaseDetails>> get purchaseStream => _purchaseController.stream;
  
  // Stream subscription for purchase updates
  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;
  
  PurchaseService(this._analyticsService) {
    _initialize();
  }
  
  Future<void> _initialize() async {
    // Check if the payment platform is available
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      _purchaseController.add([]);
      return;
    }
    
    // Listen to purchase updates
    _purchaseSubscription = _inAppPurchase.purchaseStream.listen(
      _handlePurchaseUpdate,
      onDone: () {
        _purchaseSubscription?.cancel();
      },
      onError: (error) {
        // Handle error
        _analyticsService.logError(
          errorType: 'purchase_stream_error',
          errorMessage: error.toString(),
        );
      },
    );
    
    // Initialize the store-specific platform
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatform iosPlatform = 
          _inAppPurchase as InAppPurchaseStoreKitPlatform;
      await iosPlatform.setDelegate(_IOSPurchaseDelegate());
    }
    
    // Load product details
    await loadProducts();
  }
  
  Future<Either<Failure, List<SubscriptionInfo>>> loadProducts() async {
    try {
      final ProductDetailsResponse response = 
          await _inAppPurchase.queryProductDetails({
        kMonthlySubscriptionId,
        kYearlySubscriptionId,
      });
      
      if (response.error != null) {
        _analyticsService.logError(
          errorType: 'load_products_error',
          errorMessage: response.error.toString(),
        );
        return Left(PurchaseFailure('Failed to load subscription products: ${response.error}'));
      }
      
      _products = response.productDetails;
      
      if (_products.isEmpty) {
        return const Right([]);
      }
      
      final List<SubscriptionInfo> subscriptionInfoList = _products.map((product) {
        // Determine subscription type
        final SubscriptionType type = product.id == kMonthlySubscriptionId
            ? SubscriptionType.monthly
            : SubscriptionType.yearly;
        
        // Extract introductory price info if available
        String? introductoryPrice;
        int? trialDays;
        
        if (Platform.isIOS) {
          final SkuDetailsWrapper? skuDetails = product as SkuDetailsWrapper?;
          // Parse introductory price info (simplified for example)
          introductoryPrice = skuDetails?.introductoryPrice;
          // Parse trial days (simplified)
          trialDays = skuDetails?.freeTrialPeriod != null ? 7 : null; // Placeholder
        } else if (Platform.isAndroid) {
          final GooglePlayProductDetails? androidDetails = 
              product as GooglePlayProductDetails?;
          // Parse introductory price info (simplified)
          introductoryPrice = androidDetails?.skuDetails.introductoryPrice;
          // Parse trial days (simplified)
          trialDays = androidDetails?.skuDetails.freeTrialPeriod != null ? 7 : null; // Placeholder
        }
        
        return SubscriptionInfo(
          id: product.id,
          title: product.title,
          description: product.description,
          price: double.tryParse(product.price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0,
          currencyCode: product.currencyCode,
          type: type,
          introductoryPrice: introductoryPrice,
          trialDays: trialDays,
        );
      }).toList();
      
      return Right(subscriptionInfoList);
    } catch (e) {
      _analyticsService.logError(
        errorType: 'load_products_exception',
        errorMessage: e.toString(),
      );
      return Left(PurchaseFailure('Error loading subscription products: ${e.toString()}'));
    }
  }
  
  Future<Either<Failure, void>> purchaseSubscription(SubscriptionType type) async {
    try {
      final String productId = type == SubscriptionType.monthly
          ? kMonthlySubscriptionId
          : kYearlySubscriptionId;
      
      final ProductDetails? product = _products.firstWhere(
        (product) => product.id == productId,
        orElse: () => throw Exception('Product not found: $productId'),
      );
      
      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: product,
        applicationUserName: null,
      );
      
      _analyticsService.logEvent(
        name: 'subscription_purchase_started',
        parameters: {
          'subscription_type': type.toString(),
          'product_id': productId,
        },
      );
      
      // Start the purchase flow
      await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
      
      return const Right(null);
    } catch (e) {
      _analyticsService.logError(
        errorType: 'purchase_subscription_error',
        errorMessage: e.toString(),
      );
      return Left(PurchaseFailure('Failed to purchase subscription: ${e.toString()}'));
    }
  }
  
  Future<Either<Failure, bool>> restorePurchases() async {
    try {
      await _inAppPurchase.restorePurchases();
      return const Right(true);
    } catch (e) {
      _analyticsService.logError(
        errorType: 'restore_purchases_error',
        errorMessage: e.toString(),
      );
      return Left(PurchaseFailure('Failed to restore purchases: ${e.toString()}'));
    }
  }
  
  void _handlePurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          // Show loading UI
          _analyticsService.logEvent(
            name: 'purchase_pending',
            parameters: {
              'product_id': purchaseDetails.productID,
            },
          );
          break;
          
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          // Verify purchase
          _verifyPurchase(purchaseDetails);
          break;
          
        case PurchaseStatus.error:
          // Handle error
          _analyticsService.logError(
            errorType: 'purchase_error',
            errorMessage: purchaseDetails.error?.message ?? 'Unknown purchase error',
          );
          break;
          
        case PurchaseStatus.canceled:
          _analyticsService.logEvent(
            name: 'purchase_cancelled',
            parameters: {
              'product_id': purchaseDetails.productID,
            },
          );
          break;
      }
      
      // Complete the purchase if it's not pending
      if (purchaseDetails.pendingCompletePurchase) {
        _inAppPurchase.completePurchase(purchaseDetails);
      }
    }
    
    // Forward the purchase updates to listeners
    _purchaseController.add(purchaseDetailsList);
  }
  
  Future<void> _verifyPurchase(PurchaseDetails purchase) async {
    // In a real app, you would verify the purchase with your server
    // This is a simplified example
    
    if (purchase.status == PurchaseStatus.purchased) {
      // Track purchase in analytics
      _analyticsService.logEvent(
        name: 'subscription_purchased',
        parameters: {
          'product_id': purchase.productID,
          'transaction_id': purchase.purchaseID ?? 'unknown',
          'purchase_time': DateTime.now().toString(),
        },
      );
    } else if (purchase.status == PurchaseStatus.restored) {
      // Track restored purchase
      _analyticsService.logEvent(
        name: 'subscription_restored',
        parameters: {
          'product_id': purchase.productID,
          'transaction_id': purchase.purchaseID ?? 'unknown',
        },
      );
    }
  }
  
  void dispose() {
    _purchaseSubscription?.cancel();
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatform iosPlatform = 
          _inAppPurchase as InAppPurchaseStoreKitPlatform;
      iosPlatform.setDelegate(null);
    }
    _purchaseController.close();
  }
}

// iOS specific purchase delegate
class _IOSPurchaseDelegate implements InAppPurchaseStoreKitPlatformDelegate {
  @override
  Future<bool> shouldAddStorePayment(SKPaymentQueue queue, SKPayment payment, SKProduct product) async {
    // Here you can check if the user is allowed to purchase
    // Return true to continue the purchase flow
    return true;
  }
  
  @override
  void updateStorefront(SKStorefront storefront) {
    // Handle storefront update if needed
  }
}
