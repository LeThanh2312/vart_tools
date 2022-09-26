import 'package:flutter/material.dart';

class FileScreen extends StatefulWidget {
  const FileScreen({Key? key}) : super(key: key);

  @override
  State<FileScreen> createState() => _FileScreenState();
}

class _FileScreenState extends State<FileScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('File'),
    );
  }
}
