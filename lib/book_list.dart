import 'package:flutter/material.dart';
import 'book_detail.dart';
import 'models/book.dart';
import 'services/book_note_api.dart';

class BookList extends StatefulWidget {
  const BookList({super.key});

  @override
  State<BookList> createState() => _BookListState();
}

class _BookListState extends State<BookList> {
  late Future<List<Book>> books;
  late List<Book> bookList = [];
  @override
  void initState() {
    super.initState();
    books = fetchBookQueue();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Book>>(
      future: books,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          bookList = snapshot.data!;
          return ListView.builder(
            itemCount: bookList.length,
            itemBuilder: (context, index) {
              return Dismissible(
                key: Key(bookList[index].id),
                background: Container(
                  color: Theme.of(context).colorScheme.errorContainer,
                ),
                onDismissed: (direction) async {
                  await updateBook(id: bookList[index].id, bookQueue: false);
                  setState(() {
                    bookList.removeAt(index);
                  });
                },
                child: ListTile(
                  title: Text(bookList[index].title),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(bookList[index].cover),
                    backgroundColor: Colors.transparent,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => BookDetail(id: bookList[index].id),
                      ),
                    );
                  },
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return AlertDialog(title: Text(snapshot.error.toString()));
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
