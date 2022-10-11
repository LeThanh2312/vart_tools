import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import '../../../database/file_database.dart';
import '../widget/convert_text_widgets/drag_bottom_convert_text_widget.dart';
import '../widget/convert_text_widgets/text_detector_painter.dart';

class ConvertTextScreen extends StatefulWidget {
  const ConvertTextScreen({Key? key, required this.file}) : super(key: key);
  final FileModel file;

  @override
  State<ConvertTextScreen> createState() => _ConvertTextScreenState();
}

class _ConvertTextScreenState extends State<ConvertTextScreen> {
  @override
  void initState() {
    _imagePath = widget.file.image!;
    _textDetector = GoogleMlKit.vision.textRecognizer();
    _recognizeEmails();
    super.initState();
  }

  late final String _imagePath;
  late final TextRecognizer _textDetector;
  Size? _imageSize;
  List<TextElement> _elements = [];

  List<String>? _listStrings;

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

  void _recognizeEmails() async {
    _getImageSize(File(_imagePath));

    final inputImage = InputImage.fromFilePath(_imagePath);
    final text = await _textDetector.processImage(inputImage);

    String pattern = r"^[a-zA-Z0-9]";
    RegExp regEx = RegExp(pattern);

    List<String> strings = [];

    for (TextBlock block in text.blocks) {
      for (TextLine line in block.lines) {
        print('text: ${line.text}');
        if (regEx.hasMatch(line.text)) {
          strings.add(line.text);
          for (TextElement element in line.elements) {
            _elements.add(element);
          }
        }
      }
    }

    setState(() {
      _listStrings = strings;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            _imageSize != null
                ? Container(
                    width: double.maxFinite,
                    color: Colors.white,
                    child: CustomPaint(
                      foregroundPainter: TextDetectorPainter(
                        _imageSize!,
                        _elements,
                      ),
                      child: AspectRatio(
                        aspectRatio: _imageSize!.aspectRatio,
                        child: Image.file(
                          File(_imagePath),
                        ),
                      ),
                    ),
                  )
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
            )
          ],
        ),
      ),
    );
  }
}
