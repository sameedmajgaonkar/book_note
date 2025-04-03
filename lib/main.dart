import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'book_list.dart';
import 'book_form.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorSchemeSeed: Colors.green,
        brightness: Brightness.dark,
        fontFamily: "Poppins",
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Book Note"),
        leading: Icon(Icons.auto_stories),
      ),
      body: Center(child: BookList()),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BookForm()),
          );
        },
        label: const Text("Add a book"),
        icon: Icon(Icons.library_add),
      ),
    );
  }
}
