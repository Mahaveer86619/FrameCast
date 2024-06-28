import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:framecast/core/common/models/app_user_model.dart';
import 'package:framecast/features/profile/bloc/profile_bloc.dart';
import 'package:framecast/features/profile/view/screens/edit_profile_screen.dart';
import 'package:framecast/main.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(const GetProfile());
  }

  _changeScreen(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ),
    ).then((_) {
      context.read<ProfileBloc>().add(const GetProfile());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Theme.of(context).colorScheme.error,
                content: Text(
                  'Error: ${state.error}',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onError,
                      ),
                ),
              ),
            );
          }
          if (state is ProfileSignedOut) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const AuthGate(),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return _buildLoading();
          }
          if (state is ProfileLoaded) {
            return _buildBody(state.user);
          }
          return Container();
        },
      ),
    );
  }

  _appBar() {
    return AppBar(
      title: Text(
        'Profile',
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
      ),
      backgroundColor: Colors.transparent,
      actions: [
        IconButton(
          onPressed: () {
            context.read<ProfileBloc>().add(SignOut());
          },
          icon: const Icon(Icons.exit_to_app),
        ),
      ],
    );
  }

  _buildLoading() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const CircularProgressIndicator.adaptive(),
        const Row(
          children: [
            SizedBox(width: 10),
          ],
        ),
        Text(
          'Loading...',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
      ],
    );
  }

  _buildBody(UserModel user) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: CachedNetworkImageProvider(user.avatarUrl),
            ),
            const Row(
              children: [
                SizedBox(height: 16),
              ],
            ),
            Text(
              user.username,
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              user.email,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _changeScreen(EditProfilePage(user: user));
              },
              child: const Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
