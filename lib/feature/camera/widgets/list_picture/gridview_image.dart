import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class GridviewImage extends StatefulWidget {
  const GridviewImage({
    Key? key,
    required this.listPicture,
    required this.listPictureRemove,
  }) : super(key: key);
  final List<File> listPicture;
  final List<File> listPictureRemove;

  @override
  State<GridviewImage> createState() => _GridviewImageState();
}

class _GridviewImageState extends State<GridviewImage> {

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.only(top: 0),
      itemCount: widget.listPicture.length,
      itemBuilder: (BuildContext ctx, int index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              if(widget.listPictureRemove.contains(widget.listPicture[index])){
                widget.listPictureRemove.remove(widget.listPicture[index]);
              } else {
                widget.listPictureRemove.add(widget.listPicture[index]);
              }
            });
          },
          child: filterItem(widget.listPicture[index]),
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 5.0.h / 4.5.h,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5),
    );
  }

  Widget filterItem(File picture) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Image.file(
            File(picture.path),
            fit: BoxFit.cover,
            width: 200,
            height: 200,
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: Icon(
            widget.listPictureRemove.contains(picture)
                ? Icons.check_box_outline_blank
                : Icons.check_box,
            color: widget.listPictureRemove.contains(picture)
                ? Colors.black
                : Colors.green,
          ),
        )
      ],
    );
  }
}
