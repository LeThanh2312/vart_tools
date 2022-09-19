import 'package:flutter/material.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const Center(
              child: Text('camera'),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.only(top: 0, right: 10, left: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      iconSize: 50,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(Icons.close, color: Colors.black),
                    ),
                    // Visibility(
                    //   visible: (styleCamera == StyleCamera.cardID),
                    //   child: Text(
                    //     isPageFirst ? 'Trang đầu' : 'Trang sau',
                    //     style: const TextStyle(color: Colors.black),
                    //   ),
                    // ),
                    // IconButton(
                    //   onPressed: () {
                    //     if (!isFlash) {
                    //       print('==== isFlash: $isFlash');
                    //       _controller.setFlashMode(FlashMode.off);
                    //     } else {
                    //       print('==== isFlash: $isFlash');
                    //       _controller.setFlashMode(FlashMode.always);
                    //     }
                    //     isFlash = !isFlash;
                    //     setState(() {});
                    //   },
                    //   iconSize: 50,
                    //   padding: EdgeInsets.zero,
                    //   constraints: const BoxConstraints(),
                    //   icon: Icon(isFlash ? Icons.flash_on : Icons.flash_off,
                    //       color: Colors.black),
                    // )
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}
