part of 'app_user_cubit.dart';

sealed class AppUserState extends Equatable {
  const AppUserState();

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
final class AppUserInitial extends AppUserState {}

final class AppUserLoggedIn extends AppUserState {}
