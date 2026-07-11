import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthCubit() : super(AuthInitial()) {
    checkUser();
  }

  /// Check if a user is currently logged in on startup
  void checkUser() {
    final user = _auth.currentUser;
    if (user != null) {
      emit(Authenticated(user));
    } else {
      emit(Unauthenticated());
    }
  }

  /// Sign In with Email & Password
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    emit(AuthLoading());
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        emit(Authenticated(credential.user!));
      } else {
        emit(const AuthError('Authentication failed: user is null.'));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? 'Authentication error occurred.'));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// Sign Up / Register with Email & Password
  Future<void> signUpWithEmailAndPassword(String email, String password, String name) async {
    emit(AuthLoading());
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user != null) {
        await user.updateDisplayName(name);
        await user.reload();
        final updatedUser = _auth.currentUser;
        emit(Authenticated(updatedUser ?? user));
      } else {
        emit(const AuthError('Registration failed: user is null.'));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? 'Registration error occurred.'));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// Google Sign In
  Future<void> signInWithGoogle() async {
    emit(AuthLoading());
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        emit(Unauthenticated());
        return;
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await _auth.signInWithCredential(credential);
      if (userCredential.user != null) {
        emit(Authenticated(userCredential.user!));
      } else {
        emit(const AuthError('Google Sign-In failed: user is null.'));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? 'Google Sign-In error.'));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// Start Phone Number Verification (Sends SMS Code)
  Future<void> verifyPhoneNumber(String phoneNumber) async {
    emit(AuthLoading());
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-verification on some Android devices
          final userCredential = await _auth.signInWithCredential(credential);
          if (userCredential.user != null) {
            emit(Authenticated(userCredential.user!));
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          emit(AuthError(e.message ?? 'Phone verification failed.'));
        },
        codeSent: (String verificationId, int? resendToken) {
          emit(OtpSent(verificationId: verificationId, phoneNumber: phoneNumber));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Timeout callback
        },
      );
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// Verify OTP SMS Code
  Future<void> verifyOtp(String verificationId, String smsCode) async {
    emit(AuthLoading());
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      final userCredential = await _auth.signInWithCredential(credential);
      if (userCredential.user != null) {
        emit(Authenticated(userCredential.user!));
      } else {
        emit(const AuthError('Phone OTP verification failed: user is null.'));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? 'Invalid OTP code.'));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// Logout/Sign Out from Firebase
  Future<void> signOut() async {
    emit(AuthLoading());
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
