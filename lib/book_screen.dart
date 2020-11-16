import 'package:flutter/material.dart';
import 'book.dart';
import 'database_helper.dart';

class BookScreen extends StatefulWidget {
  final Book book;
  BookScreen(this.book);
  @override
  State<StatefulWidget> createState() => new _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  DatabaseHelper db = new DatabaseHelper();
  TextEditingController _titleController;
  TextEditingController _authorController;
  TextEditingController _pagesController;
  TextEditingController _priceController;
  @override
  void initState() {
    super.initState();
    _titleController = new TextEditingController(text: widget.book.title);
    _authorController = new TextEditingController(text: widget.book.author);
    _pagesController = new TextEditingController(text: widget.book.pages);
    _priceController = new TextEditingController(text: widget.book.price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  (widget.book.id != null)
            ? Text('Alter Book')
            : Text('Register Book'),
        backgroundColor: Colors.brown,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16.0),
              child:
            Image.asset(
                'images/book.png',
                height: 100,
                fit: BoxFit.fill,
                width: 200
            )
            ),
            // Padding(padding: new EdgeInsets.all(8.0)),
            textFormField(_titleController,'Title'),
            Padding(padding: new EdgeInsets.all(5.0)),
            textFormField(_authorController,'Author'),
            Padding(padding: new EdgeInsets.all(5.0)),
            textFormField(_pagesController, 'Pages'),
            Padding(padding: new EdgeInsets.all(5.0)),
            textFormField(_priceController, 'Price'),
            Padding(padding: new EdgeInsets.all(5.0)),
            RaisedButton(
              child: (widget.book.id != null)
                  ? Text('Update')
                  : Text('Register'),
              onPressed: () {
                if (widget.book.id != null) {
                  db
                      .updateBook(Book.fromMap({
                    'id': widget.book.id,
                    'title': _titleController.text,
                    'author': _authorController.text,
                    'pages': _pagesController.text,
                    'price': _priceController.text,
                  }))
                      .then((_) {
                    Navigator.pop(context, 'update');
                  });
                } else {
                  db
                      .insertBook(Book(
                      _titleController.text,
                      _authorController.text,
                      _pagesController.text,
                      _priceController.text))
                      .then((_) {
                    Navigator.pop(context, 'save');
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
  textFormField(TextEditingController tec, String label) {
    var padding = Padding(
      padding: const EdgeInsets.only(
        top: 10,
      ),
      child: TextFormField(
        controller: tec,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
            hintText: label,
            border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      ),
    );
    return padding;
  }
}

