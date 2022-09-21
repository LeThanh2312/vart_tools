enum CameraType { cardID, passport, document }

extension CameraTypeExtention on CameraType? {
  String get name {
    switch (this) {
      case CameraType.cardID:
        return 'Thẻ ID';
      case CameraType.passport:
        return 'Hộ chiếu';
      case CameraType.document:
        return 'Văn bản';
      default:
    }
    return '';
  }
}
