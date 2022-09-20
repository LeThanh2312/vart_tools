import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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
      join(path, 'folder.db'),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE folder(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL,)",
        );
      },
      version: 1,
    );
  }

  Future<void> insertFolder(FolderDatabase folder) async {
    final db = await initializeDB();

    await db.insert(
      'folders',
      folder.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteUser(int id) async {
    final db = await initializeDB();
    await db.delete(
      'folders',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> update(FolderDatabase folder) async {
    final db = await initializeDB();
    await db.update(
      'folders',
      folder.toMap(),
      where: 'id = ?',
      whereArgs: [folder.id],
    );
  }

  Future close() async => db.close();
}
