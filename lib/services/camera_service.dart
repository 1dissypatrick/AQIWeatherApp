import 'package:camera/camera.dart';

class CameraService {
  CameraController? _controller;

  Future<void> initialize() async {
    final cameras = await availableCameras();
    final camera = cameras.first;

    _controller = CameraController(camera, ResolutionPreset.low, enableAudio: false);
    await _controller!.initialize();

    // Set flash mode to torch
    await _controller!.setFlashMode(FlashMode.torch);
  }

  CameraController? get controller => _controller;

  void dispose() {
    _controller?.dispose();
  }
}
