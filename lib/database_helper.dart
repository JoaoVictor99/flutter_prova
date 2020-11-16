import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'book.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  static Database _db;
  DatabaseHelper.internal();
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'book.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE book(id INTEGER PRIMARY KEY, title TEXT, author TEXT, pages TEXT, price TEXT)');
  }

  Future<int> insertBook(Book book) async {
    var dbClient = await db;
    var result = await dbClient.insert("book", book.toMap());
    return result;
  }

  Future<List> getBooks() async {
    var dbClient = await db;
    var result = await dbClient.query("book", columns: ["id", "title", "author", "pages", "price"]);
    return result.toList();
  }

  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery('SELECT COUNT(*) FROM book'));
  }

  Future<Book> getBook(int id) async {
    var dbClient = await db;
    List<Map> result = await dbClient.query("book",
        columns: ["id", "name", "title", "pages", "price"],
        where: 'id = ?',
        whereArgs: [id]);
    if (result.length > 0) {
      return new Book.fromMap(result.first);
    }
    return null;
  }

  Future<int> deleteBook(int id) async {
    var dbClient = await db;
    return await dbClient.delete("book", where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateBook(Book book) async {
    var dbClient = await db;
    return await dbClient.update("book", book.toMap(),
        where: "id = ?", whereArgs: [book.id]);
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
