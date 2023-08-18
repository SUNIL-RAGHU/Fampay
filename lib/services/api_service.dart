import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/video.dart';
import '../constants/api_constants.dart';

class ApiService {
  static Future<List<Video>> fetchVideos(int page) async {
    final uri = Uri.parse('${Uri.encodeFull(ApiConstants.baseUrl)}/videos?page=$page');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((video) {
        return Video(
          id: video['ID'],
          title: video['Title'],
          description: video['Description'],
          publishedAt: DateTime.parse(video['PublishedAt']),
          thumbnailsURL: video['ThumbnailsURL'],
        );
      }).toList();
    } else {
      throw Exception('Failed to load videos');
    }
  }
}
