import 'dart:typed_data';
import 'package:bloc/bloc.dart';

enum SelectPictureStatus { loading, success, failure, initialize }

abstract class SelectPictureEvent {}

class SelectPictureState {
  final List<Uint8List> selectPicture;
  final SelectPictureStatus status;
  final String message;

  SelectPictureState({
    this.selectPicture = const [],
    this.status = SelectPictureStatus.initialize,
    this.message = '',
  });

  SelectPictureState copyWith({
    List<Uint8List>? selectPicture,
    SelectPictureStatus? status,
    String? message,
  }) {
    return SelectPictureState(
      selectPicture: selectPicture ?? this.selectPicture,
      message: message ?? this.message,
      status: status ?? this.status,
    );
  }

  factory SelectPictureState.initialize() {
    return SelectPictureState(
        selectPicture: [], status: SelectPictureStatus.initialize);
  }

  factory SelectPictureState.loading() {
    return SelectPictureState(
        selectPicture: [], status: SelectPictureStatus.loading);
  }

  factory SelectPictureState.success(List<Uint8List> data) {
    return SelectPictureState(
        selectPicture: data, status: SelectPictureStatus.success);
  }

  factory SelectPictureState.failure() {
    return SelectPictureState(
        selectPicture: [], status: SelectPictureStatus.failure);
  }

  bool get isLoading => status == SelectPictureStatus.loading;
  bool get isSuccess => status == SelectPictureStatus.success;
  bool get isFailure => status == SelectPictureStatus.failure;
}

class SelectPictureViewModel extends Bloc<SelectPictureEvent, SelectPictureState> {
  SelectPictureViewModel()
      : super(SelectPictureState().copyWith(status: SelectPictureStatus.initialize)) {

  }
}