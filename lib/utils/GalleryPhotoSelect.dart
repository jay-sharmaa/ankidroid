import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:io';
import 'dart:typed_data';

class CustomGalleryScreen extends StatefulWidget {
  const CustomGalleryScreen({super.key});

  @override
  State<CustomGalleryScreen> createState() => _CustomGalleryScreenState();
}

class _CustomGalleryScreenState extends State<CustomGalleryScreen> {
  List<AssetEntity> assets = [];
  List<AssetEntity> selectAssets = [];
  Map<String, Uint8List> thumbnailCache = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadGalleryImages();
  }

  Future<void> loadGalleryImages() async {
    final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
        onlyAll: true
    );

    if(albums.isNotEmpty) {
      final recentAssets = await albums[0].getAssetListPaged(
          page: 0,
          size: 100
      );

      for (var asset in recentAssets) {
        final thumb = await asset.thumbnailDataWithSize(
          ThumbnailSize(200, 200),
        );
        if (thumb != null) {
          thumbnailCache[asset.id] = thumb;
        }
      }

      setState(() {
        assets = recentAssets;
        isLoading = false;
      });
    }
  }

  void toggleSelection(AssetEntity asset) {
    setState(() {
      if (selectAssets.contains(asset)) {
        selectAssets.remove(asset);
      }
      else {
        selectAssets.add(asset);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Photos (${selectAssets.length})'),
        actions: [
          if (selectAssets.isNotEmpty)
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () async {
                List<File?> files = await Future.wait(
                  selectAssets.map((asset) => asset.file),
                );

                Navigator.pop(context, files.whereType<File>().toList());
              },
            ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
        ),
        itemCount: assets.length,
        itemBuilder: (context, index) {
          final asset = assets[index];
          final isSelected = selectAssets.contains(asset);

          return GestureDetector(
            onTap: () => toggleSelection(asset),
            child: Stack(
              fit: StackFit.expand,
              children: [
                thumbnailCache[asset.id] != null
                    ? Image.memory(
                  thumbnailCache[asset.id]!,
                  fit: BoxFit.cover,
                )
                    : Container(
                  color: Colors.grey[300],
                  child: Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),

                if (isSelected)
                  Container(
                    color: Colors.blue.withValues(alpha: 0.3),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.blue,
                          child: Icon(
                            Icons.check,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                if (!isSelected)
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.white.withValues(alpha: 0.7),
                        child: Container(),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}