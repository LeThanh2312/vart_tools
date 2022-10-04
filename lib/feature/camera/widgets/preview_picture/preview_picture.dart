import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:vart_tools/common/enum/camera_type.dart';
import 'package:vart_tools/feature/camera/view_model/crop_picture_bloc.dart';

class PreviewPicture extends StatefulWidget {
  const PreviewPicture({
    Key? key,
    required this.type,
  }) : super(key: key);
  final CameraType type;

  @override
  State<PreviewPicture> createState() => _PreviewPictureState();
}

class _PreviewPictureState extends State<PreviewPicture> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CameraPictureViewModel, CropAndFilterPictureState>(
      builder: (context, state) {
        switch (state.status) {
          case CropAndFilterPictureStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case CropAndFilterPictureStatus.success:
            return Container(
              child: widget.type == CameraType.cardID
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _numbered('1'),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.memory(state.pictureCrop[0],
                                fit: BoxFit.cover, width: 100),
                            const SizedBox(
                              height: 20,
                            ),
                            Image.memory(state.pictureCrop[1],
                                fit: BoxFit.cover, width: 100),
                          ],
                        ),
                      ],
                    )
                  : Expanded(
                      child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      children: state.pictureCrop.map((e) {
                        int index = state.pictureCrop.indexOf(e);
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _numbered((index + 1).toString()),
                            Container(
                              margin:
                                  const EdgeInsets.only(bottom: 10, left: 10),
                              child: Image.memory(
                                state.pictureCrop[index],
                                fit: BoxFit.cover,
                                width: 30.0.w,
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    )),
            );
          case CropAndFilterPictureStatus.failure:
            return const Center(child: Text("Something went wrong"));
          default:
            return const SizedBox();
        }
      },
    );
  }

  Widget _numbered(String text) {
    return Text(
      text.length == 1 ? '0$text' : text,
    );
  }
}
