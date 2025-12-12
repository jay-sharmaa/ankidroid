import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';

class CustomPDFPickerScreen extends StatefulWidget {
  final List<File> files;

  const CustomPDFPickerScreen({super.key, required this.files});

  @override
  State<CustomPDFPickerScreen> createState() => _CustomPDFPickerScreenState();
}

class _CustomPDFPickerScreenState extends State<CustomPDFPickerScreen> {
  List<File> selectedFiles = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select PDF'),
      ),
      body: ListView.builder(
        itemCount: widget.files.length,
        itemBuilder: (context, index) {
          File file = widget.files[index];
          bool isSelected = selectedFiles.contains(file);

          return ListTile(
            leading: Icon(Icons.picture_as_pdf),
            title: Text(
              file.path.split('/').last,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () {
              OpenFilex.open(file.path);
            },
          );
        },
      ),
    );
  }
}
