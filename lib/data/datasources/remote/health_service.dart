
import 'dart:io';
import 'package:health/health.dart';
import 'package:dartz/dartz.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/error/failures.dart';
import '../../../core/utils/analytics_service.dart';

class HealthData {
  final double? steps;
  final double? activeEnergyBurned;
  final double? heartRate;
  final double? weight;
  final double? height;
  final double? bodyFat;
  final double? bodyMassIndex;
  final double? sleepHours;
  final double? waterIntake;

  HealthData({
    this.steps,
    this.activeEnergyBurned,
    this.heartRate,
    this.weight,
    this.height,
    this.bodyFat,
    this.bodyMassIndex,
    this.sleepHours,
    this.waterIntake,
  });
}

class HealthService {
  final AnalyticsService _analyticsService;
  final HealthFactory _health = HealthFactory();
  
  bool _isAuthorized = false;
  
  HealthService(this._analyticsService);
  
  // Check if the platform supports health services
  bool get isPlatformSupported {
    return Platform.isIOS || Platform.isAndroid;
  }
  
  // Check if the app is authorized to access health data
  Future<bool> isAuthorized() async {
    if (!isPlatformSupported) {
      return false;
    }
    
    return _isAuthorized;
  }

  // Request authorization to access health data
  Future<Either<Failure, bool>> requestAuthorization() async {
    try {
      if (!isPlatformSupported) {
        return Left(HealthFailure('Health integration is not supported on this platform'));
      }
      
      // Define the types of data to access
      final types = [
        HealthDataType.STEPS,
        HealthDataType.ACTIVE_ENERGY_BURNED,
        HealthDataType.HEART_RATE,
        HealthDataType.WEIGHT,
        HealthDataType.HEIGHT,
        HealthDataType.BODY_FAT_PERCENTAGE,
        HealthDataType.BODY_MASS_INDEX,
        if (Platform.isIOS) HealthDataType.SLEEP_IN_BED,
        if (Platform.isAndroid) HealthDataType.SLEEP_ASLEEP,
        // Water intake is only available via nutrition on iOS
        if (Platform.isAndroid) HealthDataType.WATER,
      ];
      
      // Request authorization
      _isAuthorized = await _health.requestAuthorization(types);
      
      // Log the result
      _analyticsService.logHealthAppConnected(
        platform: Platform.isIOS ? 'iOS Health' : 'Google Fit',
      );
      
      return Right(_isAuthorized);
    } catch (e) {
      _analyticsService.logError(
        errorType: 'health_authorization_error',
        errorMessage: e.toString(),
      );
      return Left(HealthFailure('Failed to request health data authorization: ${e.toString()}'));
    }
  }
  
  // Fetch health data for a specific time period
  Future<Either<Failure, HealthData>> fetchHealthData(DateTime startDate, DateTime endDate) async {
    try {
      if (!isPlatformSupported) {
        return Left(HealthFailure('Health integration is not supported on this platform'));
      }
      
      if (!_isAuthorized) {
        final authResult = await requestAuthorization();
        if (authResult.isLeft()) {
          return Left(HealthFailure('Not authorized to access health data'));
        }
      }
      
      final healthData = HealthData();
      
      // Fetch steps
      final steps = await _fetchDataPoint(
        HealthDataType.STEPS,
        startDate,
        endDate,
      );
      if (steps != null) {
        healthData.steps = steps;
      }
      
      // Fetch active energy burned (calories)
      final calories = await _fetchDataPoint(
        HealthDataType.ACTIVE_ENERGY_BURNED,
        startDate,
        endDate,
      );
      if (calories != null) {
        healthData.activeEnergyBurned = calories;
      }
      
      // Fetch heart rate (average for the period)
      final heartRate = await _fetchDataPoint(
        HealthDataType.HEART_RATE,
        startDate,
        endDate,
        aggregateFunction: AggregateFunction.AVERAGE,
      );
      if (heartRate != null) {
        healthData.heartRate = heartRate;
      }
      
      // Fetch weight (most recent)
      final weight = await _fetchDataPoint(
        HealthDataType.WEIGHT,
        startDate,
        endDate,
        aggregateFunction: AggregateFunction.LATEST,
      );
      if (weight != null) {
        healthData.weight = weight;
      }
      
      // Fetch height (most recent)
      final height = await _fetchDataPoint(
        HealthDataType.HEIGHT,
        startDate,
        endDate,
        aggregateFunction: AggregateFunction.LATEST,
      );
      if (height != null) {
        healthData.height = height;
      }
      
      // Fetch body fat percentage (most recent)
      final bodyFat = await _fetchDataPoint(
        HealthDataType.BODY_FAT_PERCENTAGE,
        startDate,
        endDate,
        aggregateFunction: AggregateFunction.LATEST,
      );
      if (bodyFat != null) {
        healthData.bodyFat = bodyFat;
      }
      
      // Fetch body mass index (most recent)
      final bmi = await _fetchDataPoint(
        HealthDataType.BODY_MASS_INDEX,
        startDate,
        endDate,
        aggregateFunction: AggregateFunction.LATEST,
      );
      if (bmi != null) {
        healthData.bodyMassIndex = bmi;
      }
      
      // Fetch sleep data (depends on platform)
      final sleepType = Platform.isIOS 
          ? HealthDataType.SLEEP_IN_BED 
          : HealthDataType.SLEEP_ASLEEP;
      final sleepHours = await _fetchDataPoint(
        sleepType,
        startDate,
        endDate,
        unitDivision: 3600, // Convert seconds to hours
      );
      if (sleepHours != null) {
        healthData.sleepHours = sleepHours;
      }
      
      // Fetch water intake (Android only)
      if (Platform.isAndroid) {
        final water = await _fetchDataPoint(
          HealthDataType.WATER,
          startDate,
          endDate,
          unitDivision: 1000, // Convert ml to liters
        );
        if (water != null) {
          healthData.waterIntake = water;
        }
      }
      
      return Right(healthData);
    } catch (e) {
      _analyticsService.logError(
        errorType: 'fetch_health_data_error',
        errorMessage: e.toString(),
      );
      return Left(HealthFailure('Failed to fetch health data: ${e.toString()}'));
    }
  }
  
  // Helper method to fetch a specific data point
  Future<double?> _fetchDataPoint(
    HealthDataType type,
    DateTime startDate,
    DateTime endDate, {
    AggregateFunction aggregateFunction = AggregateFunction.SUM,
    double unitDivision = 1.0,
  }) async {
    try {
      List<HealthDataPoint> healthData = await _health.getHealthDataFromTypes(
        startDate,
        endDate,
        [type],
      );
      
      if (healthData.isEmpty) {
        return null;
      }
      
      // Filter out data of specific type
      healthData = HealthFactory.removeDuplicates(healthData);
      
      double value = 0;
      
      switch (aggregateFunction) {
        case AggregateFunction.SUM:
          // Sum all values
          for (final dataPoint in healthData) {
            value += double.tryParse(dataPoint.value.toString()) ?? 0;
          }
          break;
          
        case AggregateFunction.AVERAGE:
          // Calculate average
          double sum = 0;
          for (final dataPoint in healthData) {
            sum += double.tryParse(dataPoint.value.toString()) ?? 0;
          }
          value = healthData.isEmpty ? 0 : sum / healthData.length;
          break;
          
        case AggregateFunction.LATEST:
          // Get the most recent value
          healthData.sort((a, b) => b.dateFrom.compareTo(a.dateFrom));
          value = double.tryParse(healthData.first.value.toString()) ?? 0;
          break;
      }
      
      // Apply unit division if needed
      return value / unitDivision;
    } catch (e) {
      print('Error fetching $type: $e');
      return null;
    }
  }
  
  // Write a data point to the health service
  Future<Either<Failure, bool>> writeHealthData({
    required HealthDataType type,
    required double value,
    required DateTime dateFrom,
    required DateTime dateTo,
    String? deviceId,
    String? sourceId,
    String? sourceName,
  }) async {
    try {
      if (!isPlatformSupported) {
        return Left(HealthFailure('Health integration is not supported on this platform'));
      }
      
      if (!_isAuthorized) {
        final authResult = await requestAuthorization();
        if (authResult.isLeft()) {
          return Left(HealthFailure('Not authorized to access health data'));
        }
      }
      
      final dataType = type;
      final permissions = [
        HealthDataAccess.WRITE,
      ];
      
      // Request specific write permission
      final writePermission = await _health.requestAuthorization(
        [dataType],
        permissions: permissions,
      );
      
      if (!writePermission) {
        return Left(HealthFailure('Write permission denied for $type'));
      }
      
      final result = await _health.writeHealthData(
        value,
        dataType,
        dateFrom,
        dateTo,
        deviceId: deviceId,
        sourceId: sourceId,
        sourceName: sourceName,
      );
      
      if (result) {
        // Log success
        _analyticsService.logEvent(
          name: 'health_data_written',
          parameters: {
            'type': type.toString(),
            'value': value,
          },
        );
      }
      
      return Right(result);
    } catch (e) {
      _analyticsService.logError(
        errorType: 'write_health_data_error',
        errorMessage: e.toString(),
      );
      return Left(HealthFailure('Failed to write health data: ${e.toString()}'));
    }
  }
  
  // Disconnect from health services
  Future<Either<Failure, bool>> disconnectHealthServices(String reason) async {
    try {
      _isAuthorized = false;
      
      // Log the disconnection
      _analyticsService.logHealthAppDisconnected(
        platform: Platform.isIOS ? 'iOS Health' : 'Google Fit',
        reason: reason,
      );
      
      return const Right(true);
    } catch (e) {
      return Left(HealthFailure('Failed to disconnect health services: ${e.toString()}'));
    }
  }
}

// Helper enum for data aggregation
enum AggregateFunction {
  SUM,
  AVERAGE,
  LATEST,
}
