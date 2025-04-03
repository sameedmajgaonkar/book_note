import 'dart:convert';
import 'package:book_note/models/book.dart';
import 'package:http/http.dart' as http;

// Fetch all the books in the library.
Future<List<Book>> fetchBooks() async {
  final response = await http.get(
    Uri.parse("https://book-note-backend.onrender.com/api/books"),
  );
  final List<Book> books;
  if (response.statusCode == 200) {
    final List<dynamic> jsonData = jsonDecode(response.body);
    books = jsonData.map((book) => Book.fromJson(book)).toList();
    return books;
  } else {
    throw FormatException("Failed to load book");
  }
}

// Books to read
Future<List<Book>> fetchBookQueue() async {
  final response = await http.get(
    Uri.parse("https://book-note-backend.onrender.com/api/books/queue"),
  );
  final List<Book> books;
  if (response.statusCode == 200) {
    final List<dynamic> jsonData = jsonDecode(response.body);
    books = jsonData.map((book) => Book.fromJson(book)).toList();
    return books;
  } else {
    throw FormatException("Failed to load book");
  }
}

// Book Details
Future<Book> fetchBook(String id) async {
  final response = await http.get(
    Uri.parse("https://book-note-backend.onrender.com/api/books/$id"),
  );
  if (response.statusCode == 200) {
    return Book.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw FormatException("Failed to load book");
  }
}

// Update Book
Future<Book> updateBook({
  required String id,
  bool bookQueue = true,
  bool hasRead = false,
}) async {
  final response = await http.patch(
    Uri.parse("https://book-note-backend.onrender.com/api/books/$id"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, bool>{
      'bookQueue': bookQueue,
      'hasRead': hasRead,
    }),
  );

  if (response.statusCode == 200) {
    return Book.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw FormatException("Failed to load book");
  }
}
