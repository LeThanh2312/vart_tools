import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:vart_tools/database/file_database.dart';
import 'package:vart_tools/feature/file/view_model/file_bloc.dart';
import 'package:vart_tools/feature/file/widget/bottom_sheet_share.dart';
import 'package:vart_tools/feature/file/widget/popup_confirm_delete_file.dart';
import 'package:vart_tools/res/app_color.dart';
import 'package:vart_tools/res/assets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:isolate';
import 'dart:ui';
import 'package:http/http.dart';
import 'package:share/share.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class BottomBarFileDetail extends StatefulWidget {
  const BottomBarFileDetail({Key? key, required this.file}) : super(key: key);
  final FileModel file;

  @override
  State<BottomBarFileDetail> createState() => _BottomBarFileDetailState();
}

class _BottomBarFileDetailState extends State<BottomBarFileDetail> {
  late bool isFavourite = widget.file.isFavourite == 0 ? false : true;

  @override
  void initState() {
    super.initState();
    FlutterDownloader.registerCallback(downloadCallback);
  }

  void _favouriteFile() {
    context.read<FilesViewModel>().add(FavouriteFileEvent(
        file: widget.file, isFavourite: isFavourite ? 1 : 0));
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }

  void _download(String url) async {
    final status = await Permission.storage.request();

    if (status.isGranted) {
      // final externalDir = await getExternalStorageDirectory();
      Directory? externalDir;

      if (Platform.isIOS) {
        externalDir = await getApplicationDocumentsDirectory();
      } else {
        externalDir = Directory('/storage/emulated/0/Download');
        if (!await externalDir.exists())
          externalDir = await getExternalStorageDirectory();
      }

      final id = await FlutterDownloader.enqueue(
        url: url,
        savedDir: externalDir!.path,
        showNotification: true,
        openFileFromNotification: true,
      );
    } else {
      print('Permission Denied');
    }
  }

  Future<Null> urlFileShare() async {
    final RenderBox box = context.findRenderObject() as RenderBox;
    if (Platform.isAndroid) {
      var url = 'https://i.ytimg.com/vi/fq4N0hgOWzU/maxresdefault.jpg';
      // var response = await get(Uri.parse(url));
      // final documentDirectory = await getExternalStorageDirectory();
      // File imgFile = new File('$documentDirectory/flutter.png');
      // imgFile.writeAsBytesSync(response.bodyBytes);
      // Share.shareFiles(["${documentDirectory}/flutter.png"]);
      // ['PNG', 'JPG'];
      // subject:
      // 'URL File Share';
      // text:
      // 'Hello, check your share files!';
      // sharePositionOrigin:
      // box.localToGlobal(Offset.zero) & box.size;
      Share.share(url);
    } else {
      Share.share('Hello, check your share files!',
          subject: 'URL File Share',
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      decoration: BoxDecoration(
          color: AppColors.bottomSheetFileDetailColor,
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: () {
              _download(
                  "https://cdn.pixabay.com/photo/2015/09/16/08/55/online-942406_960_720.jpg");
            },
            child: Image.asset(
              ResAssets.icons.iconDowload,
              height: 30,
              width: 30,
              fit: BoxFit.fill,
            ),
          ),
          InkWell(
            onTap: () {
              if (widget.file.image != null) {
                // Share.shareFiles([], text: "view file""");
                urlFileShare();
              } else {
                print("not file selected");
              }

              // showModalBottomSheet(
              //   context: context,
              //   builder: (context) {
              //     return SizedBox(
              //       height: MediaQuery.of(context).size.height / 4,
              //       width: MediaQuery.of(context).size.width,
              //       child: BottomSheetShare(file: widget.file),
              //     );
              //   },
              // );
            },
            child: Image.asset(
              ResAssets.icons.iconShare,
              height: 30,
              width: 30,
              fit: BoxFit.fill,
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                if (isFavourite) {
                  isFavourite = false;
                } else {
                  isFavourite = true;
                }
              });
              _favouriteFile();
            },
            child: isFavourite
                ? const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  )
                : const Icon(Icons.favorite_border),
          ),
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => PopUpConfirmDeleteFile(file: widget.file),
              );
            },
            child: Image.asset(
              ResAssets.icons.iconDelete,
              height: 30,
              width: 30,
              fit: BoxFit.fill,
            ),
          )
        ],
      ),
    );
  }
}
