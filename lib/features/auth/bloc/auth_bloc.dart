import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:framecast/core/common/cubit/app_user_cubit.dart';
import 'package:framecast/core/resources/data_state.dart';
import 'package:framecast/features/auth/repository/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRemoteRepository;
  final AppUserCubit _appUserCubit;

  AuthBloc({
    required AuthRepository authRemoteRepository,
    required AppUserCubit appUserCubit,
  })  : _appUserCubit = appUserCubit,
        _authRemoteRepository = authRemoteRepository,
        super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<SignUpEvent>(_onSignUp);
    on<SignInEvent>(_onSignIn);
  }

  Future<void> _onSignUp(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _authRemoteRepository.signUp(
      event.username,
      event.email,
      event.password,
    );
    if (res is DataSuccess) {
      _appUserCubit.updateUser(res.data!);
      emit(Authenticated());
    } else {
      emit(AuthError(res.error!, res.statusCode!));
    }
  }

  Future<void> _onSignIn(SignInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _authRemoteRepository.signIn(
      event.email,
      event.password,
    );
    if (res is DataSuccess) {
      _appUserCubit.updateUser(res.data!);
      emit(Authenticated());
    } else {
      emit(AuthError(res.error!, res.statusCode!));
    }
  }
}
