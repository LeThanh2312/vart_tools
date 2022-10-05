// import 'package:flutter/material.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:vart_tools/database/folder_database.dart';
// import 'package:vart_tools/feature/file/view/file_screen.dart';
// import 'package:vart_tools/feature/folder/widget/folder_item.dart';

// class FolderDetailScreen extends StatefulWidget {
//   const FolderDetailScreen({Key? key, required this.folder}) : super(key: key);
//   final FolderModel folder;

//   @override
//   State<FolderDetailScreen> createState() => _FolderDetailScreenState();
// }

// class _FolderDetailScreenState extends State<FolderDetailScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("name"),
//         leading: Builder(
//           builder: (BuildContext context) {
//             return IconButton(
//                 icon: const Icon(Icons.arrow_back_ios),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 });
//           },
//         ),
//       ),
//       body: FileScreen(folder: widget.folder),
//     );
//   }
// }
