// import 'package:flutter/material.dart';
// import 'package:vart_tools/database/file_database.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:vart_tools/feature/file/view/file_detail_screen.dart';
// import 'package:vart_tools/feature/file/view_model/file_bloc.dart';

// // void main() => runApp(const MyApp());

// // class MyApp extends StatelessWidget {
// //   const MyApp({super.key});

// //   static const String _title = 'Flutter Code Sample';

// //   @override
// //   Widget build(BuildContext context) {
// //     return const MaterialApp(
// //       title: _title,
// //       home: ListTileSelectExample(),
// //     );
// //   }
// // }

// class ListTileSelectExample extends StatefulWidget {
//   const ListTileSelectExample({super.key});

//   @override
//   ListTileSelectExampleState createState() => ListTileSelectExampleState();
// }

// class ListTileSelectExampleState extends State<ListTileSelectExample> {
//   bool isSelectionMode = false;
//   // final int listLength = 30;
//   late List<bool> _selected;
//   bool _selectAll = false;
//   bool _isGridMode = false;
//   final List<FileModel> filesData = [
//     FileModel(
//       id: 1,
//       name: "file 1",
//       idFolder: 1,
//       image: "assets/images/avatar.jpg",
//       format: "JPG",
//       size: 250,
//       dateCreate: '2022-09-29 08:28:58.334697',
//       dateUpdate: '2022-09-29 08:28:58.334697',
//     ),
//     FileModel(
//       id: 2,
//       name: "file 2",
//       idFolder: 1,
//       image: "assets/images/avatar.jpg",
//       format: "JPG",
//       size: 550,
//       dateCreate: '2022-09-29 08:29:58.334697',
//       dateUpdate: '2022-09-29 08:29:58.334697',
//     ),
//     FileModel(
//       id: 3,
//       name: "file 3",
//       idFolder: 1,
//       image: "assets/images/avatar.jpg",
//       format: "PNG",
//       size: 200,
//       dateCreate: '2022-09-28 08:28:58.334697',
//       dateUpdate: '2022-09-28 08:28:58.334697',
//     ),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     initializeSelection();
//   }

//   void initializeSelection() {
//     _selected = List<bool>.generate(filesData.length, (_) => false);
//   }

//   @override
//   void dispose() {
//     _selected.clear();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text(
//             'ListTile selection',
//           ),
//           leading: isSelectionMode
//               ? IconButton(
//                   icon: const Icon(Icons.close),
//                   onPressed: () {
//                     setState(() {
//                       isSelectionMode = false;
//                     });
//                     initializeSelection();
//                   },
//                 )
//               : const SizedBox(),
//           actions: <Widget>[
//             // if (_isGridMode)
//             //   IconButton(
//             //     icon: const Icon(Icons.grid_on),
//             //     onPressed: () {
//             //       setState(() {
//             //         _isGridMode = false;
//             //       });
//             //     },
//             //   )
//             // else
//             //   IconButton(
//             //     icon: const Icon(Icons.list),
//             //     onPressed: () {
//             //       setState(() {
//             //         _isGridMode = true;
//             //       });
//             //     },
//             //   ),
//             if (isSelectionMode)
//               TextButton(
//                   child: !_selectAll
//                       ? const Text(
//                           'select all',
//                           style: TextStyle(color: Colors.white),
//                         )
//                       : const Text(
//                           'unselect all',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                   onPressed: () {
//                     _selectAll = !_selectAll;
//                     setState(() {
//                       _selected = List<bool>.generate(
//                           filesData.length, (_) => _selectAll);
//                     });
//                   }),
//           ],
//         ),
//         body: GridBuilder(
//           isSelectionMode: isSelectionMode,
//           selectedList: _selected,
//           onSelectionChange: (bool x) {
//             setState(() {
//               isSelectionMode = x;
//             });
//           },
//         )
//         // : const SizedBox(),
//         // : ListBuilder(
//         //     isSelectionMode: isSelectionMode,
//         //     selectedList: _selected,
//         //     onSelectionChange: (bool x) {
//         //       setState(() {
//         //         isSelectionMode = x;
//         //       });
//         //     },
//         //   ),
//         );
//   }
// }

// class GridBuilder extends StatefulWidget {
//   const GridBuilder({
//     super.key,
//     required this.selectedList,
//     required this.isSelectionMode,
//     required this.onSelectionChange,
//   });

//   final bool isSelectionMode;
//   final Function(bool)? onSelectionChange;
//   final List<bool> selectedList;

//   @override
//   GridBuilderState createState() => GridBuilderState();
// }

// class GridBuilderState extends State<GridBuilder> {
//   void _toggle(int index) {
//     if (widget.isSelectionMode) {
//       setState(() {
//         widget.selectedList[index] = !widget.selectedList[index];
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GridView.builder(
//         itemCount: widget.selectedList.length,
//         gridDelegate:
//             const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
//         itemBuilder: (_, int index) {
//           return InkWell(
//               onTap: () => _toggle(index),
//               onLongPress: () {
//                 if (!widget.isSelectionMode) {
//                   setState(() {
//                     widget.selectedList[index] = true;
//                   });
//                   widget.onSelectionChange!(true);
//                 }
//               },
//               child: BlocBuilder<FilesViewModel, FilesViewState>(
//                 builder: (context, state) {
//                   if (state.isSuccess) {
//                     print("vo day");
//                     return ListView(
//                         children: state.groupByDateUpdate.keys.map((key) {
//                       final value = state.groupByDateUpdate[key];
//                       return Column(
//                         mainAxisSize: MainAxisSize.min,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.only(
//                                 top: 10, left: 15, bottom: 5),
//                             child: Text(key.toString()),
//                           ),
//                           GridView.count(
//                             primary: false,
//                             crossAxisCount: 2,
//                             mainAxisSpacing: 20,
//                             crossAxisSpacing: 20,
//                             shrinkWrap: true,
//                             children: <Widget>[
//                               for (var file in value!)
//                                 InkWell(
//                                   onTap: () => Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) => FileDetailScrenn(
//                                               file: FileModel.fromMap(file),
//                                             )),
//                                   ),
//                                   child: Image.asset(
//                                     '${file["image"]}',
//                                     width:
//                                         MediaQuery.of(context).size.width / 3,
//                                     height:
//                                         MediaQuery.of(context).size.width / 3,
//                                   ),
//                                 ),
//                             ],
//                           )
//                         ],
//                       );
//                     }).toList());
//                   } else if (state.isFailure) {
//                     return Text(state.message);
//                   } else {
//                     return const Center(
//                       child: CircularProgressIndicator(),
//                     );
//                   }
//                 },
//               )
//               // GridTile(
//               //     child: Container(
//               //   child: widget.isSelectionMode
//               //       ? Checkbox(
//               //           onChanged: (bool? x) => _toggle(index),
//               //           value: widget.selectedList[index])
//               //       : const Icon(Icons.image),
//               // )),
//               );
//         });
//   }
// }

// // class ListBuilder extends StatefulWidget {
// //   const ListBuilder({
// //     super.key,
// //     required this.selectedList,
// //     required this.isSelectionMode,
// //     required this.onSelectionChange,
// //   });

// //   final bool isSelectionMode;
// //   final List<bool> selectedList;
// //   final Function(bool)? onSelectionChange;

// //   @override
// //   State<ListBuilder> createState() => _ListBuilderState();
// // }

// // class _ListBuilderState extends State<ListBuilder> {
// //   void _toggle(int index) {
// //     if (widget.isSelectionMode) {
// //       setState(() {
// //         widget.selectedList[index] = !widget.selectedList[index];
// //       });
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return ListView.builder(
// //         itemCount: widget.selectedList.length,
// //         itemBuilder: (_, int index) {
// //           return ListTile(
// //               onTap: () => _toggle(index),
// //               onLongPress: () {
// //                 if (!widget.isSelectionMode) {
// //                   setState(() {
// //                     widget.selectedList[index] = true;
// //                   });
// //                   widget.onSelectionChange!(true);
// //                 }
// //               },
// //               trailing: widget.isSelectionMode
// //                   ? Checkbox(
// //                       value: widget.selectedList[index],
// //                       onChanged: (bool? x) => _toggle(index),
// //                     )
// //                   : const SizedBox.shrink(),
// //               title: Text('item $index'));
// //         });
// //   }
// // }
