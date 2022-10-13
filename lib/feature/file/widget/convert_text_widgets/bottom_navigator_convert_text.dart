import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class BottomNavigatorConvertText extends StatefulWidget {
  const BottomNavigatorConvertText({Key? key, required this.controller}) : super(key: key);
  final   List<TextEditingController> controller;

  @override
  State<BottomNavigatorConvertText> createState() => _BottomNavigatorConvertTextState();
}

class _BottomNavigatorConvertTextState extends State<BottomNavigatorConvertText> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      color: Colors.white,
      child: Container(
        margin: const EdgeInsets.only(left: 12.0, right: 12.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              onPressed: () {
                print('===== list ${widget.controller.length}');
                String textShare = '';
                for(var textController in widget.controller){
                  textShare = '$textShare ${textController.text}';
                }
                print('===== list ${textShare}');
                const snackBar = SnackBar(
                  content: Text('Copied to Clipboard'),
                );
                Clipboard.setData(ClipboardData(text: textShare))
                    .then((value) => ScaffoldMessenger.of(context).showSnackBar(snackBar));
              },
              iconSize: 27.0,
              icon: const Icon(
                Icons.copy,
              ),
            ),
            IconButton(
              onPressed: () async {
                String textShare = '';
                for(var textController in widget.controller){
                  textShare = '$textShare ${textController.text}';
                }
                shareText(textShare);
              },
              iconSize: 27.0,
              icon: const Icon(
                Icons.share,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> shareText(String textShare) async {
    Share.shareWithResult(textShare);
  }
}
