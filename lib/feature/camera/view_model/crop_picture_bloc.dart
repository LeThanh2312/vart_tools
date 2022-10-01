import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opencv/opencv.dart';
import 'package:image_size_getter/image_size_getter.dart' as imgsize;
import 'package:vart_tools/common/enum/filter_item.dart';
import 'package:opencv/core/core.dart';
import '../../../common/enum/camera_type.dart';

enum CropAndFilterPictureStatus { loading, success, failure, initialize }

abstract class CameraPictureEvent {}

class CropAndFilterPictureState {
  List<Uint8List> pictureCrop;
  List<Uint8List> pictureOrigin;
  CropAndFilterPictureStatus status;
  List<Offset> points;
  int index;
  double scale;
  CameraType style;
  FilterItem filter;

  String message;

  CropAndFilterPictureState({
    this.pictureCrop = const [],
    this.pictureOrigin = const [],
    this.message = '',
    this.points = const [],
    this.index = -1,
    this.scale = 1,
    this.status = CropAndFilterPictureStatus.initialize,
    this.style = CameraType.unSelect,
    this.filter = FilterItem.unSelect
  });

  CropAndFilterPictureState copyWith({
    List<Uint8List>? pictureCrop,
    List<Uint8List>? pictureOrigin,
    String? message,
    List<Offset>? points,
    int? index,
    double? scale,
    CropAndFilterPictureStatus? status,
    CameraType? style,
  }) {
    return CropAndFilterPictureState(
      pictureCrop: pictureCrop ?? this.pictureCrop,
      pictureOrigin: pictureOrigin ?? this.pictureOrigin,
      message: message ?? this.message,
      points: points ?? this.points,
      index: index ?? this.index,
      scale: scale ?? this.scale,
      status: status ?? this.status,
    );
  }

  factory CropAndFilterPictureState.initialize() {
    return CropAndFilterPictureState(status: CropAndFilterPictureStatus.initialize);
  }

  factory CropAndFilterPictureState.loading() {
    return CropAndFilterPictureState(status: CropAndFilterPictureStatus.loading);
  }

  factory CropAndFilterPictureState.success(List<Uint8List> data) {
    return CropAndFilterPictureState(
        pictureCrop: data, status: CropAndFilterPictureStatus.success);
  }

  factory CropAndFilterPictureState.failure() {
    return CropAndFilterPictureState(status: CropAndFilterPictureStatus.failure);
  }

  bool get isLoading => status == CropAndFilterPictureStatus.loading;

  bool get isSuccess => status == CropAndFilterPictureStatus.success;

  bool get isFailure => status == CropAndFilterPictureStatus.failure;
}

class GetPointsCropEvent extends CameraPictureEvent {
  int index;
  List<Offset> points;
  double scale;

  GetPointsCropEvent({
    required this.points,
    required this.scale,
    required this.index,
  });
}

class GetImageCropEvent extends CameraPictureEvent {
  List<Uint8List> picture;
  List<Uint8List> pictureOrigin;
  CameraType style;

  GetImageCropEvent({required this.picture ,required this.pictureOrigin, required this.style});
}

class ImageCropEvent extends CameraPictureEvent {
  ImageCropEvent();
}

class FilterPictureEvent extends CameraPictureEvent {
  FilterItem filter;
  FilterPictureEvent({required this.filter});
}

class CameraPictureViewModel
    extends Bloc<CameraPictureEvent, CropAndFilterPictureState> {
  CameraPictureViewModel()
      : super(
            CropAndFilterPictureState().copyWith(status: CropAndFilterPictureStatus.initialize)) {
    on<GetPointsCropEvent>(_getPointsCropEvent);
    on<GetImageCropEvent>(_getImageCropEvent);
    on<ImageCropEvent>(_cropImageEvent);
    on<FilterPictureEvent>(_filterPictureEvent);
  }

  void _getPointsCropEvent(GetPointsCropEvent event, Emitter emit) async {
    try {
      state.points = event.points;
      state.scale = event.scale;
      state.index = event.index;
      emit(state.copyWith(
          points: state.points,
          scale: state.scale,
          index: state.index,
          status: CropAndFilterPictureStatus.success));
    } catch (e) {
      emit(state.copyWith(message: 'error'));
    }
  }

  void _getImageCropEvent(GetImageCropEvent event, Emitter emit) async {
    try {
      state.pictureCrop = event.picture;
      state.pictureOrigin = event.picture;
      state.style = event.style;
      emit(state.copyWith(
          pictureCrop: state.pictureCrop, pictureOrigin: state.pictureOrigin, status: CropAndFilterPictureStatus.success));
    } catch (e) {
      emit(state.copyWith(message: 'error'));
    }
  }

  void _cropImageEvent(ImageCropEvent event, Emitter emitter) async {
    emit(state.copyWith(status: CropAndFilterPictureStatus.loading));
    final memoryImageSize = imgsize.ImageSizeGetter.getSize(
        imgsize.MemoryInput(state.pictureCrop[state.index]));
    double imgHeightReal = memoryImageSize.height.toDouble();
    double imgWidthReal = memoryImageSize.width.toDouble();

    if (imgHeightReal < imgWidthReal) {
      final tmp = imgWidthReal;
      imgWidthReal = imgHeightReal;
      imgHeightReal = tmp;
      state.pictureCrop[state.index] =
          await ImgProc.rotate(state.pictureCrop[state.index], 90);
    } else {}
    try {
      Uint8List res = await ImgProc.warpPerspectiveTransform(
        state.pictureCrop[state.index],
        sourcePoints: [
          (state.points[0].dx * state.scale).toInt(),
          (state.points[0].dy * state.scale).toInt(),
          //
          (state.points[1].dx * state.scale).toInt(),
          (state.points[1].dy * state.scale).toInt(),
          //
          (state.points[3].dx * state.scale).toInt(),
          (state.points[3].dy * state.scale).toInt(),
          //
          (state.points[2].dx * state.scale).toInt(),
          (state.points[2].dy * state.scale).toInt(),
        ],
        destinationPoints: [0, 0, 300, 0, 0, 400, 300, 400],
        outputSize: [300, 400],
      ) as Uint8List;
      state.pictureCrop[state.index] = res;
      emit(state.copyWith(
          pictureCrop: state.pictureCrop,pictureOrigin: state.pictureCrop, status: CropAndFilterPictureStatus.success));
    } catch (e) {
      emit(state.copyWith(message: 'error'));
    }
  }

  void _filterPictureEvent(FilterPictureEvent event, Emitter emitter) async{
    emit(state.copyWith(status: CropAndFilterPictureStatus.loading));
    state.filter = event.filter;
    print('====== ${state.filter}');
    try{
      // state.pictureCrop = state.pictureOrigin;
      if (state.filter == FilterItem.blur) {
        for (var item in state.pictureCrop) {
          Uint8List res = await ImgProc.blur(item, [45, 45], [20, 30], Core.borderReflect) as Uint8List;
          state.pictureCrop[state.index] = res;
          print('==== ');
        }
        //widget.onChangeImage(FilterItem.blur);
      } else if (state.filter == FilterItem.shadows) {
        for (var item in state.pictureCrop) {
          Uint8List res = await ImgProc.grayScale(item) as Uint8List;
          state.pictureCrop[state.index] = res;
        }
        //widget.onChangeImage(FilterItem.shadows);
      } else if (state.filter == FilterItem.fullAngle) {
        //widget.onChangeImage(FilterItem.fullAngle);
      } else if (state.filter == FilterItem.brighten) {

      } else if (state.filter == FilterItem.ecological) {

      } else if (state.filter == FilterItem.bVW) {
        for (var item in state.pictureCrop) {
          Uint8List res = await ImgProc.adaptiveThreshold(item, 125,
              ImgProc.adaptiveThreshMeanC, ImgProc.threshBinary, 11, 12) as Uint8List;
          state.pictureCrop[state.index] = res;
        }
        //widget.onChangeImage(FilterItem.bVW);
      } else {}
      emit(state.copyWith(pictureCrop: state.pictureCrop, status: CropAndFilterPictureStatus.success));
    } catch (e){
      print('=========== e');
      emit(state.copyWith(message: 'error'));
    }
  }
}

Future<Uint8List> rotateImage(Uint8List image) async {
  image = await ImgProc.rotate(image, 90);
  return image;
}
