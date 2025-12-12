import 'package:flutter/material.dart';

PreferredSizeWidget CustomAppBar({required String pageName}) {
  return AppBar(
        title: Text('AnkiDroid', style: TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: Colors.blue.shade300,
        titleSpacing: 0,
        actions: [
          Text(pageName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(width: 16,)
        ],
      );
}