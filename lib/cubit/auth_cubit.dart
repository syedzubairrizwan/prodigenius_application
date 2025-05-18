import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prodigenius_application/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _auth;

  AuthCubit({FirebaseAuth? auth})
    : _auth = auth ?? FirebaseAuth.instance,
      super(const AuthState.initial()) {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        emit(AuthState.authenticated(user));
      } else {
        emit(const AuthState.unauthenticated());
      }
    });
  }

  Future<void> signIn(String email, String password) async {
    try {
      emit(const AuthState.loading());
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      emit(AuthState.error(_getErrorMessage(e)));
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      emit(const AuthState.loading());
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      emit(AuthState.error(_getErrorMessage(e)));
    }
  }

  Future<void> signOut() async {
    try {
      emit(const AuthState.loading());
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      emit(AuthState.error(_getErrorMessage(e)));
    }
  }

  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'Email is already in use.';
      case 'weak-password':
        return 'Password is too weak.';
      case 'invalid-email':
        return 'Email address is invalid.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}
