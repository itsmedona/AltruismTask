import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadPage extends StatefulWidget {
  const ImageUploadPage({super.key});

  @override
  State<ImageUploadPage> createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<ImageUploadPage> {
  File image;
  final picker = ImagePicker();
  List<String> imagesFromApi = [];
  int currentIndex = 0;
  late Timer timer;

  Future<void> getImage() async {
  final pickedFile = await picker.getImage(source: ImageSource.gallery);

  setState(() {
    if (pickedFile != null) {
      image = File(pickedFile.path);
      uploadImage(image);
    } else {
      print('No Image Selected');
    }
  });
}

  Future uploadImage(image) async {
    var response = await http.post(
      Uri.parse('//....api.endpoint...//'),
      headers: {
        'ContentType': 'multipart/form-data',
      },
      body: {
        'image': base64Encode(image.readAsBytesSync()),
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        imagesFromApi = json.decode(response.body);
        startImageDisplayTimer();
      });
    } else {
      ////error handling
    }
  }

  void startImageDisplayTimer() {
    timer = Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {
        if (currentIndex < imagesFromApi.length - 1) {
          currentIndex++;
        } else {
          currentIndex = 0;
        }
      });
    });
  }

  @override
  void dispose() {
    // ignore: unnecessary_null_comparison
    if (timer != null) {
      timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image'),
      ),
      body: Center(
        child: image == null
            ? Text('No image selected.')
            : Image.network(imagesFromApi[currentIndex]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}
