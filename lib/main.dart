import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'storage/auth.dart';
import 'providers/token.dart'; // You'll need to create this file for tokenProvider

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var token = await AuthStorage.getToken();

  runApp(
    ProviderScope(
      overrides: [
        tokenProvider.overrideWith(() => TokenNotifier(token: token)),
      ],
      child: App(),
    ),
  );
}
