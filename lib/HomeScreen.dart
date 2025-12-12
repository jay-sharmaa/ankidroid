import 'dart:io';

import 'package:ankidroid/utils/AppBar.dart';
import 'package:ankidroid/utils/CameraScreen.dart';
import 'package:ankidroid/utils/CustomCard.dart';
import 'package:ankidroid/utils/CustomDrawer.dart';
import 'package:ankidroid/utils/CustomFAB.dart';
import 'package:ankidroid/utils/GalleryPhotoSelect.dart';
import 'package:ankidroid/utils/PdfSelectionScreen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
  }

  Future<void> readGalleryImages() async {
    PermissionStatus permission = await Permission.photos.request();

    if (!permission.isGranted) {
      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Permission Denied'),
          content: Text('Gallery access is required to select images.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  if (await Permission.photos.isPermanentlyDenied) {
                    await openAppSettings();
                  } else {
                    await readGalleryImages();
                  }
                },
                child: Text("Try Again")
            )
          ],
        ),
      );
    } else {
      if(mounted) {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
        return CustomGalleryScreen();
      }));
      }
    }
  }

  Future<void> readPDFFiles() async {
  try {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: true,
    );

    if (result != null) {
      if (!mounted) return;
      
      List<File> files = result.paths.map((path) => File(path!)).toList();
      
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return CustomPDFPickerScreen(files: files);
      }));
    }
  } catch (e) {
    print('Error picking files: $e');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(pageName: "Home"),
      body: ListView.builder(
          itemCount: 10,
          itemBuilder: (BuildContext context, int index) {
            return  Container(
                padding: EdgeInsets.all(12),
                child: CustomCard()
            );
          }),
      floatingActionButton: ExpandableFab(
        distance: 112,
        children: [
          ActionButton(
            onPressed: () {
              readGalleryImages();
            },
            icon: const Icon(Icons.insert_photo),
          ),
          ActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return CameraScreen();
              }));
            },
            icon: const Icon(Icons.camera),
          ),
          ActionButton(
            onPressed: () {
              readPDFFiles();
            },
            icon: const Icon(Icons.picture_as_pdf),
          ),
        ],
      ),
      drawer: CustomDrawer(),
    );
  }
}
