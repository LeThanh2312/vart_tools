import '../../res/assets.dart';

enum FilterItem { blur, grayScale, fullAngle, brightness, ecological,bVW,}

extension FilterItemExtention on FilterItem? {
  String get name {
    switch (this) {
      case FilterItem.blur:
        return 'Làm mờ';
      case FilterItem.grayScale:
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

  String get image {
    switch (this) {
      case FilterItem.blur:
        return ResAssets.images.blur;
      case FilterItem.grayScale:
        return ResAssets.images.grayScale;
      case FilterItem.fullAngle:
        return ResAssets.images.origin;
      case FilterItem.brightness:
        return ResAssets.images.brightness;
      case FilterItem.ecological:
        return ResAssets.images.bio;
      case FilterItem.bVW:
        return ResAssets.images.blackWhile;
      default:
    }
    return '';
  }

}