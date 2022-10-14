import 'package:flutter_bloc/flutter_bloc.dart';

enum ConvertTextStatus { loading, success, failure, initialize }

abstract class ConvertTextEvent {}

class ConvertTextState {
  ConvertTextStatus status;
  String message = '';
  ConvertTextState(
      {required this.status, String? message});

  ConvertTextState copyWith({
    ConvertTextStatus? status,
    String? message,
  }) {
    return ConvertTextState(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  bool get isLoading => status == ConvertTextStatus.loading;
  bool get isSuccess => status == ConvertTextStatus.success;
  bool get isFailure => status == ConvertTextStatus.failure;
}

class UpdateTextEvent extends ConvertTextEvent {}

class FileFavouriteViewModel
    extends Bloc<ConvertTextEvent, ConvertTextState> {
  FileFavouriteViewModel()
      : super(ConvertTextState(status: ConvertTextStatus.initialize)) {
    on<UpdateTextEvent>(_loadDataFilesFavourite);
  }

  void _loadDataFilesFavourite(ConvertTextEvent event, Emitter emit) async {
    emit(state.copyWith(status: ConvertTextStatus.loading));
    try {
      emit(state.copyWith(status: ConvertTextStatus.success));
    } catch (e) {
      print(e);
      emit(state.copyWith(status: ConvertTextStatus.failure));
    }
  }
}
