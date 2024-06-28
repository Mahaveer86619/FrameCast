part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class GetProfile extends ProfileEvent {
  const GetProfile();

  @override
  List<Object> get props => [];
}

class UpdateProfile extends ProfileEvent {
  final String id;
  final String username;
  final File? avatarFile;

  const UpdateProfile({
    required this.id,
    required this.username,
    this.avatarFile,
  });

  @override
  List<Object> get props => [id, username, avatarFile!.path == '' ? File('') : avatarFile!];
}

class SignOut extends ProfileEvent {}
