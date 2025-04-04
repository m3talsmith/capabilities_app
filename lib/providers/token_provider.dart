import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/token.dart';

final tokenProvider = StateNotifierProvider<TokenNotifier, Token?>((ref) {
  return TokenNotifier();
});

class TokenNotifier extends StateNotifier<Token?> {
  TokenNotifier() : super(null);

  void setToken(Token token) {
    state = token;
  }

  void clearToken() {
    state = null;
  }
}
