import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:framecast/core/common/cubit/app_user_cubit.dart';
import 'package:framecast/features/home/models/video_metadata.dart';
import 'package:framecast/features/home/repository/video_repository.dart';
import 'package:uuid/uuid.dart';

part 'video_event.dart';
part 'video_state.dart';

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  final VideoRepository _videoRepository;
  final AppUserCubit _appUserCubit;

  VideoBloc({
    required VideoRepository videoRepository,
    required AppUserCubit appUserCubit,
  })  : _videoRepository = videoRepository,
        _appUserCubit = appUserCubit,
        super(VideoInitial()) {
    on<VideoEvent>((_, emit) => emit(Loading()));
    on<UploadVideo>(_uploadVideo);
    on<GetVideos>(_getVideos);
  }

  Future<void> _getVideos(GetVideos event, Emitter<VideoState> emit) async {
    try {
      emit(Loading());
      // Didnot use datastate as there is no error handling in supabase
      final videos = await _videoRepository.getVideos();
      emit(VideosLoaded(videos: videos));
    } catch (e) {
      emit(Error(error: e.toString()));
    }
  }

  Future<void> _uploadVideo(
    UploadVideo event,
    Emitter<VideoState> emit,
  ) async {
    try {
      emit(Loading());

      final user = await _appUserCubit.getUserDetails();
      if (user.id != '') {
        final videoId = const Uuid().v1();

        final videoUrl = await _videoRepository.uploadVideo(
          event.video,
          videoId,
        );
        final thumbnailUrl = await _videoRepository.uploadThumbnail(
          event.thumbnail,
          videoId,
        );

        await _videoRepository.saveVideoMetadata(VideoMetadata(
          id: videoId,
          title: event.title,
          description: event.description,
          createdAt: DateTime.now(),
          videoUrl: videoUrl.data!,
          thumbnailUrl: thumbnailUrl.data!,
          ownerId: user.id,
        ));
      }

      emit(VideoUploaded());
    } catch (e) {
      emit(Error(error: e.toString()));
    }
  }
}
