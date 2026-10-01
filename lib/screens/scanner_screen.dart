import 'dart:typed_data';
import '../widgets/yatra_scanner_visual.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'ai_recognition_screen.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;

  XFile? _capturedImage;
  Uint8List? _capturedBytes;

  String? _errorMessage;

  bool _isCapturing = false;
  bool _isRestartingCamera = false;
  bool _isUsingPhoto = false;

  @override
  void initState() {
    super.initState();
    _startCamera();
  }

  // ------------------------------------------------------------
  // START CAMERA
  // ------------------------------------------------------------

  Future<void> _startCamera() async {
    try {
      if (mounted) {
        setState(() {
          _errorMessage = null;
        });
      }

      final cameras = await availableCameras();

      if (cameras.isEmpty) {
        if (mounted) {
          setState(() {
            _errorMessage = 'No camera found on this device.';
          });
        }
        return;
      }

      final controller = CameraController(
        cameras.first,
        ResolutionPreset.high,
        enableAudio: false,
      );

      _controller = controller;

      final initializeFuture = controller.initialize();
      _initializeControllerFuture = initializeFuture;

      await initializeFuture;

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Unable to access camera.';
        });
      }
    }
  }

  // ------------------------------------------------------------
  // CAPTURE PHOTO
  // ------------------------------------------------------------

  Future<void> _capturePhoto() async {
    final controller = _controller;

    if (controller == null ||
        !controller.value.isInitialized ||
        _isCapturing ||
        _isRestartingCamera) {
      return;
    }

    try {
      setState(() {
        _isCapturing = true;
        _errorMessage = null;
      });

      final image = await controller.takePicture();
      final bytes = await image.readAsBytes();

      if (!mounted) return;

      setState(() {
        _capturedImage = image;
        _capturedBytes = bytes;
        _isCapturing = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _isCapturing = false;
          _errorMessage = 'Unable to capture photo.';
        });
      }
    }
  }

  // ------------------------------------------------------------
  // RETAKE PHOTO
  // ------------------------------------------------------------

  Future<void> _retakePhoto() async {
    if (_isRestartingCamera) {
      return;
    }

    setState(() {
      _capturedImage = null;
      _capturedBytes = null;
      _errorMessage = null;
      _isRestartingCamera = true;
    });

    final oldController = _controller;

    _controller = null;
    _initializeControllerFuture = null;

    await oldController?.dispose();

    if (!mounted) return;

    await Future.delayed(
      const Duration(milliseconds: 300),
    );

    if (!mounted) return;

    await _startCamera();

    if (mounted) {
      setState(() {
        _isRestartingCamera = false;
      });
    }
  }

  // ------------------------------------------------------------
  // USE PHOTO — AI RECOGNITION
  // ------------------------------------------------------------

  void _usePhoto() {
    if (_capturedBytes == null || _isUsingPhoto) {
      return;
    }

    setState(() {
      _isUsingPhoto = true;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AiRecognitionScreen(
          imageBytes: _capturedBytes!,
          mimeType: 'image/jpeg',
        ),
      ),
    ).then((_) {
      if (mounted) {
        setState(() {
          _isUsingPhoto = false;
        });
      }
    });
  }

  // ------------------------------------------------------------
  // DISPOSE
  // ------------------------------------------------------------

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  // ------------------------------------------------------------
  // MAIN UI
  // ------------------------------------------------------------

  @override
Widget build(BuildContext context) {
  final bool photoCaptured =
      _capturedImage != null &&
      _capturedBytes != null;

  return YatraScannerVisual(
    photoCaptured: photoCaptured,
    isCapturing: _isCapturing,
    isRestarting: _isRestartingCamera,
    isUsingPhoto: _isUsingPhoto,

    preview: photoCaptured
        ? _buildPhotoPreview()
        : _buildCameraView(),

    onBack: () {
      Navigator.pop(context);
    },

    onCapture: _capturePhoto,

    onRetake: _retakePhoto,

    onUsePhoto: _usePhoto,
  );
}

  // ------------------------------------------------------------
  // CAMERA VIEW
  // ------------------------------------------------------------

  Widget _buildCameraView() {
    if (_errorMessage != null) {
      return _buildErrorView();
    }

    if (_isRestartingCamera) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: Color(0xFFA6532A),
            ),

            SizedBox(height: 14),

            Text(
              'Restarting camera...',
              style: TextStyle(
                color: Color(0xFF75685D),
              ),
            ),
          ],
        ),
      );
    }

    if (_controller == null ||
        _initializeControllerFuture == null) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFFA6532A),
        ),
      );
    }

    return FutureBuilder<void>(
      future: _initializeControllerFuture,

      builder: (context, snapshot) {
        if (snapshot.connectionState ==
                ConnectionState.done &&
            _controller != null &&
            _controller!.value.isInitialized) {
          return CameraPreview(_controller!);
        }

        if (snapshot.hasError) {
          return _buildErrorView();
        }

        return const Center(
          child: CircularProgressIndicator(
            color: Color(0xFFA6532A),
          ),
        );
      },
    );
  }

  // ------------------------------------------------------------
  // PHOTO PREVIEW
  // ------------------------------------------------------------

  Widget _buildPhotoPreview() {
    if (_capturedBytes == null) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFFA6532A),
        ),
      );
    }

    return Stack(
      fit: StackFit.expand,

      children: [
        Image.memory(
          _capturedBytes!,
          key: ValueKey(_capturedBytes),
          fit: BoxFit.cover,
        ),

        Positioned(
          top: 16,
          left: 16,

          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 7,
            ),

            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.55),
              borderRadius:
                  BorderRadius.circular(20),
            ),

            child: const Row(
              mainAxisSize: MainAxisSize.min,

              children: [
                Icon(
                  Icons.check_circle_rounded,
                  color: Colors.white,
                  size: 18,
                ),

                SizedBox(width: 6),

                Text(
                  'Photo captured',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // CAPTURE BUTTON
  // ------------------------------------------------------------

  Widget _buildCaptureButton() {
    return SizedBox(
      width: double.infinity,
      height: 58,

      child: ElevatedButton.icon(
        onPressed:
            _isCapturing || _isRestartingCamera
                ? null
                : _capturePhoto,

        icon: _isCapturing
            ? const SizedBox(
                width: 20,
                height: 20,

                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(
                Icons.camera_alt_rounded,
              ),

        label: Text(
          _isCapturing
              ? 'Capturing...'
              : 'Capture Photo',

          style: const TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),

        style: ElevatedButton.styleFrom(
          backgroundColor:
              const Color(0xFFA6532A),

          foregroundColor: Colors.white,

          disabledBackgroundColor:
              const Color(0xFFD6B9A8),

          disabledForegroundColor:
              Colors.white,

          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // RETAKE / USE PHOTO
  // ------------------------------------------------------------

  Widget _buildPhotoButtons() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 58,

            child: OutlinedButton.icon(
              onPressed:
                  _isRestartingCamera ||
                          _isUsingPhoto
                      ? null
                      : _retakePhoto,

              icon: const Icon(
                Icons.refresh_rounded,
              ),

              label: const Text(
                'Retake',
                style: TextStyle(
                  fontWeight:
                      FontWeight.w700,
                ),
              ),

              style:
                  OutlinedButton.styleFrom(
                foregroundColor:
                    const Color(0xFFA6532A),

                side: const BorderSide(
                  color: Color(0xFFA6532A),
                ),

                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(18),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: SizedBox(
            height: 58,

            child: ElevatedButton.icon(
              onPressed:
                  _isRestartingCamera ||
                          _isUsingPhoto
                      ? null
                      : _usePhoto,

              icon: _isUsingPhoto
                  ? const SizedBox(
                      width: 20,
                      height: 20,

                      child:
                          CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(
                      Icons.auto_awesome_rounded,
                    ),

              label: Text(
                _isUsingPhoto
                    ? 'Opening...'
                    : 'Use Photo',

                style: const TextStyle(
                  fontWeight:
                      FontWeight.w700,
                ),
              ),

              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFFA6532A),

                foregroundColor:
                    Colors.white,

                disabledBackgroundColor:
                    const Color(0xFFD6B9A8),

                disabledForegroundColor:
                    Colors.white,

                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(18),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // ERROR VIEW
  // ------------------------------------------------------------

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            const Icon(
              Icons.camera_alt_outlined,
              size: 70,
              color: Color(0xFFA6532A),
            ),

            const SizedBox(height: 18),

            const Text(
              'Camera Unavailable',
              style: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Color(0xFF30251F),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              _errorMessage ??
                  'Unable to access camera.',

              textAlign: TextAlign.center,

              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF75685D),
              ),
            ),
          ],
        ),
      ),
    );
  }
}