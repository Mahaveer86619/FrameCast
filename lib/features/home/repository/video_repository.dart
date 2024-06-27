import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:framecast/core/resources/data_state.dart';
import 'package:framecast/features/home/models/video_metadata.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VideoRepository {
  final SupabaseClient supabaseClient;

  VideoRepository(this.supabaseClient);

  Future<DataState<String>> uploadVideo(File video, String videoId) async {
    try {
      await supabaseClient.storage.from('videos').upload(
            '$videoId/video',
            video,
          );
      final String publicUrl =
          supabaseClient.storage.from('videos').getPublicUrl('$videoId/video');
      return DataSuccess(publicUrl);
    } catch (e) {
      throw DataFailure('error: ${e.toString()}', -1);
    }
  }

  Future<DataState<String>> uploadThumbnail(
      File thumbnail, String videoId) async {
    try {
      await supabaseClient.storage.from('videos').upload(
            '$videoId/thumbnail',
            thumbnail,
          );
      final String publicUrl = supabaseClient.storage
          .from('videos')
          .getPublicUrl('$videoId/thumbnail');
      return DataSuccess(publicUrl);
    } catch (e) {
      throw DataFailure('error: ${e.toString()}', -1);
    }
  }

  Future<void> saveVideoMetadata(VideoMetadata metadata) async {
    try {
      await supabaseClient.from('videos').insert(metadata.toJson());
    } catch (e) {
      debugPrint('error: ${e.toString()}');
    }
  }

  Future<List<VideoMetadata>> getVideos() async {
    try {
      final res = await supabaseClient.from('videos').select('*, profiles (*)');
      final videos = res.map((video) => VideoMetadata.fromJson(video).copyWith(
        ownerPicUrl: video['profiles']['avatar_url'],
        ownerName: video['profiles']['username'],
      )).toList();

      debugPrint('videos: ${videos.length}');

      return videos;
    } catch (e) {
      debugPrint('error: ${e.toString()}');
      return [];
    }
  }
}
