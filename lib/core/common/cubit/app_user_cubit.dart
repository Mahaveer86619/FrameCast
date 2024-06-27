import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:framecast/core/common/constants/app_constants.dart';
import 'package:framecast/core/common/models/app_user_model.dart';
import 'package:framecast/core/common/repository/app_user_repository.dart';
import 'package:framecast/core/resources/data_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_user_state.dart';

class AppUserCubit extends Cubit<AppUserState> {
  final FlutterSecureStorage _secureStorage;
  final SharedPreferences _sharedPreferences;
  final AppUserRepository _appUserRepository;

  AppUserCubit({
    required FlutterSecureStorage secureStorage,
    required SharedPreferences sharedPreferences,
    required AppUserRepository appUserRepository,
  })  : _appUserRepository = appUserRepository,
        _secureStorage = secureStorage,
        _sharedPreferences = sharedPreferences,
        super(AppUserInitial());

  void updateUser(String userId) async {
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

  Future<UserModel> getUserDetails() async {
    //! Not a good way to use DataState but whatever
    final userJson = _sharedPreferences.getString(prefUserKey);
    if (userJson != null) {
      return UserModel.fromJson(jsonDecode(userJson));
    } else {
      return const UserModel(
        id: '',
        username: '',
        email: '',
        avatarUrl: '',
      );
    }
  }
}
