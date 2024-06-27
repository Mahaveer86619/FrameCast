import 'package:flutter/material.dart';
import 'package:framecast/core/common/models/app_user_model.dart';
import 'package:framecast/core/resources/data_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  Future<DataState<void>> updateUser(String userId, UserModel user) async {
    try {
      final response = await _supabaseClient.from('profiles').update({
        'username': user.username,
        'email': user.email,
        'avatar_url': user.avatarUrl,
      }).eq('id', userId);

      if (response.error != null) {
        return DataFailure(response.error!.message, -1);
      }

      return const DataSuccess(null);
    } catch (e) {
      return DataFailure(e.toString(), -1);
    }
  }
}
