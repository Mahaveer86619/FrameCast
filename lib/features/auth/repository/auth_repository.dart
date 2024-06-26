import 'package:framecast/core/common/constants/app_constants.dart';
import 'package:framecast/core/resources/data_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseClient _supabaseClient;

  AuthRepository(this._supabaseClient);

  Future<DataState<void>> signUp(
    String username,
    String email,
    String password,
  ) async {
    try {
      final response = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {
          'username': username,
          'email': email,
          'avatar_url': defaultAvatarUrl,
        },
      );

      if (response.user == null) {
        return const DataFailure('Something went wrong', -1);
      }

      return const DataSuccess(null);
    } catch (e) {
      return DataFailure(e.toString(), -1);
    }
  }

  Future<DataState<void>> signIn(
    String email,
    String password,
  ) async {
    try {
      final response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        return const DataFailure('Something went wrong', -1);
      }

      return const DataSuccess(null);
    } catch (e) {
      return DataFailure(e.toString(), -1);
    }
  }
}
