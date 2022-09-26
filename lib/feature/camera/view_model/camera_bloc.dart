import 'package:flutter_bloc/flutter_bloc.dart';


abstract class CameraPictureEvent{

}

enum CameraPictureStatus { loading, success, failure, initialize }

class CameraPictureState {
  final CameraPictureStatus status;
  List<String> data;

  CameraPictureState({
    this.status = CameraPictureStatus.initialize,
    required this.data,
  });

  factory CameraPictureState.initialize() {
    return CameraPictureState(data: [], status: CameraPictureStatus.initialize);
  }

  factory CameraPictureState.loading() {
    return CameraPictureState(data: [], status: CameraPictureStatus.loading);
  }

  factory CameraPictureState.success(List<String> data) {
    return CameraPictureState(data: data, status: CameraPictureStatus.success);
  }

  factory CameraPictureState.failure() {
    return CameraPictureState(data: [], status: CameraPictureStatus.failure);
  }

  bool get isLoading => status == CameraPictureStatus.loading;
  bool get isSuccess => status == CameraPictureStatus.success;
  bool get isFailure => status == CameraPictureStatus.failure;
}

class CameraPictureBloc extends Bloc<CameraPictureEvent, CameraPictureState> {
  CameraPictureBloc() : super(CameraPictureState.initialize()) {
  }
}
