enum SavePictureType {
  create,
  selector,
}

extension SavePictureTypeExtention on SavePictureType? {
  String get name {
    switch (this) {
      case SavePictureType.create:
        return 'Thư mục mới';
      case SavePictureType.selector:
        return 'Chọn thư mục';
      default:
    }
    return '';
  }
}
