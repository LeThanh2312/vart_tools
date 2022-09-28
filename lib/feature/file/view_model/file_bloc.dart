import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vart_tools/database/file_database.dart';
import 'package:vart_tools/database/folder_database.dart';
import 'package:collection/collection.dart';
import 'package:vart_tools/res/strings.dart';

class FirstInitScreenState {
  bool firstInitScreen = false;
  FirstInitScreenState({required this.firstInitScreen});
}

class FirstInitScreenEvent {}

class FirstInitScreenViewModel
    extends Bloc<FirstInitScreenEvent, FirstInitScreenState> {
  FirstInitScreenViewModel()
      : super(FirstInitScreenState(firstInitScreen: false)) {
    on<FirstInitScreenEvent>((event, emit) => (event, emit) {
          state.firstInitScreen = true;
          emit(FirstInitScreenState(firstInitScreen: state.firstInitScreen));
        });
  }
}

class RedirectFileScreenState {}

class OnRedirectFileScreenState extends RedirectFileScreenState {
  bool redirect = false;
  FolderModel folder;
  OnRedirectFileScreenState({required this.redirect, required this.folder});
}

class RedirectFileScreenEvent {
  bool redirect;
  FolderModel? folder;
  RedirectFileScreenEvent({required this.redirect, this.folder});
}

class RedirectFileScreenViewModel
    extends Bloc<RedirectFileScreenEvent, OnRedirectFileScreenState> {
  RedirectFileScreenViewModel()
      : super(
            OnRedirectFileScreenState(redirect: false, folder: FolderModel())) {
    on<RedirectFileScreenEvent>((event, emit) {
      emit(OnRedirectFileScreenState(
          redirect: event.redirect, folder: event.folder ??= FolderModel()));
    });
  }
}

abstract class FileViewEvent {}

enum FilesStatus { loading, success, failure, initialize }

class FilesViewState {
  List<FileModel> files = [];
  FilesStatus status;
  String message = '';

  FilesViewState({
    this.status = FilesStatus.initialize,
    this.files = const [],
    this.message = '',
  });

  List<FileModel>? get groupByDateUpdate {
    print("maps");
    var maps = files.map((e) => e.toMap());
    print("data map");
    print(maps);
    var newFiles = groupBy(maps, (Map obj) => obj['date_update']);
    // print(newFiles);
    return null;
    // return List.generate(newFiles.length, (i) {
    //   return FileModel(
    //     id: newFiles[i][DbFile.id],
    //     name: newFiles[i][''].toString(),
    //     image: newFiles[i][DbFile.image],
    //     dateCreate: newFiles[i][DbFile.dateCreate],
    //     dateUpdate: newFiles[i][DbFile.dateUpdate],
    //     link: newFiles[i][DbFile.link],
    //     size: newFiles[i][DbFile.size],
    //     format: newFiles[i][DbFile.format],
    //     idFolder: newFiles[i][DbFile.idFolder],
    //     tag: newFiles[i][DbFile.tag],
    //     isFavourite: newFiles[i][DbFile.isFavourite],
    //     isDelete: newFiles[i][DbFile.isDelete],
    //   );
    // });
  }

  // int _compareByDate(FolderModel f1, FolderModel f2) {
  //   return DateTime.parse(f1.dateUpdate!)
  //       .compareTo(DateTime.parse(f2.dateUpdate!));
  // }

  // int _compareByAZ(FolderModel f1, FolderModel f2) {
  //   return f1.name!.compareTo(f2.name!);
  // }

  FilesViewState copyWith({
    List<FileModel>? files,
    FilesStatus? status,
    String? message,
  }) {
    return FilesViewState(
      files: files ?? this.files,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  bool get isLoading => status == FilesStatus.loading;
  bool get isSuccess => status == FilesStatus.success;
  bool get isFailure => status == FilesStatus.failure;
}

class LoadFilesEvent extends FileViewEvent {}

class AddFileEvent extends FileViewEvent {
  List<FileModel> files;
  AddFileEvent({required this.files});
}

class FilesViewModel extends Bloc<FileViewEvent, FilesViewState> {
  FilesViewModel()
      : super(FilesViewState().copyWith(status: FilesStatus.initialize)) {
    on<LoadFilesEvent>(_loadDataFiles);
  }

  void _loadDataFiles(LoadFilesEvent event, Emitter emit) async {
    emit(state.copyWith(status: FilesStatus.loading));
    try {
      final files = await FileProvider().getFiles(null);
      state.files = files;
      emit(state.copyWith(files: state.files, status: FilesStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: FilesStatus.failure, message: "loading error!"));
    }
  }
}
