import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import '../../../database/file_database.dart';
import '../widget/convert_text_widgets/drag_bottom_convert_text_widget.dart';
import '../widget/convert_text_widgets/text_detector_painter.dart';

class ConvertTextScreen extends StatefulWidget {
  const ConvertTextScreen({
    Key? key,
    required this.file,
  }) : super(key: key);
  final FileModel file;

  @override
  State<ConvertTextScreen> createState() => _ConvertTextScreenState();
}

class _ConvertTextScreenState extends State<ConvertTextScreen> {
  late final String _imagePath;
  late final TextRecognizer _textDetector;

  Size? _imageSize;

  final List<TextElement> _elementsOrigin = [];

  List<TextElement> _elements = [];

  List<String>? _listStrings;
  List<String>? _listStringsOrigin;

  late bool isSelectAll;

  late RecognizedText text;

  String pattern = r"^[a-zA-Z0-9]";

  var scale;

  @override
  void initState() {
    _imagePath = widget.file.image!;
    _textDetector = GoogleMlKit.vision.textRecognizer();
    _recognizeString();
    isSelectAll = true;
    super.initState();
  }

  void onChangeSelectAll(bool value) {
    isSelectAll = value;
    if (value == true) {
      _listStrings = [..._listStringsOrigin!];
      _elements = [..._elementsOrigin];
    } else {
      _listStrings!.clear();
      _elements.clear();
    }
    setState(() {});
  }

  Future<void> _getImageSize(File imageFile) async {
    final Completer<Size> completer = Completer<Size>();

    final Image image = Image.file(imageFile);
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        ));
      }),
    );

    final Size imageSize = await completer.future;
    setState(() {
      _imageSize = imageSize;
    });
  }

  void _recognizeString() async {
    _getImageSize(File(_imagePath));

    final inputImage = InputImage.fromFilePath(_imagePath);
    text = await _textDetector.processImage(inputImage);

    RegExp regEx = RegExp(pattern);

    List<String> strings = [];

    for (TextBlock block in text.blocks) {
      for (TextLine line in block.lines) {
        if (regEx.hasMatch(line.text)) {
          strings.add(line.text);
          for (TextElement element in line.elements) {
            _elementsOrigin.add(element);
            _elements.add(element);
          }
        }
      }
    }

    setState(() {
      _listStrings = [...strings];
      _listStringsOrigin = [...strings];
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_imageSize != null) {
      scale = _imageSize!.width / MediaQuery.of(context).size.width;
    }
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            _imageSize != null
                ? Container(
                    width: double.maxFinite,
                    color: Colors.grey[50],
                    child: Stack(
                      children: [
                        CustomPaint(
                          foregroundPainter: TextDetectorPainter(
                            _imageSize!,
                            _elements,
                            isSelectAll,
                            _elementsOrigin,
                          ),
                          child: AspectRatio(
                            aspectRatio: _imageSize!.aspectRatio,
                            child: Image.file(
                              File(_imagePath),
                            ),
                          ),
                        ),
                        (isSelectAll)
                            ? Container()
                            : AspectRatio(
                                aspectRatio: _imageSize!.aspectRatio,
                                child: GestureDetector(onPanUpdate: (details) {
                                  RegExp regEx = RegExp(pattern);

                                  // for (TextBlock block in text.blocks) {
                                  //   for (TextLine line in block.lines) {
                                  //     for (TextElement element
                                  //         in line.elements) {
                                  //       var index = block.lines.indexOf(line);
                                  //       if (element.boundingBox.contains(
                                  //               details.localPosition *
                                  //                   scale) &&
                                  //           !_elements.contains(element)) {
                                  //         _elements.add(element);
                                  //         if (regEx.hasMatch(line.text) &&
                                  //             !_listStrings!
                                  //                 .contains(line.text)) {
                                  //           _listStrings!
                                  //               .insert(index, line.text);
                                  //         }
                                  //       }
                                  //     }
                                  //   }
                                  // }
                                  for (var text in _elementsOrigin) {
                                    var index = _elementsOrigin.indexOf(text);
                                    if (text.boundingBox.contains(details.localPosition * scale) && !_elements.contains(text)) {
                                      _elements.add(text);

                                      print('======= length ${_listStringsOrigin!.length}');
                                      print('======= length ${_listStrings!.length}');
                                      print('======= index $index');
                                      _listStrings!.add(_listStringsOrigin![index]);
                                    }
                                  }
                                  setState(() {});
                                }),
                              )
                      ],
                    ))
                : Container(
                    color: Colors.white,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
            Positioned(
              top: 20,
              left: 20,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Center(
                  child: Icon(Icons.arrow_back_ios),
                ),
              ),
            ),
            DragBottomConvertTextWidget(
              listString: _listStrings,
              isSelectAll: isSelectAll,
              onChangeSelectAll: onChangeSelectAll,
            )
          ],
        ),
      ),
    );
  }
}
