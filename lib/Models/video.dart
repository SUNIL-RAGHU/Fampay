class Video {
  final int id;
  final String title;
  final String description;
  final DateTime publishedAt;
  final String thumbnailsURL;

  Video({
    required this.id,
    required this.title,
    required this.description,
    required this.publishedAt,
    required this.thumbnailsURL,
  });
}
