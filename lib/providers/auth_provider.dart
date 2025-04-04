import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/token.dart';

final authProvider = StateNotifierProvider<AuthNotifier, bool>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<bool> {
  AuthNotifier() : super(false);

  void login(Token token) {
    state = true;
  }

  void logout() {
    state = false;
  }
}
