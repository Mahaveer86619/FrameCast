import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:framecast/features/home/bloc/video_bloc.dart';
import 'package:framecast/features/home/models/video_metadata.dart';
import 'package:framecast/features/home/view/screens/add_video_screen.dart';
import 'package:framecast/features/home/view/screens/play_video_screen.dart';
import 'package:framecast/features/home/view/widgets/video_tile.dart';
import 'package:framecast/features/profile/view/screens/profile_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    context.read<VideoBloc>().add(GetVideos());
  }

  @override
  void dispose() {
    super.dispose();
  }

  _changeScreen(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ),
    ).then((_) {
      context.read<VideoBloc>().add(GetVideos());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _fab(),
      appBar: _appBar(),
      body: BlocConsumer<VideoBloc, VideoState>(
        listener: (context, state) {
          if (state is Error) {
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
        },
        builder: (context, state) {
          if (state is Loading) {
            return _buildLoading();
          }
          if (state is VideosLoaded) {
            if (state.videos.isEmpty) {
              return _buildEmptyBody();
            }
            return _buildBody(state.videos);
          }
          return Container();
        },
      ),
    );
  }

  _fab() {
    return FloatingActionButton(
      onPressed: () {
        _changeScreen(const AddVideoPage());
      },
      child: const Icon(Icons.add),
    );
  }

  _appBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(
        'FrameCast',
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
      ),
      backgroundColor: Colors.transparent,
      actions: [
        CircleAvatar(
          child: IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              _changeScreen(const ProfilePage());
            },
          ),
        ),
        const SizedBox(width: 12),
      ],
    );
  }

  _buildEmptyBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/images/empty_box.svg',
          height: MediaQuery.of(context).size.height * 0.4,
          width: MediaQuery.of(context).size.width * 0.4,
        ),
        Text(
          'No videos uploaded yet',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
        const SizedBox(height: 70),
      ],
    );
  }

  _buildBody(List<VideoMetadata> videos) {
    return ListView.builder(
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final video = videos[index];
        return VideoTile(
          onTap: () {
            _changeScreen(PlayVideoPage(video: video));
          },
          video: video,
          ownerPicUrl: video.ownerPicUrl ?? '',
          ownerName: video.ownerName ?? '',
        );
      },
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
}
