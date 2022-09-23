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

class LoadingInitFoldersState extends FoldersState {}

class ErrorInitFoldersState extends FoldersState {
  String message;
  ErrorInitFoldersState({required this.message});
}

class SuccessInitFoldersState extends FoldersState {
  List<FolderModel> folders = [];
  SuccessInitFoldersState({required this.folders});
}

class FoldersViewModel extends Bloc<FoldersEvent, FoldersState> {
  FoldersViewModel() : super(FoldersState()) {
    on<FoldersEvent>(_initFolders);
    on<AddFolderEvent>(_addFolder);
    on<RenameFolderEvent>(_renameFolder);
    on<DeleteFolderEvent>(_deleteFolder);
  }

  void _initFolders(FoldersEvent event, Emitter emit) async {
    emit(LoadingInitFoldersState());
    try {
      state.folders = await FolderProvider().getFolders(null);
      emit(SuccessInitFoldersState(folders: state.folders));
    } catch (e) {
      emit(ErrorInitFoldersState(message: "loading error!"));
    }
  }

  void _addFolder(AddFolderEvent event, Emitter emit) async {
    try {
      await FolderProvider().insertFolder(event.folder);
      state.folders = await FolderProvider().getFolders(null);
      emit(SuccessInitFoldersState(folders: state.folders));
    } catch (e) {
      emit(ErrorInitFoldersState(message: "add folder error"));
    }
  }

  void _renameFolder(RenameFolderEvent event, Emitter emit) async {
    try {
      await FolderProvider().update(event.folder);
      state.folders = await FolderProvider().getFolders(null);
      emit(SuccessInitFoldersState(folders: state.folders));
    } catch (e) {
      emit(ErrorInitFoldersState(message: "rename folder error"));
    }
  }

  void _deleteFolder(DeleteFolderEvent event, Emitter emit) async {
    try {
      event.folder.isDelete = 1;
      await FolderProvider().update(event.folder);
      state.folders = await FolderProvider().getFolders(null);
      emit(SuccessInitFoldersState(folders: state.folders));
    } catch (e) {
      emit(ErrorInitFoldersState(message: "delete folder fail"));
    }
  }
}
