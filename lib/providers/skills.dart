import 'dart:convert';
import 'package:capabilities_app/requests/endpoints.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../models/skill.dart';
import '../providers/auth.dart';

final skillsProvider = AsyncNotifierProvider<SkillNotifier, List<Skill>>(
  () => SkillNotifier(),
);

class SkillNotifier extends AsyncNotifier<List<Skill>> {
  @override
  Future<List<Skill>> build() async {
    return [];
  }

  Future<void> getSkills() async {
    final token = ref.read(authProvider);

    if (token == null || token.value == null) {
      state = AsyncError("You're not logged in", StackTrace.current);
      return;
    }

    if (!token.isValid) {
      state = AsyncError(
        "Login expired. Please log in again.",
        StackTrace.current,
      );
      return;
    }

    final response = await http.get(
      Uri.parse(mySkillsPath),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token.value}',
      },
    );

    final body = jsonDecode(response.body);

    if (body['error'] != null) {
      state = AsyncError(body['message'], StackTrace.current);
      return;
    }

    final skills = <Skill>[];
    for (var skill in body['data']) {
      skills.add(Skill.fromJson(skill));
    }

    state = AsyncData(skills);
  }
}

final createSkillProvider = AsyncNotifierProvider<CreateSkillNotifier, Skill?>(
  () => CreateSkillNotifier(),
);

class CreateSkillNotifier extends AsyncNotifier<Skill?> {
  @override
  Future<Skill?> build() async {
    return null;
  }

  Future<void> createSkill(Skill skill) async {
    final token = ref.read(authProvider);

    if (token == null || token.value == null) {
      state = AsyncError("You're not logged in", StackTrace.current);
      return;
    }

    if (!token.isValid) {
      state = AsyncError(
        "You're login has expired. Please login again.",
        StackTrace.current,
      );
    }

    final response = await http.post(
      Uri.parse(mySkillsPath),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token.value}',
      },
      body: jsonEncode(skill.toJson()),
    );

    final body = jsonDecode(response.body);

    if (body['error'] != null) {
      state = AsyncError(body['message'], StackTrace.current);
      return;
    }

    state = AsyncData(Skill.fromJson(body['data']));
  }
}

final updateSkillProvider = AsyncNotifierProvider<UpdateSkillNotifier, Skill?>(
  () => UpdateSkillNotifier(),
);

class UpdateSkillNotifier extends AsyncNotifier<Skill?> {
  @override
  Future<Skill?> build() async {
    return null;
  }

  Future<void> updateSkill(Skill skill) async {
    final token = ref.read(authProvider);

    if (token == null || token.value == null) {
      state = AsyncError("You're not logged in", StackTrace.current);
      return;
    }

    if (!token.isValid) {
      state = AsyncError(
        "You're login has expired. Please login again.",
        StackTrace.current,
      );
    }

    final response = await http.put(
      Uri.parse('$mySkillsPath/${skill.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token.value}',
      },
      body: jsonEncode(skill.toJson()),
    );

    final body = jsonDecode(response.body);

    if (body['error'] != null) {
      state = AsyncError(body['message'], StackTrace.current);
      return;
    }

    state = AsyncData(Skill.fromJson(body['data']));
  }
}

final deleteSkillProvider = AsyncNotifierProvider<DeleteSkillNotifier, Skill?>(
  () => DeleteSkillNotifier(),
);

class DeleteSkillNotifier extends AsyncNotifier<Skill?> {
  @override
  Future<Skill?> build() async {
    return null;
  }

  Future<void> deleteSkill(Skill skill) async {
    final token = ref.read(authProvider);

    if (token == null || token.value == null) {
      state = AsyncError("You're not logged in", StackTrace.current);
      return;
    }

    if (!token.isValid) {
      state = AsyncError(
        "You're login has expired. Please login again.",
        StackTrace.current,
      );
    }

    final response = await http.delete(
      Uri.parse('$mySkillsPath/${skill.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token.value}',
      },
    );

    final body = jsonDecode(response.body);

    if (body['error'] != null) {
      state = AsyncError(body['message'], StackTrace.current);
      return;
    }

    state = AsyncData(skill);
  }
}
