import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:framecast/core/common/constants/app_constants.dart';
import 'package:framecast/core/common/models/app_user_model.dart';
import 'package:framecast/core/common/repository/app_user_repository.dart';
import 'package:framecast/core/resources/data_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'app_user_state.dart';

class AppUserCubit extends Cubit<AppUserState> {
  final SharedPreferences _sharedPreferences;
  final AppUserRepository _appUserRepository;
  final SupabaseClient _supabaseClient;

  AppUserCubit({
    required SharedPreferences sharedPreferences,
    required AppUserRepository appUserRepository,
    required SupabaseClient supabaseClient,
  })  : _appUserRepository = appUserRepository,
        _sharedPreferences = sharedPreferences,
        _supabaseClient = supabaseClient,
        super(AppUserInitial());

  void updateAppUser(String userId) async {
    final user = await _appUserRepository.getUser(userId);
    if (user is DataSuccess) {
      saveUserDetails(user.data!);
      emit(AppUserLoggedIn());
    } else {
      emit(AppUserInitial());
    }
  }

  Future<void> loadUser() async {
    final userJson = _sharedPreferences.getString(prefUserKey);
    if (userJson != null) {
      emit(AppUserLoggedIn());
    } else {
      emit(AppUserInitial());
    }
  }

  Future<void> logout() async {
    await _sharedPreferences.remove(prefUserKey);
    emit(AppUserInitial());
  }

  Future<void> saveUserDetails(UserModel user) async {
    await _sharedPreferences.setString(prefUserKey, jsonEncode(user.toJson()));
  }

  Future<UserModel> getUserDetails() async {
    final userJson = _sharedPreferences.getString(prefUserKey);
    if (userJson != null) {
      final user = UserModel.fromJson(jsonDecode(userJson));
      final res = await _appUserRepository.getUser(user.id);

      if (res is DataSuccess) {
        saveUserDetails(res.data!);
        return res.data!;
      } else {
        return const UserModel(
          id: '',
          username: '',
          email: '',
          avatarUrl: '',
        );
      }
    } else {
      return const UserModel(
        id: '',
        username: '',
        email: '',
        avatarUrl: '',
      );
    }
  }

  Future<void> updateUser(
    String userId,
    String username,
    File avatarFile,
  ) async {
    final user = await getUserDetails();
    UserModel newUser = user;

    if (avatarFile.path != '') {
      final res = await _appUserRepository.uploadAvatar(userId, avatarFile);
      newUser = user.copyWith(avatarUrl: res);
    }

    if (username != user.username) {
      await _appUserRepository.updateUser(userId, username);
      newUser = user.copyWith(username: username);
    }
    await _sharedPreferences.setString(
      prefUserKey,
      jsonEncode(
        newUser.toJson(),
      ),
    );
  }

  Future<void> signOut() async {
    await _sharedPreferences.remove(prefUserKey);
    await _supabaseClient.auth.signOut();
    emit(AppUserInitial());
  }
}
