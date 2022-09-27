import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:vart_tools/res/strings.dart';

class FileModel {
  final int? id;
  String name;
  String? image;
  String? dateCreate;
  String? dateUpdate;
  int? size;
  String? format;
  String idFolder;
  String? link;
  String? tag;
  int? isFavourite;
  int? isDelete;

  FileModel({
    this.id,
    required this.name,
    this.image,
    this.dateCreate,
    this.dateUpdate,
    this.size,
    this.format,
    required this.idFolder,
    this.link,
    this.tag,
    this.isFavourite,
    this.isDelete,
  });

  FileModel.fromMap(Map<String, dynamic> res)
      : id = res[DbFile.id],
        name = res[DbFile.name],
        image = res[DbFile.image],
        dateCreate = res[DbFile.dateCreate],
        dateUpdate = res[DbFile.dateUpdate],
        link = res[DbFile.link],
        size = res[DbFile.size],
        format = res[DbFile.format],
        idFolder = res[DbFile.idFolder],
        tag = res[DbFile.tag],
        isFavourite = res[DbFile.isFavourite],
        isDelete = res[DbFile.isDelete];

  Map<String, Object?> toMap() {
    return {
      DbFile.id: id,
      DbFile.name: name,
      DbFile.image: image ??= null,
      DbFile.dateCreate: dateCreate ??= DateTime.now().toString(),
      DbFile.dateUpdate: dateUpdate ??= DateTime.now().toString(),
      DbFile.link: link ??= null,
      DbFile.size: size ??= null,
      DbFile.format: format ??= null,
      DbFile.idFolder: idFolder,
      DbFile.tag: tag ??= null,
      DbFile.isFavourite: isFavourite ??= 0,
      DbFile.isDelete: isDelete ??= 0,
    };
  }
}

class FileProvider {
  late Database db;

  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'files.db'),
      onCreate: (database, version) async {
        await database.execute(
          """CREATE TABLE files(
            id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
            name TEXT NOT NULL,
            image TEXT,
            date_create TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            date_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            link TEXT,
            size SMALLINT,
            format CHARACTER(20),
            idFolder INTEGER,
            tag TEXT,
            favourite TINYINT DEFAULT 0,
            is_delete TINYINT DEFAULT 0
            )""",
        );
      },
      version: 1,
    );
  }

  Future<void> insertFile(FileModel file) async {
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

  Future<void> updateFile(FileModel file) async {
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
