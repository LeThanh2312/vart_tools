enum FilterItem { blur, shadows, fullAngle, brightness, ecological,bVW,}

extension FilterItemExtention on FilterItem? {
  String get name {
    switch (this) {
      case FilterItem.blur:
        return 'Làm mờ';
      case FilterItem.shadows:
        return 'Thang độ xám';
      case FilterItem.fullAngle:
        return 'Nguyên góc';
      case FilterItem.brightness:
        return 'Làm sáng';
      case FilterItem.ecological:
        return 'Sinh thái';
      case FilterItem.bVW:
        return 'B&W';
      default:
    }
    return '';
  }
}