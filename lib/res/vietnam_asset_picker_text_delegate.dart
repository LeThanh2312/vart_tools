import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class VietnameseAssetPickerTextDelegate extends AssetPickerTextDelegate {
  const VietnameseAssetPickerTextDelegate();

  @override
  String get languageCode => 'vi';

  @override
  String get confirm => 'Đồng ý';

  @override
  String get cancel => 'Hủy';

  @override
  String get edit => 'Sửa';

  @override
  String get gifIndicator => 'GIF';

  @override
  String get loadFailed => 'Load failed';

  @override
  String get original => 'Origin';

  @override
  String get preview => 'Xem trước';

  @override
  String get select => 'Chọn';

  @override
  String get emptyList => 'Danh sách trống';

  @override
  String get unSupportedAssetType => 'Unsupported HEIC asset type.';

  @override
  String get unableToAccessAll => 'Unable to access all assets on the device';

  @override
  String get viewingLimitedAssetsTip =>
      'Only view assets and albums accessible to app.';

  @override
  String get changeAccessibleLimitedAssets =>
      'Click to update accessible assets';

  @override
  String get accessAllTip => 'App can only access some assets on the device. '
      'Go to system settings and allow app to access all assets on the device.';

  @override
  String get goToSystemSettings => 'Go to system settings';

  @override
  String get accessLimitedAssets => 'Continue with limited access';

  @override
  String get accessiblePathName => 'Accessible assets';

  @override
  String get sTypeAudioLabel => 'Audio';

  @override
  String get sTypeImageLabel => 'Image';

  @override
  String get sTypeVideoLabel => 'Video';

  @override
  String get sTypeOtherLabel => 'Other asset';

  @override
  String get sActionPlayHint => 'play';

  @override
  String get sActionPreviewHint => 'preview';

  @override
  String get sActionSelectHint => 'select';

  @override
  String get sActionSwitchPathLabel => 'switch path';

  @override
  String get sActionUseCameraHint => 'use camera';

  @override
  String get sNameDurationLabel => 'duration';

  @override
  String get sUnitAssetCountLabel => 'count';
}
