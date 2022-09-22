import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vart_tools/database/folder_database.dart';

class FolderTrashState {
  List<FolderModel> folders = [];
  FolderTrashState({this.folders = const []});
}

abstract class FolderTrashEvent {}

class LoadDataTrashEvent extends FolderTrashEvent {}

class LoadingDatatTrashState extends FolderTrashState {}

class LoadingDataTrashSuccessState extends FolderTrashState {
  List<FolderModel> folders = [];
  LoadingDataTrashSuccessState({required this.folders});
}

class LoadingDataTrashErrorState extends FolderTrashState {
  String message;
  LoadingDataTrashErrorState({required this.message});
}

class FolderTrashViewModel extends Bloc<FolderTrashEvent, FolderTrashState> {
  FolderTrashViewModel() : super(FolderTrashState()) {
    on<LoadDataTrashEvent>(_loadDataFoldersTrash);
  }

  void _loadDataFoldersTrash(FolderTrashEvent event, Emitter emit) async {
    emit(LoadingDatatTrashState());
    try {
      state.folders = await FolderProvider().getFoldersTrash();
      emit(LoadingDataTrashSuccessState(folders: state.folders));
    } catch (e) {
      emit(LoadingDataTrashErrorState(message: "loading error!"));
    }
  }
}
