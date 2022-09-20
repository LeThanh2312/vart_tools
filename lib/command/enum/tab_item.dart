enum TabItem { home, file, favourite, setting}

extension TabItemExtention on TabItem? {
  String get name {
    switch (this) {
      case TabItem.home:
        return 'Trang chủ';
      case TabItem.file:
        return 'Tệp';
      case TabItem.favourite:
        return 'Yêu Thích';
      case TabItem.setting:
        return 'Cài đặt';
      default:
    }
    return '';
  }
}