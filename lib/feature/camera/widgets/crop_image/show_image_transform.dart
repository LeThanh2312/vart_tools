import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../view_model/crop_picture_bloc.dart';

class ShowImageTransform extends StatefulWidget {
  const ShowImageTransform({
    Key? key,
  }) : super(key: key);

  @override
  State<ShowImageTransform> createState() => _ShowImageTransformState();
}

class _ShowImageTransformState extends State<ShowImageTransform> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocBuilder<CameraPictureViewModel, CropAndFilterPictureState>(
          builder: (context, state) {
            switch (state.status) {
              case CropAndFilterPictureStatus.loading:
                return const Center(child: CircularProgressIndicator());
              case CropAndFilterPictureStatus.success:
                return Container(
                    color: Colors.blue,
                    height: 95.0.h,
                    width: 90.0.w,
                    margin: EdgeInsets.all(10),
                    child: Image.memory(
                      state.pictureCrop.first,
                      width: 70.0.w,
                      fit: BoxFit.contain,
                    ),
                  );
              case CropAndFilterPictureStatus.failure:
                return const Center(child: Text("Something went wrong"));
              default:
                return const SizedBox();
            }
          },
        ),
        // Container(
        //   color: Colors.blue,
        //   height: 95.0.h,
        //   width: 90.0.w,
        //   margin: EdgeInsets.all(10),
        //   child: Image.memory(
        //     widget.image,
        //     width: 70.0.w,
        //     fit: BoxFit.contain,
        //   ),
        // )
    );
  }
}
