import 'package:flutter/material.dart';
import 'book.dart';
import 'database_helper.dart';
import 'book_screen.dart';

class ListViewBook extends StatefulWidget {
  @override
  _ListViewBookState createState() => new _ListViewBookState();
}

class _ListViewBookState extends State<ListViewBook> {
  List<Book> library = new List();

  DatabaseHelper db = new DatabaseHelper();
  @override
  void initState() {
    super.initState();
    db.getBooks().then((books) {
      setState(() {
        books.forEach((book) {
          library.add(Book.fromMap(book));
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventory',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Library'),
          centerTitle: true,
          backgroundColor: Colors.brown,
        ),
        body: Center(
          child: ListView.builder(
              itemCount: library.length,
              padding: const EdgeInsets.all(15.0),

              itemBuilder: (context, position) {
                return Column(
                  children: [

                    Divider(height: 5.0),
                    ListTile(
                      title: Text(
                        '${library[position].title}',
                        style: TextStyle(
                          fontSize: 22.0,
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Row(children: [
                        Text(
                            '${library[position].title} ${library[position].author} ${library[position].pages} ${library[position].price}',
                            style: new TextStyle(
                              fontSize: 18.0,
                              fontStyle: FontStyle.italic,
                            )),
                        IconButton(
                            icon: const Icon(Icons.delete_forever),
                            color: Colors.red,
                            onPressed: () => _deleteBook(
                                context, library[position], position)),
                      ]),
                      onTap: () => _navigateToBook(context, library[position]),
                    ),
                  ],
                );
              }),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.book),
          onPressed: () => _createNewBook(context),
          backgroundColor: Colors.brown,
        ),
      ),
    );
  }

  void _deleteBook(
      BuildContext context, Book book, int position) async {
    db.deleteBook(book.id).then((book) {
      setState(() {
        library.removeAt(position);
      });
    });
  }

  void _navigateToBook(BuildContext context, Book book) async {
    String result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BookScreen(book)),
    );
    if (result == 'update') {
      db.getBooks().then((book) {
        setState(() {
          library.clear();
          book.forEach((book) {
            library.add(Book.fromMap(book));
          });
        });
      });
    }
  }

  void _createNewBook(BuildContext context) async {
    String result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>  BookScreen(Book('', '', '', ''))),
    );

    if (result == 'save') {
      db.getBooks().then((book) {
        setState(() {
          library.clear();
          book.forEach((book) {
            library.add(Book.fromMap(book));
          });
        });
      });
    }
  }
}
