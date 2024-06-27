import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:framecast/features/home/bloc/video_bloc.dart';
import 'package:framecast/features/home/view/widgets/input_field.dart';
import 'package:image_picker/image_picker.dart';

class AddVideoPage extends StatefulWidget {
  const AddVideoPage({super.key});

  @override
  State<AddVideoPage> createState() => _AddVideoPageState();
}

class _AddVideoPageState extends State<AddVideoPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  File _videoFile = File('');
  File _thumbnailFile = File('');

  Future _pickVideo() async {
    try {
      final returnedVideo =
          await ImagePicker().pickVideo(source: ImageSource.gallery);

      setState(() {
        _videoFile = File(returnedVideo!.path);
      });
    } catch (e) {
      debugPrint('Error picking video: $e');
    }
  }

  Future<void> _pickThumbnail() async {
    try {
      final returnedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      setState(() {
        _thumbnailFile = File(returnedImage!.path);
      });
    } catch (e) {
      debugPrint('Error picking picture: $e');
    }
  }

  void _uploadVideo() {
    if (_videoFile.path.isNotEmpty && _thumbnailFile.path.isNotEmpty) {
      context.read<VideoBloc>().add(
            UploadVideo(
              video: _videoFile,
              thumbnail: _thumbnailFile,
              title: _titleController.text.trim(),
              description: _descriptionController.text.trim(),
            ),
          );
    } else {
      // Show error message if form is not valid or files are not selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.error,
          content: Text(
            'Please fill all fields and pick files',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onError,
                ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Upload Video',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
      ),
      body: BlocConsumer<VideoBloc, VideoState>(
        listener: (context, state) {
          if (state is VideoUploaded) {
            setState(() {
              _videoFile = File('');
              _thumbnailFile = File('');
              _titleController.clear();
              _descriptionController.clear();
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Video uploaded successfully')),
            );
          } else if (state is Error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.error}')),
            );
          }
        },
        builder: (context, state) {
          if (state is Loading) {
            return _loading();
          }
          if (state is VideoUploaded) {
            return _buildBody();
          }
          return _buildBody();
        },
      ),
    );
  }

  _loading() {
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
          'Uploading video...',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
      ],
    );
  }

  _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // thumbnail
            GestureDetector(
              onTap: _pickThumbnail,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: MediaQuery.of(context).size.width * 1,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  child: _thumbnailFile.path == ''
                      ? _buildThumbnailContainer()
                      : Image.file(_thumbnailFile, fit: BoxFit.cover),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // video
            GestureDetector(
              onTap: _pickVideo,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: MediaQuery.of(context).size.width * 1,
                  height: 60,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  child: _buildVideoContainer(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // metadata
            Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: MyInputField(
                    hintText: 'Enter Video title',
                    controller: _titleController,
                    validator: (value) {
                      if (value!.isNotEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                    lines: 3,
                  ),
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: MyInputField(
                    hintText: 'Enter Video discription',
                    controller: _descriptionController,
                    validator: (value) {
                      if (value!.isNotEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                    lines: 7,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // upload button
            ElevatedButton(
              onPressed: _uploadVideo,
              child: const Text('Upload'),
            ),
          ],
        ),
      ),
    );
  }

  _buildThumbnailContainer() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_a_photo,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          const SizedBox(height: 10),
          Text(
            'Add Thumbnail',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
        ],
      ),
    );
  }

  _buildVideoContainer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Add Video',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
        _videoFile.path == ''
            ? Icon(
                Icons.video_library_rounded,
                color: Theme.of(context).colorScheme.onSurface,
              )
            : const Icon(
                Icons.done_rounded,
                color: Colors.green,
              ),
      ],
    );
  }
}
