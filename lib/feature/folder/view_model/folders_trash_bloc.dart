import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vart_tools/database/folder_database.dart';

// class FolderTrashState {
//   List<FolderModel> folders = [];
//   FolderTrashState({this.folders = const []});
// }

abstract class FolderTrashEvent {}

enum FolderTrashStatus { loading, success, failure, initialize }

class LoadFolderTrashEvent extends FolderTrashEvent {}

class ToggleSelectFolderTrashEvent extends FolderTrashEvent {
  final FolderModel folder;
  ToggleSelectFolderTrashEvent({required this.folder});
}

class PermanentlyDeleteEvent extends FolderTrashEvent {
  final List<int> selectedIds;
  PermanentlyDeleteEvent({required this.selectedIds});
}

// class LoadingDatatTrashState extends FolderTrashState {}

// class LoadingDataTrashSuccessState extends FolderTrashState {
//   final List<FolderModel> folders;
//   final List<int> selectedFolders;
//   LoadingDataTrashSuccessState({required this.folders, required this.selectedFolders});
// }

// class LoadingDataTrashErrorState extends FolderTrashState {
//   String message;
//   LoadingDataTrashErrorState({required this.message});
// }

class FolderTrashState {
  final List<FolderModel> folders;
  final List<int> selectedFolderIds;
  final FolderTrashStatus status;

  FolderTrashState({
    required this.folders,
    required this.selectedFolderIds,
    this.status = FolderTrashStatus.initialize,
  });

  FolderTrashState copyWith({
    List<FolderModel>? folders,
    List<int>? selectedFolderIds,
    FolderTrashStatus? status,
  }) {
    return FolderTrashState(
      folders: folders ?? this.folders,
      selectedFolderIds: selectedFolderIds ?? this.selectedFolderIds,
      status: status ?? this.status,
    );
  }

  factory FolderTrashState.loading() {
    return FolderTrashState(
      folders: [],
      selectedFolderIds: [],
      status: FolderTrashStatus.loading,
    );
  }
  factory FolderTrashState.success(List<FolderModel> folders) {
    return FolderTrashState(
      folders: folders,
      selectedFolderIds: [],
      status: FolderTrashStatus.success,
    );
  }
  factory FolderTrashState.failure() {
    return FolderTrashState(
      folders: [],
      selectedFolderIds: [],
      status: FolderTrashStatus.failure,
    );
  }

  factory FolderTrashState.initialize() {
    return FolderTrashState(
      folders: [],
      selectedFolderIds: [],
      status: FolderTrashStatus.initialize,
    );
  }

  bool get isEmptySelectedId => selectedFolderIds.isEmpty;
  bool isChecked(FolderModel folder) => selectedFolderIds.contains(folder.id);

  bool get isLoading => status == FolderTrashStatus.loading;
  bool get isSuccess => status == FolderTrashStatus.success;
  bool get isFailure => status == FolderTrashStatus.failure;
}

class FolderTrashViewModel extends Bloc<FolderTrashEvent, FolderTrashState> {
  FolderTrashViewModel() : super(FolderTrashState.initialize()) {
    on<LoadFolderTrashEvent>(_loadFoldersTrash);
    on<ToggleSelectFolderTrashEvent>(_toggleSelectFolderTrash);
    on<PermanentlyDeleteEvent>(_permanentlyDelete);
  }

  void _loadFoldersTrash(LoadFolderTrashEvent event, Emitter emit) async {
    emit(FolderTrashState.loading());
    try {
      final folders = await FolderProvider().getFoldersTrash();
      emit(FolderTrashState.success(folders));
    } catch (e) {
      emit(FolderTrashState.failure());
    }
  }

  void _toggleSelectFolderTrash(
      ToggleSelectFolderTrashEvent event, Emitter emit) async {
    if (state.selectedFolderIds.contains(event.folder.id)) {
      final selectedIds = state.selectedFolderIds..remove(event.folder.id!);
      emit(state.copyWith(selectedFolderIds: selectedIds));
    } else {
      final selectedIds = state.selectedFolderIds..add(event.folder.id!);
      emit(state.copyWith(selectedFolderIds: selectedIds));
    }
  }

  void _permanentlyDelete(PermanentlyDeleteEvent event, Emitter emit) async {
    try {
      await FolderProvider().permanentlyDeleteFolders(event.selectedIds);
      final folders = await FolderProvider().getFoldersTrash();
      emit(FolderTrashState.success(folders));
    } catch (e) {
      emit(FolderTrashState.failure());
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

// class DeleteIdCheckEvent extends FolderTrashEvent {
//   int idCheck;
//   DeleteIdCheckEvent({required this.idCheck});
// }

// class IdCheckState {
//   List idChecks = [];
//   AddIdCheckState({required this.idChecks});
// }

// class IdCheckViewModel extends Bloc<IdCheckEvent, IdCheckState> {
//   IdCheckViewModel() : super(IdCheckState(idChecks: [])) {
//     on<IdCheckEvent>(_addItemCheck);
//   }

//   void _addItemCheck(IdCheckEvent event, Emitter emit) {
//     state.idChecks = event.idChecks;
//     print("data state ${state.idChecks}");
//     print(state.idChecks.length);
//   }
// }
