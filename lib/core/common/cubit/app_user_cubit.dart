import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:framecast/core/common/constants/app_constants.dart';
import 'package:framecast/core/common/models/app_user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_user_state.dart';

class AppUserCubit extends Cubit<AppUserState> {
  final FlutterSecureStorage _secureStorage;
  final SharedPreferences _sharedPreferences;

  AppUserCubit({
    required FlutterSecureStorage secureStorage,
    required SharedPreferences sharedPreferences,
  })  : _secureStorage = secureStorage,
        _sharedPreferences = sharedPreferences,
        super(AppUserInitial());

  void updateUser() {
    saveUserDetails(const UserModel(id: "init", username: "init", email: "init", avatarUrl: "init"));
    emit(AppUserLoggedIn());
  }

  Future<void> loadUser() async {
    final userJson = _sharedPreferences.getString(prefUserKey);
    if (userJson != null) {
      // final user = UserModel.fromJson(jsonDecode(userJson));
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
}
