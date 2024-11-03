import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

enum WidgetState { NONE, LOADING, LOADED, ERROR }

class _CameraScreenState extends State<CameraScreen> {
  WidgetState _widgetState = WidgetState.NONE;
  List<CameraDescription> _cameras = List<CameraDescription>.empty();
  late CameraController _cameraController;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  @override
  Widget build(BuildContext context) {
    switch (_widgetState) {
      case WidgetState.NONE:
      case WidgetState.LOADING:
        return _buildScaffold(
            context, const Center(child: CircularProgressIndicator()));
      case WidgetState.LOADED:
        return _buildScaffold(context, CameraPreview(_cameraController));
      case WidgetState.ERROR:
        return _buildScaffold(
            context,
            const Center(
                child: Text("Error. Camera was not loaded. Restart the app")));
    }
  }

  Widget _buildScaffold(BuildContext context, Widget body) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Camera"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: body,
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            XFile xfile = await _cameraController.takePicture();
            Navigator.pop(context, xfile.path);
          },
          child: const Icon(Icons.camera)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future initializeCamera() async {
    _widgetState = WidgetState.LOADING;
    if (mounted) {
      setState(() {});
    }

    _cameras = await availableCameras();

    _cameraController = CameraController(_cameras.first, ResolutionPreset.high,
        enableAudio: false);

    await _cameraController.initialize();

    if (_cameraController.value.hasError) {
      _widgetState = WidgetState.ERROR;
      if (mounted) {
        setState(() {});
      }
    } else {
      _widgetState = WidgetState.LOADED;
      if (mounted) {
        setState(() {});
      }
    }
  }
}
