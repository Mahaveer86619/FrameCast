import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:framecast/core/common/cubit/app_user_cubit.dart';
import 'package:framecast/core/themes/theme.dart';
import 'package:framecast/features/auth/bloc/auth_bloc.dart';
import 'package:framecast/features/auth/view/screens/sign_in_screen.dart';
import 'package:framecast/features/home/bloc/video_bloc.dart';
import 'package:framecast/features/home/view/screens/home_screen.dart';
import 'package:framecast/injection_container.dart' as di;

void main() async {
  await setup();
  runApp(const MainApp());
}

Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await di.registerServices();

  final appUserCubit = di.sl<AppUserCubit>();
  await appUserCubit.loadUser();
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppUserCubit>(
          create: (context) => di.sl<AppUserCubit>(),
        ),
        BlocProvider<AuthBloc>(
          create: (_) => di.sl<AuthBloc>(),
        ),
        BlocProvider<VideoBloc>(
          create: (_) => di.sl<VideoBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'FrameCast',
        theme: lightMode,
        darkTheme: darkMode,
        home: const AuthGate(),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppUserCubit, AppUserState>(
      builder: (context, state) {
        if (state is AppUserLoggedIn) {
          return const HomePage();
        } else {
          return const SignInPage();
        }
      },
    );
  }
}
