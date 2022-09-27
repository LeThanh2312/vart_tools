class DbFolder {
  static const String tableName = 'folders';
  static const String id = 'id';
  static const String name = 'name';
  static const String dateCreate = 'date_create';
  static const String dateUpdate = 'date_update';
  static const String link = 'link';
  static const String favourite = 'favourite';
  static const String isDelete = 'is_delete';
}

class DbFile {
  static const String id = 'id';
  static const String name = 'name';
  static const String image = 'image';
  static const String dateCreate = 'date_create';
  static const String dateUpdate = 'date_update';
  static const String link = 'link';
  static const String size = 'size';
  static const String format = 'format';
  static const String idFolder = 'id_folder';
  static const String tag = 'tag';
  static const String isFavourite = 'is_favourite';
  static const String isDelete = 'is_delete';
}
