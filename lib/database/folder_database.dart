import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:vart_tools/res/strings.dart';

class FolderModel {
  final int? id;
  String? name;
  String? dateCreate;
  String? dateUpdate;
  String? link;
  int? favourite;
  int? isDelete;

  FolderModel({
    this.id,
    this.name,
    this.dateCreate,
    this.dateUpdate,
    this.link,
    this.favourite,
    this.isDelete,
  });

  FolderModel.fromMap(Map<String, dynamic> res)
      : id = res[DbFolder.id],
        name = res[DbFolder.name],
        dateCreate = res[DbFolder.dateCreate],
        dateUpdate = res[DbFolder.dateUpdate],
        link = res[DbFolder.link],
        favourite = res[DbFolder.favourite],
        isDelete = res[DbFolder.isDelete];

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      DbFolder.id: id,
      DbFolder.name: name,
      DbFolder.link: (link == null) ? null : link,
      DbFolder.dateCreate:
          (dateCreate == null) ? DateTime.now().toString() : dateCreate,
      DbFolder.dateUpdate:
          (dateUpdate == null) ? DateTime.now().toString() : dateUpdate,
      DbFolder.favourite: (favourite == null) ? 0 : favourite,
      DbFolder.isDelete: (isDelete == null) ? 0 : isDelete,
    };
    if (id != null) {
      map[DbFolder.id] = id;
    }
    return map;
  }
}

class FolderProvider {
  late Database db;

  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'folder.db'),
      version: 1,
      onCreate: (database, version) async {
        await database.execute(
          """CREATE TABLE folders(
            id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            name TEXT NOT NULL,
            date_create TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            date_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            link TEXT,
            favourite INTEGER DEFAULT 0,
            is_delete INTEGER DEFAULT 0
           )""",
        );
      },
    );
  }

  Future<int> insertFolder(FolderModel folder) async {
    final db = await initializeDB();
    int result = await db.insert(
      DbFolder.tableName,
      folder.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return result;
  }

  Future<void> deleteFolder(int id, FolderModel folderDb) async {
    final db = await initializeDB();
    await db.delete(
      DbFolder.tableName,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> permanentlyDeleteFolders(List<int> ids) async {
    final db = await initializeDB();
    await db.delete(
      DbFolder.tableName,
      where: "id IN (${List.filled(ids.length, '?').join(',')})",
      whereArgs: ids,
    );
  }

  Future<void> recoveryFolders(List<int> ids) async {
    final db = await initializeDB();
    final data = {"is_delete": '0'};
    for (int id in ids) {
      final result = await db.update(
        DbFolder.tableName,
        data,
        where: 'id = ?',
        whereArgs: [id],
      );
    }
    // final result = await db.rawUpdate(
    //     'UPDATE folders SET is_delete = ? WHERE id = IN (${List.filled(ids.length, '?').join(',')})',
    //     [0, ids]);
    // final result = await db.update(DbFolder.tableName, data,
    //     where: 'id = IN (${List.filled(ids.length, '?').join(',')})',
    //     whereArgs: ids);
  }

  Future<void> update(FolderModel folder) async {
    final db = await initializeDB();
    final result = await db.update(
      DbFolder.tableName,
      folder.toMap(),
      where: 'id = ?',
      whereArgs: [folder.id],
    );
  }

  Future<List<FolderModel>> getFolders(int? id) async {
    final db = await initializeDB();
    final List<Map<String, dynamic>> maps;
    if (id == null) {
      maps = await db.query(
        DbFolder.tableName,
        where: 'is_delete = ?',
        whereArgs: ['0'],
      );
    } else {
      maps = await db.query(
        DbFolder.tableName,
        where: 'id = ?',
        whereArgs: [id],
      );
    }

    return List.generate(maps.length, (i) {
      return FolderModel(
        id: maps[i][DbFolder.id],
        name: maps[i][DbFolder.name],
        dateCreate: maps[i][DbFolder.dateCreate],
        dateUpdate: maps[i][DbFolder.dateUpdate],
        favourite: maps[i][DbFolder.favourite],
        isDelete: maps[i][DbFolder.isDelete],
        link: maps[i][DbFolder.link],
      );
    });
  }

  Future<List<FolderModel>> getFoldersTrash() async {
    final db = await initializeDB();
    final List<Map<String, dynamic>> maps = await db.query(
      DbFolder.tableName,
      where: 'is_delete = ?',
      whereArgs: ['1'],
    );
    return List.generate(maps.length, (i) {
      return FolderModel(
        id: maps[i][DbFolder.id],
        name: maps[i][DbFolder.name],
        dateCreate: maps[i][DbFolder.dateCreate],
        dateUpdate: maps[i][DbFolder.dateUpdate],
        favourite: maps[i][DbFolder.favourite],
        isDelete: maps[i][DbFolder.isDelete],
        link: maps[i][DbFolder.link],
      );
    });
  }

  Future<List<FolderModel>> getFoldersFavourite() async {
    final db = await initializeDB();
    final List<Map<String, dynamic>> maps = await db.query(
      DbFolder.tableName,
      where: 'favourite = ?',
      whereArgs: ['1'],
    );
    return List.generate(maps.length, (i) {
      return FolderModel(
        id: maps[i][DbFolder.id],
        name: maps[i][DbFolder.name],
        dateCreate: maps[i][DbFolder.dateCreate],
        dateUpdate: maps[i][DbFolder.dateUpdate],
        favourite: maps[i][DbFolder.favourite],
        isDelete: maps[i][DbFolder.isDelete],
        link: maps[i][DbFolder.link],
      );
    });
  }

  Future close() async => db.close();
}
