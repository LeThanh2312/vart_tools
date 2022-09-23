// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:vart_tools/database/folder_database.dart';

// abstract class FolderTrashEvent {}

// enum PermanentlyDeleteStatus { loading, success, failure, initialize }

// class LoadFolderTrashEvent extends FolderTrashEvent {}

// class ToggleSelectFolderTrashEvent extends FolderTrashEvent {
//   final FolderModel folder;
//   ToggleSelectFolderTrashEvent({required this.folder});
// }

// class PermanentlyDeleteState {
//   final List<int> selectedFolderIds;
//   final PermanentlyDeleteStatus status;

//   PermanentlyDeleteState({
//     required this.selectedFolderIds,
//     this.status = PermanentlyDeleteStatus.initialize,
//   });

//   PermanentlyDeleteState copyWith({
//     List<FolderModel>? folders,
//     List<int>? selectedFolderIds,
//     PermanentlyDeleteStatus? status,
//   }) {
//     return PermanentlyDeleteState(
//       selectedFolderIds: selectedFolderIds ?? this.selectedFolderIds,
//       status: status ?? this.status,
//     );
//   }

//   factory PermanentlyDeleteState.loading() {
//     return PermanentlyDeleteState(
//       selectedFolderIds: [],
//       status: PermanentlyDeleteStatus.loading,
//     );
//   }
//   factory PermanentlyDeleteState.success(List<FolderModel> folders) {
//     return PermanentlyDeleteState(
//       selectedFolderIds: [],
//       status: PermanentlyDeleteStatus.success,
//     );
//   }
//   factory PermanentlyDeleteState.failure() {
//     return PermanentlyDeleteState(
//       selectedFolderIds: [],
//       status: PermanentlyDeleteStatus.failure,
//     );
//   }

//   factory PermanentlyDeleteState.initialize() {
//     return PermanentlyDeleteState(
//       selectedFolderIds: [],
//       status: PermanentlyDeleteStatus.initialize,
//     );
//   }

//   bool get isEmptySelectedId => selectedFolderIds.isEmpty;
//   bool isChecked(FolderModel folder) => selectedFolderIds.contains(folder.id);

//   bool get isLoading => status == PermanentlyDeleteStatus.loading;
//   bool get isSuccess => status == PermanentlyDeleteStatus.success;
//   bool get isFailure => status == PermanentlyDeleteStatus.failure;
// }

// class PermanentlyDeleteViewModel extends Bloc<PermanentlyDeleteEvent, PermanentlyDeleteState> {
//   PermanentlyDeleteViewModel() : super(PermanentlyDeleteState.initialize()) {
//     on<LoadPermanentlyDeleteEvent>(_loadFoldersTrash);
//     on<ToggleSelectPermanentlyDeleteEvent>(_toggleSelectPermanentlyDelete);
//   }

//   void _loadFoldersTrash(LoadPermanentlyDeleteEvent event, Emitter emit) async {
//     emit(PermanentlyDeleteState.loading());
//     try {
//       final folders = await FolderProvider().getFoldersTrash();
//       emit(PermanentlyDeleteState.success(folders));
//     } catch (e) {
//       emit(PermanentlyDeleteState.failure());
//     }
//   }

//   void _toggleSelectPermanentlyDelete(
//       ToggleSelectPermanentlyDeleteEvent event, Emitter emit) async {
//     if (state.selectedFolderIds.contains(event.folder.id)) {
//       final selectedIds = state.selectedFolderIds..remove(event.folder.id!);
//       emit(state.copyWith(selectedFolderIds: selectedIds));
//     } else {
//       final selectedIds = state.selectedFolderIds..add(event.folder.id!);
//       emit(state.copyWith(selectedFolderIds: selectedIds));
//     }
//   }
// }


