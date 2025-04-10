import 'dart:convert';
import 'package:capabilities_app/ui/content_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../ui/screen_container.dart';
import 'register.dart';
import '../providers/token.dart';
import '../models/token.dart';
import '../providers/auth.dart';
import '../teams/teams.dart';
import '../requests/endpoints.dart';

class Login extends ConsumerStatefulWidget {
  const Login({super.key});

  @override
  ConsumerState<Login> createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool isShowingPassword = false;

  login(context) async {
    final messenger = ScaffoldMessenger.of(context);
    final username = usernameController.text;
    final password = passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      messenger.showSnackBar(
        SnackBar(content: Text('Please enter a username and password')),
      );
      return;
    }

    final response = await http.post(
      Uri.parse(loginPath),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode != 200) {
      messenger.showSnackBar(
        SnackBar(content: Text('Invalid username or password')),
      );
      return;
    }

    final body = jsonDecode(response.body);
    final tokenValue = body['data']['token'];
    final expiresAt = body['data']['expiresAt'];
    final userId = body['data']['userId'];
    final token = Token(
      value: tokenValue,
      expiresAt: DateTime.parse(expiresAt),
      userId: userId,
    );

    ref.read(tokenProvider.notifier).setToken(token);
    ref.read(authProvider.notifier).state = token;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => TeamsView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return ScreenContainer(
      child: ContentContainer(
        margin: EdgeInsets.only(
          left: width > 1024 ? width * 0.33 : 0,
          right: width > 1024 ? width * 0.33 : 0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Login',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Theme.of(context).colorScheme.onInverseSurface,
              ),
            ),
            ContentContainer(
              backgroundColor: Theme.of(context).colorScheme.surface,
              margin: const EdgeInsets.only(top: 32),
              child: Column(
                children: [
                  AutofillGroup(
                    child: TextField(
                      controller: usernameController,
                      decoration: InputDecoration(labelText: 'Username'),
                      autofillHints: [AutofillHints.username],
                      onSubmitted: (value) => login(context),
                    ),
                  ),
                  AutofillGroup(
                    child: TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          onPressed:
                              () => setState(
                                () => isShowingPassword = !isShowingPassword,
                              ),
                          icon: Icon(
                            isShowingPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                      obscureText: !isShowingPassword,
                      onSubmitted: (value) => login(context),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FilledButton(
                          onPressed: () => login(context),
                          child: Text(
                            'Login',
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium?.copyWith(
                              color:
                                  Theme.of(
                                    context,
                                  ).colorScheme.onInverseSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ContentContainer(
              padding: const EdgeInsets.only(top: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FilledButton(
                    onPressed: () {},
                    child: Text(
                      'Forgot Password?',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onInverseSurface,
                      ),
                    ),
                  ),
                  FilledButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Register()),
                      );
                    },
                    child: Text(
                      'Register',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onInverseSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
