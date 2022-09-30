import 'package:vart_tools/database/file_database.dart';
import 'package:vart_tools/database/folder_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum FileFavouriteStatus { loading, success, failure, initialize }

class FileFavouriteState {
  List<FileModel> files;
  FileFavouriteStatus status;
  String message = '';
  FileFavouriteState(
      {this.files = const [], required this.status, String? message});

  FileFavouriteState copyWith({
    List<FileModel>? files,
    FileFavouriteStatus? status,
    String? message,
  }) {
    return FileFavouriteState(
      files: files ?? this.files,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  bool get isLoading => status == FileFavouriteStatus.loading;
  bool get isSuccess => status == FileFavouriteStatus.success;
  bool get isFailure => status == FileFavouriteStatus.failure;
}

abstract class FileFavouriteEvent {}

class LoadDataFilesFavouriteEvent extends FileFavouriteEvent {}

class FileFavouriteViewModel
    extends Bloc<FileFavouriteEvent, FileFavouriteState> {
  FileFavouriteViewModel()
      : super(FileFavouriteState(status: FileFavouriteStatus.initialize)) {
    on<LoadDataFilesFavouriteEvent>(_loadDataFilesFavourite);
  }

  void _loadDataFilesFavourite(FileFavouriteEvent event, Emitter emit) async {
    emit(state.copyWith(status: FileFavouriteStatus.loading));
    try {
      state.files = await FileProvider().getFilesFavourite();
      emit(state.copyWith(
          files: state.files, status: FileFavouriteStatus.success));
    } catch (e) {
      print(e);
      emit(state.copyWith(status: FileFavouriteStatus.failure));
    }
  }
}
