import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:vart_tools/database/file_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/enum/camera_type.dart';
import '../../../common/enum/save_picture_type.dart';
import 'package:merge_images/merge_images.dart';
import 'dart:ui' as ui;
import 'package:intl/intl.dart';

enum SavePictureStatus { loading, success, failure, initialize }

abstract class SavePictureEvent {}

class SavePictureState {
  List<FileModel> listFileSave;
  SavePictureType savePictureType;
  CameraType style;
  SavePictureStatus status;
  String message;

  SavePictureState({
    required this.listFileSave,
    this.savePictureType = SavePictureType.create,
    this.style = CameraType.cardID,
    this.status = SavePictureStatus.initialize,
    this.message = '',
  });

  SavePictureState copyWith({
    List<FileModel>? listFileSave,
    SavePictureType? savePictureType,
    CameraType? style,
    SavePictureStatus? status,
    String? message,
  }) {
    return SavePictureState(
      listFileSave: listFileSave ?? this.listFileSave,
      savePictureType: savePictureType ?? this.savePictureType,
      style: style ?? this.style,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  bool get isLoading => status == SavePictureStatus.loading;

  bool get isSuccess => status == SavePictureStatus.success;

  bool get isFailure => status == SavePictureStatus.failure;
}

class SaveEvent extends SavePictureEvent {
  List<Uint8List> listPictureSave;
  CameraType style;
  SavePictureType savePictureType;
  String tempPath;
  int? size;
  String? name;

  SaveEvent({
    required this.style,
    required this.listPictureSave,
    required this.savePictureType,
    required this.tempPath,
    this.size,
    this.name,
  });
}

class SavePictureViewModel extends Bloc<SavePictureEvent, SavePictureState> {
  SavePictureViewModel()
      : super(SavePictureState(listFileSave: [])
            .copyWith(status: SavePictureStatus.initialize)) {
    on<SaveEvent>(_savePicture);
  }

  void _savePicture(SaveEvent event, Emitter emit) async {
    emit(state.copyWith(status: SavePictureStatus.loading));
    state.listFileSave.clear();
    if (event.style == CameraType.cardID) {
      try {
        handleMergeImage(event.listPictureSave,event.tempPath,event.name!);
        var fileModel = FileModel(
          name: event.name!,
          image: '${event.tempPath}/${event.name}',
          format: "JPG",
          size: event.size,
        );

        state.listFileSave.add(fileModel);
        print('==== state ${state.listFileSave.length}');
        state.savePictureType = event.savePictureType;
      } catch (e) {
        print(e);
        emit(state.copyWith(message: 'error'));
      }
    } else if (event.style == CameraType.passport ||
        event.style == CameraType.document) {
      try {
        for (var item in event.listPictureSave) {
          String name =
              'camera_${event.listPictureSave.indexOf(item)}_${DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.now())}.jpg';
          File file = File('${event.tempPath}/$name');
              'camera_${event.listPictureSave.indexOf(item)}_${DateTime.now()}.jpg';
          file.writeAsBytesSync(item);

          var fileModel = FileModel(
            name: name,
            image: '${event.tempPath}/$name',
            format: "JPG",
            size: file.lengthSync(),
          );
          state.listFileSave.add(fileModel);
        }
        state.savePictureType = event.savePictureType;
      } catch (e) {
        print(e);
        emit(state.copyWith(message: 'error $e'));
      }
    }
    emit(state.copyWith(
      listFileSave: state.listFileSave,
      savePictureType: state.savePictureType,
      status: SavePictureStatus.success,
    ));
  }
}

Future<ui.Image> handleMergeImage(List<Uint8List> listImage,String tempPath,String name) async{
    ui.Image imageBefore = await ImagesMergeHelper.uint8ListToImage(
        listImage[0]);
    ui.Image imageAfter = await ImagesMergeHelper.uint8ListToImage(
        listImage[1]);
    ui.Image image = await ImagesMergeHelper.margeImages(
        [imageBefore, imageAfter],
        fit: false,
        direction: Axis.vertical,
        backgroundColor: Colors.black26);
    File? file = await ImagesMergeHelper.imageToFile(image);
    File imageSave = await file!.copy('${tempPath}/$name');

  return image;
}
