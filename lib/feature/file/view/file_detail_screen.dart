import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vart_tools/database/file_database.dart';
import 'package:vart_tools/feature/file/widget/bottom_bar.dart';
import 'package:vart_tools/feature/home/widgets/search_widget.dart';
import 'package:vart_tools/res/font_size.dart';

class FileDetailScreen extends StatefulWidget {
  const FileDetailScreen({Key? key, required this.file}) : super(key: key);
  final FileModel file;

  @override
  State<FileDetailScreen> createState() => _FileDetailScreenState();
}

class _FileDetailScreenState extends State<FileDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.file.name,
        ),
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back_ios,
            size: 30,
            color: Colors.white,
          ),
        ),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(10),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Thông Tin Chi Tiết",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  Container(
                      margin: const EdgeInsets.only(
                          top: 10, bottom: 20, left: 50, right: 50),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Image.file(
                                                  File(widget.file.image!),
                                                  fit: BoxFit.cover,
                                                  height: MediaQuery.of(context).size.height / 3,
                                                  width: MediaQuery.of(context).size.width,),
                      ),
                      ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40, bottom: 8),
                    child: Text(
                      "Name:   ${widget.file.name}",
                      style: ResStyle.fileDetailText,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40, bottom: 8),
                    child: Text(
                      "Ngày tạo:   ${widget.file.dateCreate}",
                      style: ResStyle.fileDetailText,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40, bottom: 8),
                    child: Text(
                      "Ngày cập nhật:   ${widget.file.dateUpdate}",
                      style: ResStyle.fileDetailText,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40, bottom: 8),
                    child: Text(
                      "Dung lượng ảnh:   ${widget.file.size}",
                      style: ResStyle.fileDetailText,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40, bottom: 8),
                    child: Text(
                      "Định dạng:   ${widget.file.format}",
                      style: ResStyle.fileDetailText,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40, bottom: 8),
                    child: Text(
                      "Link:   ${widget.file.link}",
                      style: ResStyle.fileDetailText,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40, bottom: 8),
                    child: Text(
                      "Tags:   ${widget.file.tag}",
                      style: ResStyle.fileDetailText,
                    ),
                  ),
                ],
              ),
            ),
            BottomBarFileDetail(
              file: widget.file,
            )
          ],
        ),
      ),
    );
  }
}
