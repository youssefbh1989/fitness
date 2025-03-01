
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../../core/utils/analytics_service.dart';
import '../../../domain/repositories/auth_repository.dart';

class AuthService implements AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookAuth _facebookAuth = FacebookAuth.instance;
  final AnalyticsService _analyticsService;

  AuthService(this._analyticsService);

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        return Right(user);
      } else {
        return Left(AuthFailure('No authenticated user found'));
      }
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (result.user != null) {
        await _analyticsService.logLogin(loginMethod: 'email');
        return Right(result.user!);
      } else {
        return Left(AuthFailure('Failed to sign in with email and password'));
      }
    } on FirebaseAuthException catch (e) {
      return Left(_handleFirebaseAuthException(e));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        return Left(AuthFailure('Google sign in was cancelled'));
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      
      if (userCredential.user != null) {
        await _analyticsService.logLogin(loginMethod: 'google');
        return Right(userCredential.user!);
      } else {
        return Left(AuthFailure('Failed to sign in with Google'));
      }
    } on FirebaseAuthException catch (e) {
      return Left(_handleFirebaseAuthException(e));
    } catch (e) {
      return Left(AuthFailure('Google sign in error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, User>> signInWithApple() async {
    try {
      // Check if Apple Sign In is available on this device
      final isAvailable = await SignInWithApple.isAvailable();
      
      if (!isAvailable) {
        return Left(AuthFailure('Apple Sign In is not available on this device'));
      }
      
      // Get Apple ID credentials
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      
      // Create OAuthCredential
      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );
      
      // Sign in to Firebase with the Apple credential
      final userCredential = await _firebaseAuth.signInWithCredential(oauthCredential);
      
      if (userCredential.user != null) {
        // Update display name if it's null (Apple might not provide it every time)
        if (userCredential.user!.displayName == null || 
            userCredential.user!.displayName!.isEmpty) {
          if (appleCredential.givenName != null && 
              appleCredential.familyName != null) {
            await userCredential.user!.updateDisplayName(
              '${appleCredential.givenName} ${appleCredential.familyName}'
            );
          }
        }
        
        await _analyticsService.logLogin(loginMethod: 'apple');
        return Right(userCredential.user!);
      } else {
        return Left(AuthFailure('Failed to sign in with Apple'));
      }
    } on SignInWithAppleException catch (e) {
      return Left(AuthFailure('Apple sign in error: ${e.toString()}'));
    } on FirebaseAuthException catch (e) {
      return Left(_handleFirebaseAuthException(e));
    } catch (e) {
      return Left(AuthFailure('Apple sign in error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, User>> signInWithFacebook() async {
    try {
      // Trigger the sign-in flow
      final LoginResult loginResult = await _facebookAuth.login();
      
      if (loginResult.status != LoginStatus.success) {
        return Left(AuthFailure('Facebook login failed or was cancelled'));
      }
      
      // Create a credential from the access token
      final AccessToken? accessToken = loginResult.accessToken;
      if (accessToken == null) {
        return Left(AuthFailure('Failed to get Facebook access token'));
      }
      
      final OAuthCredential credential = FacebookAuthProvider.credential(accessToken.token);
      
      // Sign in to Firebase with the Facebook credential
      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      
      if (userCredential.user != null) {
        await _analyticsService.logLogin(loginMethod: 'facebook');
        return Right(userCredential.user!);
      } else {
        return Left(AuthFailure('Failed to sign in with Facebook'));
      }
    } on FacebookAuthException catch (e) {
      return Left(AuthFailure('Facebook auth error: ${e.message}'));
    } on FirebaseAuthException catch (e) {
      return Left(_handleFirebaseAuthException(e));
    } catch (e) {
      return Left(AuthFailure('Facebook sign in error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, User>> registerWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      final result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (result.user != null) {
        await result.user!.updateDisplayName(name);
        await _analyticsService.logSignUp(signUpMethod: 'email');
        return Right(result.user!);
      } else {
        return Left(AuthFailure('Failed to register with email and password'));
      }
    } on FirebaseAuthException catch (e) {
      return Left(_handleFirebaseAuthException(e));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(_handleFirebaseAuthException(e));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();
      await _facebookAuth.logOut();
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  Failure _handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return AuthFailure('No user found with this email');
      case 'wrong-password':
        return AuthFailure('Incorrect password');
      case 'email-already-in-use':
        return AuthFailure('This email is already registered');
      case 'weak-password':
        return AuthFailure('The password is too weak');
      case 'invalid-email':
        return AuthFailure('The email address is not valid');
      case 'user-disabled':
        return AuthFailure('This user account has been disabled');
      case 'too-many-requests':
        return AuthFailure('Too many attempts. Try again later');
      case 'operation-not-allowed':
        return AuthFailure('This sign-in method is not enabled');
      case 'account-exists-with-different-credential':
        return AuthFailure('An account already exists with the same email address but different sign-in credentials');
      default:
        return AuthFailure(e.message ?? 'An unknown authentication error occurred');
    }
  }
}
