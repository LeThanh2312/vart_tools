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
  int? idFolder;
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
    this.idFolder,
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
    String datetime_tmp = DateTime.now().toString();
    return {
      DbFile.id: id,
      DbFile.name: name,
      DbFile.image: image ??= null,
      DbFile.dateCreate: dateCreate ??= datetime_tmp,
      DbFile.dateUpdate: dateUpdate ??= datetime_tmp,
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
            format CHARACTER(20) NOT NULL,
            idFolder INTEGER NOT NULL,
            tag TEXT,
            is_favourite TINYINT DEFAULT 0,
            is_delete TINYINT DEFAULT 0,
            FOREIGN KEY (idFolder) REFERENCES folders (id)
            )""",
        );
      },
      version: 1,
    );
  }

  Future<List<FileModel>> getFiles(int folderId) async {
    final db = await initializeDB();
    final List<Map<String, dynamic>> maps;
    maps = await db.query(
      DbFile.tableName,
      where: 'is_delete = ? and idFolder=?',
      whereArgs: ['0', folderId],
    );

    return List.generate(maps.length, (i) {
      return FileModel(
        id: maps[i][DbFile.id],
        name: maps[i][DbFile.name],
        image: maps[i][DbFile.image],
        dateCreate: maps[i][DbFile.dateCreate],
        dateUpdate: maps[i][DbFile.dateUpdate],
        link: maps[i][DbFile.link],
        size: maps[i][DbFile.size],
        format: maps[i][DbFile.format],
        idFolder: maps[i][DbFile.idFolder],
        tag: maps[i][DbFile.tag],
        isFavourite: maps[i][DbFile.isFavourite],
        isDelete: maps[i][DbFile.isDelete],
      );
    });
  }

  Future<void> insertFile(FileModel file) async {
    final db = await initializeDB();
    try {
      await db.insert(
        'files',
        file.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteFile(List<int?> ids) async {
    var data = {DbFile.isDelete: '1'};
    final db = await initializeDB();
    for (int? id in ids) {
      await db.update(
        DbFile.tableName,
        data,
        where: 'id = ?',
        whereArgs: [id],
      );
    }
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

  Future<void> addTags(List<FileModel> files, String tag) async {
    final db = await initializeDB();
    files.forEach((file) async {
      file.tag = tag;
      file.dateUpdate = DateTime.now().toString();
      await db.update(
        'files',
        file.toMap(),
        where: 'id = ?',
        whereArgs: [file.id],
      );
    });
  }

  Future<void> permanentlyDeletefiles(List<int> ids) async {
    final db = await initializeDB();
    await db.delete(
      DbFile.tableName,
      where: "id IN (${List.filled(ids.length, '?').join(',')})",
      whereArgs: ids,
    );
  }

  Future<void> recoveryFiles(List<int> ids) async {
    final db = await initializeDB();
    final data = {"is_delete": '0'};
    for (int id in ids) {
      final result = await db.update(
        DbFile.tableName,
        data,
        where: 'id = ?',
        whereArgs: [id],
      );
    }
  }

  Future<List<FileModel>> getFilesFavourite() async {
    final db = await initializeDB();
    final List<Map<String, dynamic>> maps = await db.query(
      DbFile.tableName,
      where: 'is_favourite = ? and is_delete = ?',
      whereArgs: ['1', '0'],
    );
    return List.generate(maps.length, (i) {
      return FileModel(
        id: maps[i][DbFile.id],
        name: maps[i][DbFile.name],
        image: maps[i][DbFile.image],
        dateCreate: maps[i][DbFile.dateCreate],
        dateUpdate: maps[i][DbFile.dateUpdate],
        link: maps[i][DbFile.link],
        size: maps[i][DbFile.size],
        format: maps[i][DbFile.format],
        idFolder: maps[i][DbFile.idFolder],
        tag: maps[i][DbFile.tag],
        isFavourite: maps[i][DbFile.isFavourite],
        isDelete: maps[i][DbFile.isDelete],
      );
    });
  }

  Future<List<FileModel>> getFilesTrash() async {
    final db = await initializeDB();
    final List<Map<String, dynamic>> maps = await db.query(
      DbFile.tableName,
      where: 'is_delete = ?',
      whereArgs: ['1'],
    );
    return List.generate(maps.length, (i) {
      return FileModel(
        id: maps[i][DbFile.id],
        name: maps[i][DbFile.name],
        image: maps[i][DbFile.image],
        dateCreate: maps[i][DbFile.dateCreate],
        dateUpdate: maps[i][DbFile.dateUpdate],
        link: maps[i][DbFile.link],
        size: maps[i][DbFile.size],
        format: maps[i][DbFile.format],
        idFolder: maps[i][DbFile.idFolder],
        tag: maps[i][DbFile.tag],
        isFavourite: maps[i][DbFile.isFavourite],
        isDelete: maps[i][DbFile.isDelete],
      );
    });
  }

  Future close() async => db.close();
}

enum IdType { folder, file }

class SelectIdTrashModel {
  final int id;
  final IdType type;
  final String image;
  SelectIdTrashModel({required this.id, required this.type,required this.image});

  Map<String, Object?> toMap() {
    String datetime_tmp = DateTime.now().toString();
    return {
      "id": id,
      "type": type,
      "image": image,
    };
  }
}
