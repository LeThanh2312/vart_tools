import 'dart:convert';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vart_tools/database/file_database.dart';
import 'package:vart_tools/database/folder_database.dart';
import 'package:vart_tools/res/strings.dart';
import "package:collection/collection.dart";

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

  Map<dynamic, List<Map<String, Object?>>> get groupByDateUpdate {
    var maps = files.map((e) => e.toMap());
    var newFiles =
        groupBy(maps, (Map obj) => obj['date_create'].substring(0, 10));
    return newFiles;
  }

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

class LoadFilesEvent extends FileViewEvent {
  final int folderId;
  LoadFilesEvent({required this.folderId});
}

class AddFilesEvent extends FileViewEvent {
  List<FileModel> files;
  int folderId;
  AddFilesEvent({required this.files,required this.folderId});
}

class DeleteFileEvent extends FileViewEvent {
  FileModel file;
  DeleteFileEvent({required this.file});
}

class FavouriteFileEvent extends FileViewEvent {
  FileModel file;
  int isFavourite;
  FavouriteFileEvent({required this.file, required this.isFavourite});
}

class DeleteMulpliteEvent extends FileViewEvent {
  List<int?> fileId;
  int folderId;
  DeleteMulpliteEvent({required this.fileId, required this.folderId});
}

class FilesViewModel extends Bloc<FileViewEvent, FilesViewState> {
  FilesViewModel()
      : super(FilesViewState().copyWith(status: FilesStatus.initialize)) {
    on<LoadFilesEvent>(_loadDataFiles);
    on<DeleteFileEvent>(_deleteFile);
    on<FavouriteFileEvent>(_favouriteFile);
    on<DeleteMulpliteEvent>(_deleteMulpliteFile);
    on<AddFilesEvent>(_addFiles);
  }

  void _loadDataFiles(LoadFilesEvent event, Emitter emit) async {
    emit(state.copyWith(status: FilesStatus.loading));
    try {
      final files = await FileProvider().getFiles(event.folderId);
      state.files = files;
      emit(state.copyWith(files: state.files, status: FilesStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: FilesStatus.failure, message: "loading error!"));
    }
  }

  void _deleteFile(DeleteFileEvent event, Emitter emit) async {
    try {
      event.file.isDelete = 1;
      await FileProvider().updateFile(event.file);
      state.files = await FileProvider().getFiles(event.file.idFolder);
      emit(state.copyWith(files: state.files));
    } catch (e) {
      emit(state.copyWith(message: "delete folder fail"));
    }
  }

  void _favouriteFile(FavouriteFileEvent event, Emitter emit) async {
    try {
      event.file.isFavourite = event.isFavourite;
      await FileProvider().updateFile(event.file);
      state.files = await FileProvider().getFiles(event.file.idFolder);
      emit(state.copyWith(files: state.files, status: FilesStatus.success));
    } catch (e) {
      emit(state.copyWith(message: "delete folder fail"));
    }
  }

  void _deleteMulpliteFile(DeleteMulpliteEvent event, Emitter emit) async {
    try {
      print("delete file");
      print(event.fileId);
      print(event.folderId);
      await FileProvider().deleteFile(event.fileId);
      state.files = await FileProvider().getFiles(event.folderId);
      print(state.files.length);
      emit(state.copyWith(files: state.files, status: FilesStatus.success));
    } catch (e) {
      emit(state.copyWith(message: "delete folder fail"));
    }
  }

  void _addFiles(AddFilesEvent event, Emitter emit) async {
    try {
      for (FileModel file in event.files) {
        await FileProvider().insertFile(file);
      }
      state.files = await FileProvider().getFiles(event.folderId);
      emit(state.copyWith(files: state.files));
    } catch (e) {
      emit(state.copyWith(message: "add folder error"));
    }
  }
}
