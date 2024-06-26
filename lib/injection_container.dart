import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:framecast/core/common/cubit/app_user_cubit.dart';
import 'package:framecast/features/auth/bloc/auth_bloc.dart';
import 'package:framecast/features/auth/repository/auth_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final sl = GetIt.instance;

Future<void> registerServices() async {
  //* Supabase
  await Supabase.initialize(
    url: dotenv.get('SupabaseProjectUrl'),
    anonKey: dotenv.get('SupabaseApiKey'),
  );
  sl.registerSingleton<SupabaseClient>(Supabase.instance.client);

  //* Register SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  //* Register FlutterSecureStorage
  const secureStorage = FlutterSecureStorage();
  sl.registerSingleton<FlutterSecureStorage>(secureStorage);

  //* Core
  //* Register AppUserCubit
  sl.registerLazySingleton<AppUserCubit>(() => AppUserCubit(
        secureStorage: sl<FlutterSecureStorage>(),
        sharedPreferences: sl<SharedPreferences>(),
      ));

  //* Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepository(sl()));

  //* ViewModels
  //* Register AuthBloc
  sl.registerFactory<AuthBloc>(() => AuthBloc(
        authRemoteRepository: sl<AuthRepository>(),
        appUserCubit: sl<AppUserCubit>(),
      ));
}
