import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vart_tools/database/folder_database.dart';

abstract class FoldersEvent {}

enum FolderStatus { loading, success, failure, initialize }

class FoldersState {
  List<FolderModel> folders = [];
  SortType sortType;
  FolderStatus status;
  String message = '';

  FoldersState({
    this.status = FolderStatus.initialize,
    this.folders = const [],
    this.sortType = SortType.byCreatedDateDESC,
    this.message = '',
  });

  List<FolderModel> get filterFolder {
    switch (sortType) {
      case SortType.byCreatedDateACS:
        folders.sort((f1, f2) => _compareByDate(f1, f2));
        break;

      case SortType.byCreatedDateDESC:
        folders.sort((f1, f2) => _compareByDate(f2, f1));
        break;

      case SortType.byAZ:
        folders.sort((f1, f2) => _compareByAZ(f1, f2));
        break;

      case SortType.byZA:
        folders.sort((f1, f2) => _compareByAZ(f2, f1));
        break;
    }
    return folders;
  }

  int _compareByDate(FolderModel f1, FolderModel f2) {
    return DateTime.parse(f1.dateCreate!)
        .compareTo(DateTime.parse(f2.dateCreate!));
  }

  int _compareByAZ(FolderModel f1, FolderModel f2) {
    return f1.name!.compareTo(f2.name!);
  }

  FoldersState copyWith({
    List<FolderModel>? folders,
    SortType? sortType,
    FolderStatus? status,
    String? message,
  }) {
    return FoldersState(
      folders: folders ?? this.folders,
      sortType: sortType ?? this.sortType,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  bool get isLoading => status == FolderStatus.loading;
  bool get isSuccess => status == FolderStatus.success;
  bool get isFailure => status == FolderStatus.failure;
}

enum SortType { byCreatedDateACS, byCreatedDateDESC, byAZ, byZA }

class LoadFoldersEvent extends FoldersEvent {}

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

// class LoadingDataFoldersState extends FoldersState {}

// class ErrorLoadDataFoldersState extends FoldersState {
//   String message;
//   ErrorLoadDataFoldersState({required this.message});
// }

// class SuccessLoadDataFoldersState extends FoldersState {
//   final List<FolderModel> folders;
//   SuccessLoadDataFoldersState({required this.folders});
// }

class FavouriteFolderEvent extends FoldersEvent {
  FolderModel folder;
  int isFavourite;
  FavouriteFolderEvent({required this.folder, required this.isFavourite});
}

class SortFolderEvent extends FoldersEvent {
  SortType type;
  SortFolderEvent({required this.type});
}

class FoldersViewModel extends Bloc<FoldersEvent, FoldersState> {
  FoldersViewModel()
      : super(FoldersState().copyWith(status: FolderStatus.initialize)) {
    on<LoadFoldersEvent>(_loadDataFolders);
    on<AddFolderEvent>(_addFolder);
    on<RenameFolderEvent>(_renameFolder);
    on<DeleteFolderEvent>(_deleteFolder);
    on<FavouriteFolderEvent>(_favouriteFolder);
    on<SortFolderEvent>(_sortFolders);
  }

  void _loadDataFolders(FoldersEvent event, Emitter emit) async {
    emit(state.copyWith(status: FolderStatus.loading));
    try {
      final folders = await FolderProvider().getFolders(null);
      state.folders = folders;
      emit(state.copyWith(
          folders: state.filterFolder, status: FolderStatus.success));
    } catch (e) {
      emit(FoldersState().copyWith(message: "loading error!"));
    }
  }

  void _addFolder(AddFolderEvent event, Emitter emit) async {
    try {
      await FolderProvider().insertFolder(event.folder);
      state.folders.add(event.folder);
      emit(state.copyWith(folders: state.filterFolder));
    } catch (e) {
      emit(state.copyWith(message: "add folder error"));
    }
  }

  void _renameFolder(RenameFolderEvent event, Emitter emit) async {
    try {
      await FolderProvider().update(event.folder);
      state.folders = await FolderProvider().getFolders(null);
      emit(state.copyWith(folders: state.filterFolder));
    } catch (e) {
      emit(state.copyWith(message: "rename folder error"));
    }
  }

  void _deleteFolder(DeleteFolderEvent event, Emitter emit) async {
    try {
      event.folder.isDelete = 1;
      await FolderProvider().update(event.folder);
      state.folders = await FolderProvider().getFolders(null);
      emit(state.copyWith(folders: state.filterFolder));
    } catch (e) {
      emit(state.copyWith(message: "delete folder fail"));
    }
  }

  void _favouriteFolder(FavouriteFolderEvent event, Emitter emit) async {
    try {
      event.folder.favourite = event.isFavourite;
      await FolderProvider().update(event.folder);
      state.folders = await FolderProvider().getFolders(null);
      emit(state.copyWith(folders: state.folders));
    } catch (e) {
      emit(state.copyWith(message: "delete folder fail"));
    }
  }

  void _sortFolders(SortFolderEvent event, Emitter emit) async {
    try {
      state.sortType = event.type;
      emit(state.copyWith(folders: state.filterFolder));
    } catch (e) {
      emit(state.copyWith(message: "loading error!"));
    }
  }
}
