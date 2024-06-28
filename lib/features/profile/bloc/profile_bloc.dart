import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:framecast/core/common/cubit/app_user_cubit.dart';
import 'package:framecast/core/common/models/app_user_model.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AppUserCubit _appUserCubit;
  ProfileBloc({
    required AppUserCubit appUserCubit,
  })  : _appUserCubit = appUserCubit,
        super(ProfileInitial()) {
    on<ProfileEvent>((event, emit) => emit(ProfileLoading()));
    on<GetProfile>(_getProfile);
    on<UpdateProfile>(_updateProfile);
    on<SignOut>(_signOut);
  }

  Future<void> _getProfile(GetProfile event, Emitter<ProfileState> emit) async {
    try {
      final user = await _appUserCubit.getUserDetails();
      emit(ProfileLoaded(user));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _updateProfile(
      UpdateProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      await _appUserCubit.updateUser(
        event.id,
        event.username,
        event.avatarFile!,
      );
      emit(ProfileUpdated());
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _signOut(SignOut event, Emitter<ProfileState> emit) async {
    await _appUserCubit.signOut();
    emit(ProfileSignedOut());
  }
}
