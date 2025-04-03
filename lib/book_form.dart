import 'package:flutter/material.dart';
import 'main.dart';
import 'models/book.dart';
import 'services/book_note_api.dart';

class BookForm extends StatefulWidget {
  const BookForm({super.key});

  @override
  State<BookForm> createState() => _BookFormState();
}

class _BookFormState extends State<BookForm> {
  final _formKey = GlobalKey<FormState>();
  late Future<List<Book>> books;
  late List<Book> bookList = [];
  final titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    books = fetchBooks();
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Book")),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              "Choose a book to read",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) async {
                if (textEditingValue.text == "") {
                  return const <String>[];
                }
                bookList = await books;
                return bookList
                    .map((Book book) => book.title)
                    .where(
                      (String option) => option.toLowerCase().contains(
                        textEditingValue.text.toLowerCase(),
                      ),
                    )
                    .toList();
              },
              optionsViewBuilder: (context, onSelected, options) {
                return ListView.builder(
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final option = options.elementAt(index);
                    Book selectedBook = bookList.singleWhere(
                      (Book book) => book.title.toLowerCase().contains(
                        option.toLowerCase(),
                      ),
                    );
                    return Container(
                      color: Theme.of(context).colorScheme.surface,
                      child: ListTile(
                        title: Text(option),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(selectedBook.cover),
                          backgroundColor: Colors.transparent,
                        ),
                        onTap: () => onSelected(option),
                      ),
                    );
                  },
                );
              },

              fieldViewBuilder: (
                context,
                textEditingController,
                focusNode,
                onFieldSubmitted,
              ) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextFormField(
                    controller: textEditingController,
                    focusNode: focusNode,
                    onEditingComplete: onFieldSubmitted,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Title is required";
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Title of the Book",
                      suffixIcon: Icon(Icons.library_books),
                    ),
                  ),
                );
              },

              onSelected:
                  (String selection) => titleController.text = selection,
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Adding book ${titleController.text}..."),
                    ),
                  );
                  Book selectedBook = bookList.singleWhere(
                    (Book book) => book.title.toLowerCase().contains(
                      titleController.text.toLowerCase(),
                    ),
                  );
                  await updateBook(id: selectedBook.id);
                  if (context.mounted) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  }
                }
              },
              child: const Text("Add"),
            ),
          ],
        ),
      ),
    );
  }
}
