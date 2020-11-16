class Book {
  int _id;
  String _title;
  String _author;
  String _pages;
  String _price;

  Book(this._title, this._author, this._pages, this._price);

  Book.map(dynamic obj) {
    this._id = obj['id'];
    this._title = obj['title'];
    this._author = obj['author'];
    this._pages = obj['pages'];
    this._price = obj['price'];
  }

  int get id => _id;
  String get title => _title;
  String get author => _author;
  String get pages => _pages;
  String get price => _price;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['author'] = _author;
    map['pages'] = _pages;
    map['price'] = _price;
    return map;
  }

  Book.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._author = map['author'];
    this._pages = map['pages'];
    this._price = map['price'];
  }
}
