import 'package:vart_tools/database/folder_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FolderFavouriteState {
  List<FolderModel> folders = [];
  FolderFavouriteState({this.folders = const []});
}

abstract class FolderFavouriteEvent {}

class LoadDataFavouriteEvent extends FolderFavouriteEvent {}

class LoadingDatatFavouriteState extends FolderFavouriteState {}

class LoadingDataFavouriteSuccessState extends FolderFavouriteState {
  List<FolderModel> folders = [];
  LoadingDataFavouriteSuccessState({required this.folders});
}

class LoadingDataFavouriteErrorState extends FolderFavouriteState {
  String message;
  LoadingDataFavouriteErrorState({required this.message});
}

class FolderFavouriteViewModel
    extends Bloc<FolderFavouriteEvent, FolderFavouriteState> {
  FolderFavouriteViewModel() : super(FolderFavouriteState()) {
    on<LoadDataFavouriteEvent>(_loadDataFoldersFavourite);
  }

  void _loadDataFoldersFavourite(
      FolderFavouriteEvent event, Emitter emit) async {
    emit(LoadingDatatFavouriteState());
    try {
      state.folders = await FolderProvider().getFoldersFavourite();
      emit(LoadingDataFavouriteSuccessState(folders: state.folders));
    } catch (e) {
      emit(LoadingDataFavouriteErrorState(message: "loading error!"));
    }
  }
}
