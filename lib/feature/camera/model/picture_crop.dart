import 'dart:io';

class PictureCrop {
  PictureCrop({
    this.picture,
    this.index,
  });

  File? picture;
  int? index;

  factory PictureCrop.fromJson(Map<String, dynamic> json) => PictureCrop(
      picture: json['picture'],
      index:json['index']
      );
}
