import 'dart:convert';
import 'package:riverpod/riverpod.dart';
import '../models/user.dart';
import '../requests/endpoints.dart';
import 'package:http/http.dart' as http;
import '../providers/auth.dart';

final usersProvider = AsyncNotifierProvider<UsersNotifier, List<User>>(
  () => UsersNotifier(),
);

class UsersNotifier extends AsyncNotifier<List<User>> {
  @override
  Future<List<User>> build() async {
    return [];
  }

  Future<void> getUsers(String teamId) async {
    final auth = ref.read(authProvider);
    if (auth == null || auth.value == null || !auth.isValid) {
      state = AsyncError(
        'Not logged in. Please login to continue.',
        StackTrace.current,
      );
      return;
    }

    try {
      final response = await http.get(
        Uri.parse("$teamsPath/$teamId/users"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${auth.value}',
        },
      );

      final body = jsonDecode(response.body);

      if (body['error'] == null) {
        final List<User> users = [];
        for (var e in body['data'] as List) {
          users.add(User.fromJson(e));
        }
        state = AsyncData(users);
        return;
      }

      state = AsyncError(body['error'], StackTrace.current);
    } catch (e) {
      state = AsyncError(e.toString(), StackTrace.current);
    }
  }
}
