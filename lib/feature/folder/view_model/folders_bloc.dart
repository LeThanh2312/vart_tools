import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vart_tools/database/folder_database.dart';

class FoldersEvent {}

class FoldersState {
  List<FolderModel> folders = [];
  FoldersState({this.folders = const []});
}

class AddFolderEvent extends FoldersEvent {
  FolderModel folder;
  AddFolderEvent({required this.folder});
}

class DeleteFolderEvent extends FoldersEvent {
  FolderModel folder;
  DeleteFolderEvent({required this.folder});
}

class RenameFolderEvent extends FoldersEvent {
  FolderModel folder;
  RenameFolderEvent({required this.folder});
}

class LoadingDataFoldersState extends FoldersState {}

class ErrorLoadDataFoldersState extends FoldersState {
  String message;
  ErrorLoadDataFoldersState({required this.message});
}

class SuccessLoadDataFoldersState extends FoldersState {
  List<FolderModel> folders = [];
  SuccessLoadDataFoldersState({required this.folders});
}

class FavouriteFolderEvent extends FoldersEvent {
  FolderModel folder;
  int isFavourite;
  FavouriteFolderEvent({required this.folder, required this.isFavourite});
}

class FoldersViewModel extends Bloc<FoldersEvent, FoldersState> {
  FoldersViewModel() : super(FoldersState()) {
    on<FoldersEvent>(_loadDataFolders);
    on<AddFolderEvent>(_addFolder);
    on<RenameFolderEvent>(_renameFolder);
    on<DeleteFolderEvent>(_deleteFolder);
    on<FavouriteFolderEvent>(_favouriteFolder);
  }

  void _loadDataFolders(FoldersEvent event, Emitter emit) async {
    emit(LoadingDataFoldersState());
    try {
      state.folders = await FolderProvider().getFolders(null);
      emit(SuccessLoadDataFoldersState(folders: state.folders));
    } catch (e) {
      emit(ErrorLoadDataFoldersState(message: "loading error!"));
    }
  }

  void _addFolder(AddFolderEvent event, Emitter emit) async {
    try {
      await FolderProvider().insertFolder(event.folder);
      state.folders = await FolderProvider().getFolders(null);
      emit(SuccessLoadDataFoldersState(folders: state.folders));
    } catch (e) {
      emit(ErrorLoadDataFoldersState(message: "add folder error"));
    }
  }

  void _renameFolder(RenameFolderEvent event, Emitter emit) async {
    try {
      await FolderProvider().update(event.folder);
      state.folders = await FolderProvider().getFolders(null);
      emit(SuccessLoadDataFoldersState(folders: state.folders));
    } catch (e) {
      emit(ErrorLoadDataFoldersState(message: "rename folder error"));
    }
  }

  void _deleteFolder(DeleteFolderEvent event, Emitter emit) async {
    try {
      event.folder.isDelete = 1;
      await FolderProvider().update(event.folder);
      state.folders = await FolderProvider().getFolders(null);
      emit(SuccessLoadDataFoldersState(folders: state.folders));
    } catch (e) {
      emit(ErrorLoadDataFoldersState(message: "delete folder fail"));
    }
  }

  void _favouriteFolder(FavouriteFolderEvent event, Emitter emit) async {
    try {
      event.folder.favourite = event.isFavourite;
      await FolderProvider().update(event.folder);
      state.folders = await FolderProvider().getFolders(null);
      emit(SuccessLoadDataFoldersState(folders: state.folders));
    } catch (e) {
      emit(ErrorLoadDataFoldersState(message: "delete folder fail"));
    }
  }
}
