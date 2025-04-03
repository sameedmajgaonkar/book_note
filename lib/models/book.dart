class Book {
  final String id;
  final String title;
  final String description;
  final String author;
  final String cover;
  final num rating;
  final bool hasRead;
  final bool bookQueue;

  const Book({
    required this.id,
    required this.title,
    required this.description,
    required this.rating,
    required this.author,
    required this.cover,
    required this.hasRead,
    required this.bookQueue,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    try {
      return Book(
        id: json["_id"] as String,
        title: json["title"] as String,
        description: json["description"] as String,
        author: json["author"] as String,
        cover: json["cover"] as String,
        rating: json["rating"] as num,
        hasRead: json["hasRead"] as bool,
        bookQueue: json["bookQueue"] as bool,
      );
    } catch (e) {
      print("Error parsing book: ${json["title"]} - $e");
      throw FormatException("Invalid format: $e");
    }
  }
}
