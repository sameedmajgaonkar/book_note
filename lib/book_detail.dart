import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import "models/book.dart";
import 'services/book_note_api.dart';

class BookDetail extends StatefulWidget {
  final String id;
  const BookDetail({super.key, required this.id});

  @override
  State<BookDetail> createState() => _BookDetailState();
}

class _BookDetailState extends State<BookDetail> {
  late Future<Book> bookData;
  late Book book;
  late bool hasRead;
  @override
  void initState() {
    super.initState();
    bookData = fetchBook(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Book Details")),
      body: FutureBuilder(
        future: bookData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            book = snapshot.data!;
            hasRead = book.hasRead;
            return SingleChildScrollView(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.0),
                child: Column(
                  spacing: 20,
                  children: [
                    Image.network(
                      book.cover,
                      height: 250,
                      width: 300,
                      fit: BoxFit.contain,
                    ),
                    GradientText(
                      book.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                      gradientDirection: GradientDirection.ttb,
                      colors: [Colors.green, Colors.greenAccent],
                    ),
                    Text(
                      book.description,
                      style: TextStyle(color: Colors.grey.shade500),
                      textAlign: TextAlign.center,
                    ),
                    Container(
                      decoration: BoxDecoration(color: Colors.grey.shade900),
                      child: ListTile(
                        title: Text("${book.rating}"),
                        leading: Icon(Icons.star, color: Colors.amber),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(color: Colors.grey.shade900),
                      child: ListTile(
                        title: Text(book.author),
                        leading: Icon(Icons.person),
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 10.0,
                      children: [
                        Switch(
                          value: hasRead,
                          onChanged: (value) async {
                            await updateBook(id: book.id, hasRead: value);

                            setState(() {
                              bookData = fetchBook(widget.id);
                            });
                          },
                        ),
                        Text("Mark As Read"),
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
