import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vart_tools/database/file_database.dart';
import 'package:vart_tools/database/folder_database.dart';
import 'package:vart_tools/res/assets.dart';
import 'package:intl/intl.dart';

class FileFavouriteItem extends StatefulWidget {
  const FileFavouriteItem({Key? key, required this.file}) : super(key: key);
  final FileModel file;

  @override
  State<FileFavouriteItem> createState() => _FileFavouriteItemState();
}

class _FileFavouriteItemState extends State<FileFavouriteItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 15, right: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 50,
            width: 50,
            child: Image.file(File(widget.file.image!), 
                                                fit: BoxFit.cover, 
                                                width: double.infinity, 
                                                height: double.infinity,),
          ),
          const SizedBox(
            width: 30,
          ),
          Expanded(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.file.name),
              const SizedBox(height: 5,),
              Text(DateFormat('dd/MM/yyyy hh:mm')
                        .format(DateTime.parse(widget.file.dateUpdate!)))
            ],
          )),
          const SizedBox(
            height: 30,
            width: 30,
          ),
          const Icon(
            Icons.favorite,
            color: Colors.red,
          ),
        ],
      ),
    );
  }
}
