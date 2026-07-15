import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';

class AuthState {
  final bool isLoading;
  final String? errorMessage;

  AuthState({this.isLoading = false, this.errorMessage});

  AuthState copyWith({bool? isLoading, String? errorMessage}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class AuthViewModel extends Notifier<AuthState> {
  final _authService = AuthService();

  @override
  AuthState build() => AuthState();

  Future<bool> signUp(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _authService.signUp(email, password);
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> signIn(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _authService.signIn(email, password);
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

final authViewModelProvider = NotifierProvider<AuthViewModel, AuthState>(
  AuthViewModel.new,
);
