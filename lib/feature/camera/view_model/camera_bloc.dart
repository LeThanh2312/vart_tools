import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';

enum CameraStatus { loading, success, failure, initialize }

abstract class CameraPictureEvent{}

class CameraPictureState {
  List<Uint8List> pictureCrop;
  CameraStatus status;
  List<Offset> points;
  String message;

  CameraPictureState({
    this.pictureCrop =  const [],
    this.message = '',
    this.points = const [],
    this.status = CameraStatus.initialize,
  });

  CameraPictureState copyWith({
    List<Uint8List>? pictureCrop,
    String? message,
    List<Offset>? points,
    CameraStatus? status,

  }) {
    return CameraPictureState(
      pictureCrop: pictureCrop ?? this.pictureCrop,
      message: message ?? this.message,
      points: points ?? this.points,
      status: status ?? this.status,
    );
  }

  bool get isLoading => status == CameraStatus.loading;
  bool get isSuccess => status == CameraStatus.success;
  bool get isFailure => status == CameraStatus.failure;
}


class CropImageEvent extends CameraPictureEvent {
  List<Uint8List> image;
  List<Offset> points;
  CropImageEvent({required this.image, required this.points});
}



class CameraPictureViewModel extends Bloc<CameraPictureEvent, CameraPictureState> {
  CameraPictureViewModel() : super(CameraPictureState().copyWith( status: CameraStatus.initialize)) {
    on<CropImageEvent>(_CropImageHandle);
  }

  void _CropImageHandle(CropImageEvent event, Emitter emit) async {
    try {
      state.pictureCrop = event.image;
      emit(state.copyWith(pictureCrop: state.pictureCrop));
    } catch (e) {
      emit(state.copyWith(message: 'error'));
    }
  }
}
