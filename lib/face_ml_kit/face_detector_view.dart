import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import 'detector_view.dart';
import 'painters/face_detector_painter.dart';

class FaceDetectorView extends StatefulWidget {
  const FaceDetectorView({super.key});

  @override
  State<FaceDetectorView> createState() => _FaceDetectorViewState();
}

class _FaceDetectorViewState extends State<FaceDetectorView> {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableLandmarks: true,
    ),
  );
  bool _canProcess = true;
  bool _isBusy = false;
  var _cameraLensDirection = CameraLensDirection.front;
  final ValueNotifier<CustomPaint?> _customPaint = ValueNotifier(null);
  final ValueNotifier<String?> _text = ValueNotifier('');
  final ValueNotifier<Widget> indicator =
      ValueNotifier(const SizedBox.shrink());
  final ValueNotifier<bool> isFaceDetected = ValueNotifier(false);
  final ValueNotifier<int> tick = ValueNotifier(60);

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   Timer.periodic(const Duration(seconds: 1), (timer) {
    //     tick.value = tick.value - 1;
    //     if (tick.value == 0) {
    //       timer.cancel();
    //       showDialog(
    //         context: context,
    //         builder: (_) {
    //           return const AlertDialog.adaptive(
    //             content: Text('data'),
    //           );
    //         },
    //       ).then((_) => Navigator.pop(context));
    //     }
    //   });
    // });
  }

  @override
  void dispose() {
    _canProcess = false;
    _faceDetector.close();
    _text.dispose();
    // indicator.dispose();
    isFaceDetected.dispose();
    tick.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Ambil Foto'),
      ),
      body: DetectorView(
        title: 'Face Detector',
        customPaint: _customPaint,
        text: _text,
        indicator: indicator,
        isFaceDetected: isFaceDetected,
        onImage: processImage,
        initialDetectionMode: DetectorViewMode.liveFeed,
        initialCameraLensDirection: CameraLensDirection.front,
        onCameraLensDirectionChanged: (value) => _cameraLensDirection = value,
      ),
    );
  }

  Future<void> processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    _text.value = '';
    final faces = await _faceDetector.processImage(inputImage);
    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      final painter = FaceDetectorPainter(
        faces,
        inputImage.metadata!.size,
        inputImage.metadata!.rotation,
        _cameraLensDirection,
      );
      _customPaint.value = CustomPaint(painter: painter);
      if (faces.isNotEmpty) {
        isFaceDetected.value = true;
        indicator.value = Image.asset(
          "assets/enable_green_ico.png",
          width: 56,
        );
      } else {
        isFaceDetected.value = false;

        indicator.value = indicator.value = Image.asset(
          "assets/disable_check_ico.png",
          width: 56,
        );
      }
    } else {
      String text = 'Faces found: ${faces.length}\n\n';
      for (final face in faces) {
        text += 'face: ${face.boundingBox}\n\n';
      }
      _text.value = text;
      // TODO: set _customPaint to draw boundingRect on top of image
      _customPaint.value = null;
      isFaceDetected.value = false;
      indicator.value = const SizedBox.shrink();
    }
    _isBusy = false;
  }
}
