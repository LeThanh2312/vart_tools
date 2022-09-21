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

class LoadingInitFolders extends FoldersState {}

class ErrorInitFolders extends FoldersState {
  String message;
  ErrorInitFolders({required this.message});
}

class ErrorAddFolder extends FoldersState {
  String message;
  ErrorAddFolder({required this.message});
}

class SuccessInitFolders extends FoldersState {
  List<FolderModel> folders = [];
  SuccessInitFolders({required this.folders});
}

class FoldersViewModel extends Bloc<FoldersEvent, FoldersState> {
  FoldersViewModel() : super(FoldersState()) {
    on<FoldersEvent>(_initFolders);
    on<AddFolderEvent>(_addFolder);
  }

  void _initFolders(FoldersEvent event, Emitter emit) async {
    emit(LoadingInitFolders());
    try {
      state.folders = await FolderProvider().getFolders();
      emit(SuccessInitFolders(folders: state.folders));
    } catch (e) {
      emit(ErrorInitFolders(message: "loading error!"));
    }
  }

  void _addFolder(AddFolderEvent event, Emitter emit) async {
    try {
      await FolderProvider().insertFolder(event.folder);
      state.folders.add(event.folder);
      emit(SuccessInitFolders(folders: state.folders));
    } catch (e) {
      emit(ErrorAddFolder(message: "add folder error"));
    }
  }

  // void _deleteFolder(DeleteFolderEvent event, Emitter emit) async {
  //   try {
  //     await FolderProvider().deleteFolder(2, FolderDb(isDelete: 1));
  //     state.folders = await FolderProvider().getFolders();
  //     emit(SuccessInitFolders(folders: state.folders));
  //   } catch (e) {
  //     emit(ErrorAddFolder(message: "add folder error"));
  //   }
  // }
}
