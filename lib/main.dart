import 'package:flutter/material.dart';

import 'view/Pages/ImageUploadPage.dart';

void main() {
  runApp(FaceSearchApp());
}

class FaceSearchApp extends StatelessWidget {
  const FaceSearchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'FaceSearchApp',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ImageUploadPage(),
    );
  }
}
