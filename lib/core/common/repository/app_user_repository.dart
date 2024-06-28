import 'dart:io';

import 'package:flutter/material.dart';
import 'package:framecast/core/common/models/app_user_model.dart';
import 'package:framecast/core/resources/data_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class AppUserRepository {
  final SupabaseClient _supabaseClient;

  AppUserRepository(this._supabaseClient);

  Future<DataState<UserModel>> getUser(String userId) async {
    try {
      final data = await _supabaseClient
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();

      if (data.isNotEmpty) {
        return DataSuccess(UserModel.fromJson(data));
      } else {
        return const DataFailure('User not found', -1);
      }
    } catch (e) {
      debugPrint('Error getting user: $e');
      return DataFailure(e.toString(), -1);
    }
  }

  Future<String> uploadAvatar(String userId, File avatarFile) async {
    try {
      debugPrint('avatarFile: ${avatarFile.path}');
      final extra = const Uuid().v1();
      await _supabaseClient.storage.from('avatars').upload(
            '$userId/$extra',
            avatarFile,
          );
      final String publicUrl = _supabaseClient.storage
          .from('avatars')
          .getPublicUrl('$userId/$extra');
      await _supabaseClient.from('profiles').update({
        'avatar_url': publicUrl,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', userId);
      return publicUrl;
    } catch (e) {
      debugPrint('Error uploading avatar: $e');
      rethrow;
    }
  }

  Future<void> updateUser(
    String userId,
    String username,
  ) async {
    try {
      await _supabaseClient.from('profiles').update({
        'username': username,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', userId);
    } catch (e) {
      debugPrint('Error uploading avatar: $e');
      rethrow;
    }
  }
}
