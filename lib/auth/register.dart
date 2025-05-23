import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'package:capabilities_app/ui/content_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:clipboard/clipboard.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../ui/screen_container.dart';
import 'login.dart';
import '../requests/endpoints.dart';

class Register extends ConsumerStatefulWidget {
  const Register({super.key});

  @override
  ConsumerState<Register> createState() => _RegisterState();
}

class _RegisterState extends ConsumerState<Register> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool isPasswordVisible = false;
  bool showBackupCodes = false;
  bool isCopied = false;
  List<String> backupCodes = [];

  register(context) async {
    final snackBar = SnackBar(content: Text('Registering...'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        usernameController.text.isEmpty ||
        passwordController.text.isEmpty) {
      log('first name: ${firstNameController.text}');
      log('last name: ${lastNameController.text}');
      log('username: ${usernameController.text}');
      log('password: ${passwordController.text}');
      final snackBar = SnackBar(content: Text('Please fill in all fields'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    final response = await http.post(
      Uri.parse(registerPath),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'first_name': firstNameController.text,
        'last_name': lastNameController.text,
        'username': usernameController.text,
        'password': passwordController.text,
      }),
    );

    if (response.statusCode != HttpStatus.ok) {
      try {
        final body = jsonDecode(response.body);
        final snackBar = SnackBar(
          content: Text('Register failed: ${body['message']}'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } catch (e) {
        final snackBar = SnackBar(
          content: Text('Register failed: ${response.body}'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      return;
    }

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Register successful')));

    final json = jsonDecode(response.body);
    await FlutterClipboard.copy(json['data']['backup_codes'].join('\n'));
    List<String> newBackupCodes = [];
    for (var code in json['data']['backup_codes']) {
      log('code: $code');
      newBackupCodes.add(code);
    }
    log('backup codes: $newBackupCodes');
    setState(() {
      showBackupCodes = true;
      backupCodes = newBackupCodes;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return ScreenContainer(
      child:
          showBackupCodes
              ? ContentContainer(
                margin: EdgeInsets.only(
                  left: width > 1024 ? width * 0.33 : 0,
                  right: width > 1024 ? width * 0.33 : 0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Backup codes',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onInverseSurface,
                      ),
                    ),
                    ContentContainer(
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      margin: EdgeInsets.only(top: 32),
                      child: Column(
                        children: [
                          SelectableRegion(
                            selectionControls: MaterialTextSelectionControls(),
                            child: StaggeredGrid.count(
                              crossAxisCount:
                                  MediaQuery.of(context).size.width ~/ 450,
                              children:
                                  backupCodes
                                      .map(
                                        (code) => Container(
                                          width: 450,
                                          margin: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .inverseSurface
                                                .withAlpha(15),
                                          ),
                                          child: Text(
                                            code,
                                            textAlign: TextAlign.center,
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodySmall?.copyWith(
                                              fontFamily: 'monospace',
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton.icon(
                                onPressed: () {
                                  FlutterClipboard.copy(backupCodes.join('\n'));
                                  setState(() {
                                    isCopied = true;
                                  });
                                },
                                icon:
                                    isCopied
                                        ? Icon(Icons.check)
                                        : Icon(Icons.copy),
                                label: Text('Copy Backup Codes'),
                              ),
                            ],
                          ),
                          Text(
                            'Please save these codes in a secure location',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              FilledButton(
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => Login(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Done',
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
                        ],
                      ),
                    ),
                  ],
                ),
              )
              : ContentContainer(
                margin: EdgeInsets.only(
                  left: width > 1024 ? width * 0.33 : 0,
                  right: width > 1024 ? width * 0.33 : 0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Register',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onInverseSurface,
                      ),
                    ),
                    ContentContainer(
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      margin: EdgeInsets.only(top: 32),
                      child: Column(
                        children: [
                          AutofillGroup(
                            child: TextField(
                              controller: firstNameController,
                              decoration: InputDecoration(
                                labelText: 'First Name',
                                prefixIcon: Icon(Icons.text_fields),
                              ),
                              autofillHints: [AutofillHints.givenName],
                              onSubmitted: (value) => register(context),
                            ),
                          ),
                          AutofillGroup(
                            child: TextField(
                              controller: lastNameController,
                              decoration: InputDecoration(
                                labelText: 'Last Name',
                                prefixIcon: Icon(Icons.text_fields),
                              ),
                              autofillHints: [AutofillHints.familyName],
                              onSubmitted: (value) => register(context),
                            ),
                          ),
                          AutofillGroup(
                            child: TextField(
                              controller: usernameController,
                              decoration: InputDecoration(
                                labelText: 'Username',
                                prefixIcon: Icon(Icons.person),
                              ),
                              autofillHints: [AutofillHints.username],
                              onSubmitted: (value) => register(context),
                            ),
                          ),
                          AutofillGroup(
                            child: TextField(
                              controller: passwordController,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: Icon(Icons.password),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isPasswordVisible = !isPasswordVisible;
                                    });
                                  },
                                ),
                              ),
                              autofillHints: [AutofillHints.password],
                              obscureText: !isPasswordVisible,
                              onSubmitted: (value) => register(context),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                FilledButton(
                                  onPressed: () {
                                    register(context);
                                  },
                                  child: Text(
                                    'Register',
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
                      margin: EdgeInsets.only(top: 32),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FilledButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Login(),
                                ),
                              );
                            },
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
    );
  }
}
