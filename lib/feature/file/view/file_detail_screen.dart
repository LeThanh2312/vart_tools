import 'package:flutter/material.dart';
import 'package:vart_tools/database/file_database.dart';
import 'package:vart_tools/feature/file/widget/bottom_bar.dart';
import 'package:vart_tools/feature/home/widgets/search_widget.dart';
import 'package:vart_tools/res/font_size.dart';

class FileDetailScrenn extends StatefulWidget {
  const FileDetailScrenn({Key? key, required this.file}) : super(key: key);
  final FileModel file;

  @override
  State<FileDetailScrenn> createState() => _FileDetailScrennState();
}

class _FileDetailScrennState extends State<FileDetailScrenn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 20),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 15, right: 15, top: 20),
              child: SearchWidget(),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
              child: Row(
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.arrow_back_ios)),
                  Text(
                    widget.file.name,
                    style: ResStyle.h6,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const Align(
                alignment: Alignment.center, child: Text("Thông Tin Chi Tiết")),
            Expanded(
              child: ListView(
                children: [
                  Container(
                      margin: const EdgeInsets.only(
                          top: 10, bottom: 20, left: 50, right: 50),
                      child: Image.asset(widget.file.image!)),
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
