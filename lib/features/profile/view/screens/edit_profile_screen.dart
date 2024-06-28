import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:framecast/core/common/models/app_user_model.dart';
import 'package:framecast/features/home/view/widgets/input_field.dart';
import 'package:framecast/features/profile/bloc/profile_bloc.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  final UserModel user;

  const EditProfilePage({
    super.key,
    required this.user,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _usernameController = TextEditingController();
  File _avatarFile = File('');

  Future _pickAvatar() async {
    try {
      final returnedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );

      setState(() {
        _avatarFile = File(returnedImage!.path);
      });
    } catch (e) {
      debugPrint('Error picking picture: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _fab(),
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
          if (state is ProfileUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Profile updated successfully',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            );

            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return _buildLoading();
          }
          if (state is ProfileLoaded) {
            return _buildBody();
          }
          return Container();
        },
      ),
    );
  }

  _fab() {
    return FloatingActionButton(
      onPressed: () {
        context.read<ProfileBloc>().add(
              UpdateProfile(
                id: widget.user.id,
                username: _usernameController.text == ''
                    ? widget.user.username
                    : _usernameController.text.trim(),
                avatarFile:
                    _avatarFile.path == '' ? File('') : File(_avatarFile.path),
              ),
            );
      },
      child: const Icon(Icons.save),
    );
  }

  _appBar() {
    return AppBar(
      title: Text(
        'Edit Profile',
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
      ),
      backgroundColor: Colors.transparent,
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_vert),
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

  _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                _pickAvatar();
              },
              child: ClipOval(
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  radius: 100,
                  child: _avatarFile.path != ''
                      ? Image.file(
                          _avatarFile,
                          width: 200,
                          height: 200,
                        )
                      : CachedNetworkImage(
                          imageUrl: widget.user.avatarUrl,
                          fit: BoxFit.cover,
                          width: 200,
                          height: 200,
                        ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: MyInputField(
                hintText: 'Username',
                controller: _usernameController,
                validator: (value) {
                  if (value!.isNotEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                lines: 1,
                initialValue: widget.user.username,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
