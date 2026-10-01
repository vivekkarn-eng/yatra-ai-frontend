import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../data/yatra_journey.dart';
import 'place_story_screen.dart';
import 'scanner_screen.dart';

class AiRecognitionScreen extends StatefulWidget {
  final Uint8List imageBytes;
  final String mimeType;

  const AiRecognitionScreen({
    super.key,
    required this.imageBytes,
    this.mimeType = 'image/jpeg',
  });

  @override
  State<AiRecognitionScreen> createState() =>
      _AiRecognitionScreenState();
}

class _AiRecognitionScreenState
    extends State<AiRecognitionScreen> {
  bool _loading = true;
  String? _error;

  String _placeName = '';
  String _city = '';
  String _state = '';
  double _confidence = 0;

  @override
  void initState() {
    super.initState();
    _recognizePlace();
  }

  Future<void> _recognizePlace() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final response = await http.post(
        Uri.parse(
          'https://yatra-ai-backend.onrender.com/recognize-place',
        ),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'imageBase64':
              base64Encode(widget.imageBytes),
          'mimeType': widget.mimeType,
        }),
      );

      if (response.statusCode < 200 ||
          response.statusCode >= 300) {
        throw Exception(response.body);
      }

      final data =
          jsonDecode(response.body)
              as Map<String, dynamic>;

      if (!mounted) return;

      setState(() {
        _placeName =
            data['name'] ?? 'Unknown place';

        _city = data['city'] ?? '';
        _state = data['state'] ?? '';

        _confidence =
            (data['confidence'] ?? 0)
                .toDouble();

        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _error =
            'YATRA AI could not identify this place.\nPlease try another photo.';
      });
    }
  }

  void _showStory() {
    // Do not record unknown places.
    if (_placeName.isEmpty ||
        _placeName == 'Unknown place') {
      return;
    }

    // Record the confirmed discovery.
    YatraJourney.recordDiscovery(_placeName);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PlaceStoryScreen(
          place: {
            'name': _placeName,
            'city': _city,
            'location': _state,
          },
        ),
      ),
    );
  }

  void _scanAgain() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const ScannerScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF7F1E5),
      appBar: AppBar(
        title: const Text('YATRA AI'),
        backgroundColor:
            const Color(0xFFF7F1E5),
      ),
      body: _loading
          ? _buildLoading()
          : _error != null
              ? _buildError()
              : _buildResult(),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Container(
              width: 82,
              height: 82,
              decoration:
                  const BoxDecoration(
                color:
                    Color(0xFFF2DFC1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                size: 38,
                color:
                    Color(0xFFA6532A),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'YATRA AI is looking...',
              style: TextStyle(
                fontFamily:
                    'Cormorant Garamond',
                fontSize: 29,
                fontWeight:
                    FontWeight.w800,
                color:
                    Color(0xFF30251F),
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Identifying the heritage place in your photo.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color:
                    Color(0xFF75685D),
              ),
            ),

            const SizedBox(height: 28),

            const CircularProgressIndicator(
              color:
                  Color(0xFFA6532A),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResult() {
    final percent =
        (_confidence * 100).round();

    return SingleChildScrollView(
      padding:
          const EdgeInsets.all(18),
      child: Column(
        children: [
          ClipRRect(
            borderRadius:
                BorderRadius.circular(24),
            child: Image.memory(
              widget.imageBytes,
              height: 260,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 22),

          const Text(
            'YATRA AI THINKS THIS IS...',
            style: TextStyle(
              fontSize: 11,
              fontWeight:
                  FontWeight.w800,
              letterSpacing: 1,
              color:
                  Color(0xFFA6532A),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            _placeName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily:
                  'Cormorant Garamond',
              fontSize: 34,
              fontWeight:
                  FontWeight.w800,
              color:
                  Color(0xFF30251F),
            ),
          ),

          if (_city.isNotEmpty ||
              _state.isNotEmpty)
            Text(
              [
                if (_city.isNotEmpty) _city,
                if (_state.isNotEmpty)
                  _state,
              ].join(' • '),
              style: const TextStyle(
                fontSize: 13,
                color:
                    Color(0xFF75685D),
              ),
            ),

          const SizedBox(height: 18),

          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 9,
            ),
            decoration:
                BoxDecoration(
              color:
                  const Color(0xFFF2DFC1),
              borderRadius:
                  BorderRadius.circular(30),
            ),
            child: Text(
              'AI confidence: $percent%',
              style: const TextStyle(
                fontSize: 11,
                fontWeight:
                    FontWeight.w700,
                color:
                    Color(0xFF7C401F),
              ),
            ),
          ),

          const SizedBox(height: 28),

          const Text(
            'Is this the place?',
            style: TextStyle(
              fontFamily:
                  'Cormorant Garamond',
              fontSize: 25,
              fontWeight:
                  FontWeight.w800,
              color:
                  Color(0xFF30251F),
            ),
          ),

          const SizedBox(height: 14),

          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton.icon(
              onPressed: _showStory,
              icon: const Icon(
                Icons.auto_awesome_rounded,
              ),
              label: const Text(
                'Yes, show me the story',
                style: TextStyle(
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
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(17),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton.icon(
              onPressed: _scanAgain,
              icon: const Icon(
                Icons.camera_alt_outlined,
              ),
              label: const Text(
                'Scan Again',
                style: TextStyle(
                  fontWeight:
                      FontWeight.w700,
                ),
              ),
              style:
                  OutlinedButton.styleFrom(
                foregroundColor:
                    const Color(0xFFA6532A),
                side:
                    const BorderSide(
                  color:
                      Color(0xFFD7C09A),
                ),
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(17),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.image_search_rounded,
              size: 58,
              color:
                  Color(0xFFA6532A),
            ),

            const SizedBox(height: 18),

            Text(
              _error!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color:
                    Color(0xFF75685D),
              ),
            ),

            const SizedBox(height: 22),

            ElevatedButton.icon(
              onPressed:
                  _recognizePlace,
              icon: const Icon(
                Icons.refresh_rounded,
              ),
              label:
                  const Text('Try Again'),
            ),

            const SizedBox(height: 10),

            TextButton(
              onPressed: _scanAgain,
              child: const Text(
                'Scan another photo',
              ),
            ),
          ],
        ),
      ),
    );
  }
}