part of 'video_bloc.dart';

sealed class VideoEvent extends Equatable {
  const VideoEvent();

  @override
  List<Object> get props => [];
}

class GetVideos extends VideoEvent {}

class UploadVideo extends VideoEvent {
  final File thumbnail;
  final File video;
  final String title;
  final String description;

  const UploadVideo({
    required this.thumbnail,
    required this.video,
    required this.title,
    required this.description,
  });

  @override
  List<Object> get props => [thumbnail, video, title, description];
}