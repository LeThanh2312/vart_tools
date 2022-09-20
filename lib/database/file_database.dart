import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class FileDatabase {
  final String id;
  final String name;
  final String image;
  final DateTime? dateCreate;
  final DateTime? dateUpdate;
  final int? size;
  final String? format;
  final String? idFolder;
  final String? link;
  final String? tag;
  final bool? favourite;

  FileDatabase({
    required this.id,
    required this.name,
    required this.image,
    this.dateCreate,
    this.dateUpdate,
    this.size,
    this.format,
    this.idFolder,
    this.link,
    this.tag,
    this.favourite,
  });

  FileDatabase.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        name = res["name"],
        image = res["image"],
        dateCreate = res["date_create"],
        dateUpdate = res["date_update"],
        link = res["link"],
        size = res["size"],
        format = res["format"],
        idFolder = res["idFolder"],
        tag = res["tag"],
        favourite = res["favourite"];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'image': name,
      'date_create': dateCreate,
      'date_update': dateUpdate,
      'link': link,
      'size': size,
      'format': format,
      'idFolder': idFolder,
      'tag': tag,
      'favourite': favourite,
    };
  }
}

class FileProvider {
  late Database db;

  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'file.db'),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE file(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL)",
        );
      },
      version: 1,
    );
  }

  Future<void> insertFile(FileDatabase file) async {
    final db = await initializeDB();

    await db.insert(
      'files',
      file.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteFile(int id) async {
    final db = await initializeDB();
    await db.delete(
      'files',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> updateFile(FileDatabase file) async {
    final db = await initializeDB();
    await db.update(
      'files',
      file.toMap(),
      where: 'id = ?',
      whereArgs: [file.id],
    );
  }

  Future close() async => db.close();
}
