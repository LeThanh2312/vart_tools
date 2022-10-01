enum CameraType { cardID, passport, document, unSelect}

extension CameraTypeExtention on CameraType? {
  String get name {
    switch (this) {
      case CameraType.cardID:
        return 'Thẻ ID';
      case CameraType.passport:
        return 'Hộ chiếu';
      case CameraType.document:
        return 'Văn bản';
      case CameraType.unSelect:
        return '';
      default:
    }
    return '';
  }
}
