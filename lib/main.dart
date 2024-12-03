import 'dart:io';

import 'package:face_detection/core/app_button.dart';
import 'package:face_detection/core/app_color.dart';
import 'package:flutter/material.dart';

import 'face_ml_kit/face_detector_view.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: _Home(),
    );
  }
}

class _Home extends StatefulWidget {
  const _Home();

  @override
  State<_Home> createState() => _HomeState();
}

class _HomeState extends State<_Home> {
  File? imageFile;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: imageFile == null
          ? Center(
              child: AppButon(
                buttonColor: AppColor.mainColor,
                label: "Take Photo",
                onPressed: () async {
                  await _processImageFile(context);
                },
              ),
            )
          : Stack(
              children: [
                Positioned.fill(
                  child: Image.file(
                    imageFile!,
                    fit: BoxFit.cover,
                    height: size.height,
                    width: size.width,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: AppButon(
                      label: "Ambil Ulang Poto",
                      buttonColor: AppColor.mainColor,
                      onPressed: () async {
                        await _processImageFile(context);
                      },
                    ),
                  ),
                )
              ],
            ),
    );
  }

  Future<void> _processImageFile(BuildContext context) async {
    var newImgFile = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const FaceDetectorView(),
      ),
    );

    if (newImgFile is File &&
        newImgFile.path.isNotEmpty &&
        newImgFile.path != 'path') {
      setState(() {
        imageFile = newImgFile;
      });
    }
  }
}
