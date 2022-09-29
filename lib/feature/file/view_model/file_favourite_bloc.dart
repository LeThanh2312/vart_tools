import 'package:vart_tools/database/file_database.dart';
import 'package:vart_tools/database/folder_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FileFavouriteState {
  List<FileModel> files = [];
  FileFavouriteState({this.files = const []});
}

abstract class FileFavouriteEvent {}

class LoadDataFilesFavouriteEvent extends FileFavouriteEvent {}

class LoadingDataFileFavouriteState extends FileFavouriteState {}

class LoadingDataFileFavouriteSuccessState extends FileFavouriteState {
  List<FileModel> files = [];
  LoadingDataFileFavouriteSuccessState({required this.files});
}

class LoadingDataFileFavouriteErrorState extends FileFavouriteState {
  String message;
  LoadingDataFileFavouriteErrorState({required this.message});
}

class FileFavouriteViewModel
    extends Bloc<FileFavouriteEvent, FileFavouriteState> {
  FileFavouriteViewModel() : super(FileFavouriteState()) {
    on<LoadDataFilesFavouriteEvent>(_loadDataFilesFavourite);
  }

  void _loadDataFilesFavourite(FileFavouriteEvent event, Emitter emit) async {
    emit(LoadingDataFileFavouriteState());
    try {
      state.files = await FileProvider().getFilesFavourite();
      emit(LoadingDataFileFavouriteSuccessState(files: state.files));
    } catch (e) {
      print(e);
      emit(LoadingDataFileFavouriteErrorState(message: "loading error!"));
    }
  }
}
