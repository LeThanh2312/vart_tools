import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import '../../../database/file_database.dart';
import '../widget/convert_text_widgets/bottom_navigator_convert_text.dart';
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

  Map<int, String> string = {};
  Map<int, String> stringOrigin = {};

  late bool isSelectAll;

  late RecognizedText text;

  String pattern = r"^[a-zA-Z0-9]";

  late double scale;

  List<TextEditingController> controller = [];
  List<TextEditingController> controllerEdit= [];

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
      _listStrings = [...stringOrigin.values];
      _elements = [..._elementsOrigin];
    } else {
      _listStrings!.clear();
      _elements.clear();
      string.clear();
      controller.clear();
      controllerEdit.clear();
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
          for (var text in strings) {
            var index = strings.indexOf(text);
            string[index] = text;
            stringOrigin[index] = text;
          }
          for (TextElement element in line.elements) {
            _elementsOrigin.add(element);
            _elements.add(element);
          }
        }
      }
    }
    setState(() {
      _listStrings = [...string.values];
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_imageSize != null) {
      scale = _imageSize!.width / MediaQuery.of(context).size.width;
    }
    final _isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            stringOrigin.isNotEmpty
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
                                  for (var text in _elementsOrigin) {
                                    if (text.boundingBox.contains(
                                            details.localPosition * scale) &&
                                        !_elements.contains(text)) {
                                      _elements.add(text);
                                      var key = stringOrigin.keys.firstWhere(
                                        (k) => stringOrigin[k]!
                                            .contains(text.text),
                                      );
                                      print('====== ${text.text}');
                                      if (string.keys.contains(key)) {
                                        string.update(key, (value) => '${string[key]} ${text.text}');
                                        print('===== 1');
                                      } else {
                                        string[key] = text.text;
                                        print('===== 2');
                                      }

                                    }
                                  }
                                  setState(() {
                                    string = Map.fromEntries(
                                        string.entries.toList()
                                          ..sort((e1, e2) =>
                                              e1.key.compareTo(e2.key)));
                                    _listStrings = [...string.values];
                                  });
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
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: DragBottomConvertTextWidget(
                listString: _listStrings,
                isSelectAll: isSelectAll,
                onChangeSelectAll: onChangeSelectAll,
                controller: controller,
                controllerEdit: controllerEdit,
              ),
            )
          ],
        ),
        bottomNavigationBar: _isKeyboard ? SizedBox(): BottomNavigatorConvertText(controller: controllerEdit,),
      ),
    );
  }

}
