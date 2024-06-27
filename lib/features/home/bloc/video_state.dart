part of 'video_bloc.dart';

sealed class VideoState extends Equatable {
  const VideoState();

  @override
  List<Object> get props => [];
}

class VideoInitial extends VideoState {}

class Loading extends VideoState {}

class VideosLoaded extends VideoState {
  final List<VideoMetadata> videos;

  const VideosLoaded({required this.videos});

  @override
  List<Object> get props => [videos];
}

class VideoUploaded extends VideoState {}

class Error extends VideoState {
  final String error;

  const Error({required this.error});

  @override
  List<Object> get props => [error];
}
