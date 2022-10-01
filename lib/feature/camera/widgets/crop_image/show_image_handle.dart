import 'package:flutter/material.dart';
import '../../view_model/crop_picture_bloc.dart';
import 'crop_image_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShowImageHandle extends StatefulWidget {
  const ShowImageHandle({
    Key? key,
    required this.isRotating,
  }) : super(key: key);
  final bool isRotating;

  @override
  State<ShowImageHandle> createState() => _ShowImageHandleState();
}

class _ShowImageHandleState extends State<ShowImageHandle> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CameraPictureViewModel, CropAndFilterPictureState>(
      builder: (context, state) {
        switch (state.status) {
          case CropAndFilterPictureStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case CropAndFilterPictureStatus.success:
            return Expanded(
              child: Stack(
                children: [
                  Center(
                    child: CropImageWidget(
                      image: state.pictureCrop[state.index - 1],
                      height: MediaQuery.of(context).size.height - 230,
                      width: MediaQuery.of(context).size.width,
                      index: state.index,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () async {
                              if (state.index > 1) {
                                context
                                    .read<CameraPictureViewModel>()
                                    .add(Increment(index: (state.index - 1)));
                              }
                              setState(() {});
                            },
                            iconSize: 27.0,
                            icon: const Icon(
                              Icons.arrow_circle_left_outlined,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                                '${state.index}/${state.pictureCrop.length}'),
                          ),
                          IconButton(
                            onPressed: () async {
                              if (state.index < state.pictureCrop.length) {
                                context
                                    .read<CameraPictureViewModel>()
                                    .add(Decrement(index: (state.index + 1)));
                              }
                              setState(() {});
                            },
                            iconSize: 27.0,
                            icon: const Icon(
                              Icons.arrow_circle_right_outlined,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          case CropAndFilterPictureStatus.failure:
            return const Center(child: Text("Something went wrong"));
          default:
            return const SizedBox();
        }
      },
    );
  }
}
