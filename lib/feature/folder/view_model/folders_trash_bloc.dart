import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vart_tools/database/file_database.dart';
import 'package:vart_tools/database/folder_database.dart';

abstract class FolderTrashEvent {}

enum FolderTrashStatus { loading, success, failure, initialize }

enum FolderRecoverStatus { processing, success, failure, initialize }

class LoadFolderTrashEvent extends FolderTrashEvent {}

class ToggleSelectFolderTrashEvent extends FolderTrashEvent {
  final SelectIdTrashModel selectedIdsObject;
  ToggleSelectFolderTrashEvent({required this.selectedIdsObject});
}

class PermanentlyDeleteEvent extends FolderTrashEvent {
  final List<SelectIdTrashModel> selectedIdsObject;
  PermanentlyDeleteEvent({required this.selectedIdsObject});
}

class RecoverFolderEvent extends FolderTrashEvent {
  final List<SelectIdTrashModel> selectedIdsObject;
  RecoverFolderEvent({required this.selectedIdsObject});
}

class FolderTrashState {
  final List<FolderModel> folders;
  final List<FileModel> files;
  final List<SelectIdTrashModel> selectedIdObject;
  final FolderTrashStatus status;
  final FolderRecoverStatus recoverStatus;

  FolderTrashState({
    required this.files,
    required this.folders,
    required this.selectedIdObject,
    this.recoverStatus = FolderRecoverStatus.initialize,
    this.status = FolderTrashStatus.initialize,
  });

  FolderTrashState copyWith({
    List<FolderModel>? folders,
    List<FileModel>? files,
    List<SelectIdTrashModel>? selectedIdObject,
    FolderTrashStatus? status,
    FolderRecoverStatus? recoverStatus,
  }) {
    return FolderTrashState(
      files: files ?? this.files,
      folders: folders ?? this.folders,
      selectedIdObject: selectedIdObject ?? this.selectedIdObject,
      status: status ?? this.status,
      recoverStatus: recoverStatus ?? FolderRecoverStatus.initialize,
    );
  }

  factory FolderTrashState.loading() {
    return FolderTrashState(
      files: [],
      folders: [],
      selectedIdObject: [],
      status: FolderTrashStatus.loading,
    );
  }
  factory FolderTrashState.success(
      List<FolderModel> folders, List<FileModel> files) {
    return FolderTrashState(
      files: files,
      folders: folders,
      selectedIdObject: [],
      status: FolderTrashStatus.success,
    );
  }
  factory FolderTrashState.failure() {
    return FolderTrashState(
      files: [],
      folders: [],
      selectedIdObject: [],
      status: FolderTrashStatus.failure,
    );
  }

  factory FolderTrashState.initialize() {
    return FolderTrashState(
      files: [],
      folders: [],
      selectedIdObject: [],
      status: FolderTrashStatus.initialize,
    );
  }
  bool _checkContains(
      List<SelectIdTrashModel> listIdSelected, SelectIdTrashModel idSelected) {
    bool flag = false;
    listIdSelected.forEach(
      (element) {
        if (element.id == idSelected.id && element.type == idSelected.type) {
          flag = true;
          return;
        }
      },
    );
    return flag;
  }

  bool get isEmptySelectedId => selectedIdObject.isEmpty;
  bool isChecked(SelectIdTrashModel selectedId) =>
      _checkContains(selectedIdObject, selectedId);
  void deleteFolders(List<SelectIdTrashModel> selectedId) {
    for (SelectIdTrashModel obId in selectedId) {
      if (obId.type == IdType.folder) {
        folders.removeWhere((element) => obId.id == element.id);
      } else {
        files.removeWhere((element) => obId.id == element.id);
      }
    }
  }

  bool get isLoading => status == FolderTrashStatus.loading;
  bool get isSuccess => status == FolderTrashStatus.success;
  bool get isFailure => status == FolderTrashStatus.failure;
}

class FolderTrashViewModel extends Bloc<FolderTrashEvent, FolderTrashState> {
  FolderTrashViewModel() : super(FolderTrashState.initialize()) {
    on<LoadFolderTrashEvent>(_loadFoldersTrash);
    on<ToggleSelectFolderTrashEvent>(_toggleSelectFolderTrash);
    on<PermanentlyDeleteEvent>(_permanentlyDelete);
    on<RecoverFolderEvent>(_recoverFolders);
  }

  void _loadFoldersTrash(LoadFolderTrashEvent event, Emitter emit) async {
    emit(FolderTrashState.loading());
    try {
      final folders = await FolderProvider().getFoldersTrash();
      final files = await FileProvider().getFilesTrash();
      emit(FolderTrashState.success(folders, files));
    } catch (e) {
      emit(FolderTrashState.failure());
    }
  }

  void _toggleSelectFolderTrash(
      ToggleSelectFolderTrashEvent event, Emitter emit) async {
    if (state._checkContains(state.selectedIdObject, event.selectedIdsObject)) {
      final selectedIds = state.selectedIdObject
        ..removeWhere(
          (element) =>
              element.id == event.selectedIdsObject.id &&
              element.type == event.selectedIdsObject.type,
        );
      emit(state.copyWith(selectedIdObject: selectedIds));
    } else {
      final selectedIds = state.selectedIdObject..add(event.selectedIdsObject);
      emit(state.copyWith(selectedIdObject: selectedIds));
    }
  }

  void _permanentlyDelete(PermanentlyDeleteEvent event, Emitter emit) async {
    try {
      List<int> idFolders = [];
      List<int> idFiles = [];
      event.selectedIdsObject.forEach(
        (element) {
          if (element.type == IdType.folder) {
            idFolders.add(element.id);
          } else {
            idFiles.add(element.id);
          }
        },
      );
      if (idFolders.isNotEmpty) {
        await FolderProvider().permanentlyDeleteFolders(idFolders);
      }
      if (idFiles.isNotEmpty) {
        await FileProvider().permanentlyDeletefiles(idFiles);
      }
      final folders = await FolderProvider().getFoldersTrash();
      final files = await FileProvider().getFilesTrash();
      emit(FolderTrashState.success(folders, files));
    } catch (e) {
      emit(FolderTrashState.failure());
    }
  }

  void _recoverFolders(RecoverFolderEvent event, Emitter emit) async {
    try {
      List<int> idFolders = [];
      List<int> idFiles = [];
      event.selectedIdsObject.forEach(
        (element) {
          if (element.type == IdType.folder) {
            idFolders.add(element.id);
          } else {
            idFiles.add(element.id);
          }
        },
      );
      emit(state.copyWith(recoverStatus: FolderRecoverStatus.processing));
      if (idFolders.isNotEmpty) {
        await FolderProvider().recoveryFolders(idFolders);
      }
      if (idFiles.isNotEmpty) {
        await FileProvider().recoveryFiles(idFiles);
      }
      state.deleteFolders(event.selectedIdsObject);
      emit(state.copyWith(
        folders: state.folders,
        files: state.files,
        recoverStatus: FolderRecoverStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(recoverStatus: FolderRecoverStatus.failure));
    }
  }
}

class CheckEvent {}

class CheckState {
  bool isCheck;
  CheckState({required this.isCheck});
}

class CheckViewModel extends Bloc<CheckEvent, CheckState> {
  CheckViewModel() : super(CheckState(isCheck: false)) {
    on<CheckEvent>((event, emit) {
      bool newStatus = !state.isCheck;
      emit(CheckState(isCheck: newStatus));
    });
  }
}

class IdCheckEvent extends FolderTrashEvent {
  List<int> idChecks;
  IdCheckEvent({required this.idChecks});
}

class IdCheckState {
  List<int> idChecks;
  IdCheckState({this.idChecks = const []});
}
