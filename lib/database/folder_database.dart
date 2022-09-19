import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'file_database.dart';

class FolderDatabase {
  final String? id;
  final String name;
  final String? dateCreate;
  final String? dateUpdate;
  final String? link;
  final bool? favourite;

  FolderDatabase({
    required this.id,
    required this.name,
    this.dateCreate,
    this.dateUpdate,
    this.link,
    this.favourite,
  });

  FolderDatabase.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        name = res["name"],
        dateCreate = res["date_create"],
        dateUpdate = res["date_update"],
        link = res["link"],
        favourite = res["favourite"];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'date_create': dateCreate,
      'date_update': dateUpdate,
      'link': link,
      'favourite': favourite,
    };
  }
}

class FolderProvider {
  late Database db;

  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'example.db'),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL,age INTEGER NOT NULL, country TEXT NOT NULL, email TEXT)",
        );
      },
      version: 1,
    );
  }

  Future<void> deleteUser(int id) async {
    final db = await initializeDB();
    await db.delete(
      'users',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> update(FileDatabase todo) async {
    return await db.update(
      'users',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  Future close() async => db.close();
}
