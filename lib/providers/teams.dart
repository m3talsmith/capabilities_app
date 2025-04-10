import 'dart:async';
import 'dart:convert';
import 'package:riverpod/riverpod.dart';
import '../models/team.dart';
import '../requests/endpoints.dart';
import 'package:http/http.dart' as http;
import '../providers/auth.dart';

final teamsProvider = AsyncNotifierProvider<TeamsNotifier, List<Team>>(
  () => TeamsNotifier(),
);

class TeamsNotifier extends AsyncNotifier<List<Team>> {
  @override
  Future<List<Team>> build() async {
    return [];
  }

  Future<void> getTeams() async {
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
        Uri.parse(teamsPath),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${auth.value}',
        },
      );

      final body = jsonDecode(response.body);

      if (body['error'] == null) {
        final List<Team> teams = [];
        for (var e in body['data'] as List) {
          teams.add(Team.fromJson(e));
        }
        state = AsyncData(teams);
        return;
      }

      state = AsyncError(body['message'], StackTrace.current);
    } catch (e) {
      state = AsyncError(
        'Failed to get teams. Please try again later.',
        StackTrace.current,
      );
    }
  }
}

final createTeamProvider = AsyncNotifierProvider<CreateTeamNotifier, Team>(
  () => CreateTeamNotifier(),
);

class CreateTeamNotifier extends AsyncNotifier<Team> {
  @override
  Future<Team> build() async {
    return Team();
  }

  Future<void> createTeam({
    required String teamName,
    String? teamDescription,
  }) async {
    final auth = ref.read(authProvider);
    if (auth == null || auth.value == null || !auth.isValid) {
      state = AsyncError(
        'Not logged in. Please login to continue.',
        StackTrace.current,
      );
      return;
    }

    state = AsyncLoading();

    try {
      final response = await http.post(
        Uri.parse(myTeamsPath),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${auth.value}',
        },
        body: jsonEncode({
          'teamName': teamName,
          'teamDescription': teamDescription,
        }),
      );

      final body = jsonDecode(response.body);

      if (body['error'] == null) {
        state = AsyncData(Team.fromJson(body));
        return;
      }

      state = AsyncError(body['message'], StackTrace.current);
    } catch (e) {
      state = AsyncError(
        'Failed to create team. Please try again later.',
        StackTrace.current,
      );
    }
  }
}

final editTeamProvider = AsyncNotifierProvider<EditTeamNotifier, Team>(
  () => EditTeamNotifier(),
);

class EditTeamNotifier extends AsyncNotifier<Team> {
  @override
  FutureOr<Team> build() {
    return Team();
  }

  Future<void> editTeam({required Team team}) async {
    final auth = ref.read(authProvider);
    if (auth == null || auth.value == null || !auth.isValid) {
      state = AsyncError(
        'Not logged in. Please login to continue.',
        StackTrace.current,
      );
      return;
    }

    state = AsyncLoading();

    try {
      final response = await http.put(
        Uri.parse('$myTeamsPath/${team.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${auth.value}',
        },
        body: jsonEncode({
          'teamName': team.teamName,
          'teamDescription': team.teamDescription,
        }),
      );

      final body = jsonDecode(response.body);

      if (body['error'] == null) {
        state = AsyncData(team);
        return;
      }

      state = AsyncError(body['message'], StackTrace.current);
    } catch (e) {
      print(e);
      state = AsyncError(
        'Failed to update team. Please try again later.',
        StackTrace.current,
      );
    }
  }
}

final deleteTeamProvider = AsyncNotifierProvider<DeleteTeamNotifier, Team>(
  () => DeleteTeamNotifier(),
);

class DeleteTeamNotifier extends AsyncNotifier<Team> {
  @override
  FutureOr<Team> build() {
    return Team();
  }

  Future<void> deleteTeam({required Team team}) async {
    final auth = ref.read(authProvider);
    if (auth == null || auth.value == null || !auth.isValid) {
      state = AsyncError(
        'Not logged in. Please login to continue.',
        StackTrace.current,
      );
      return;
    }

    state = AsyncLoading();

    try {
      final response = await http.delete(
        Uri.parse('$myTeamsPath/${team.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${auth.value}',
        },
      );

      final body = jsonDecode(response.body);

      if (body['error'] == null) {
        state = AsyncData(team);
        return;
      }

      state = AsyncError(body['message'], StackTrace.current);
    } catch (e) {
      state = AsyncError(
        'Failed to delete team. Please try again later.',
        StackTrace.current,
      );
    }
  }
}
