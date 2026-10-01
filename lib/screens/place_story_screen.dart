import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../data/place_data.dart';
import '../widgets/yatra_story_visual.dart';

class PlaceStoryScreen extends StatefulWidget {
  final Map<String, String> place;

  const PlaceStoryScreen({
    super.key,
    required this.place,
  });

  @override
  State<PlaceStoryScreen> createState() => _PlaceStoryScreenState();
}

class _PlaceStoryScreenState extends State<PlaceStoryScreen> {
  String? _aiStory;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _generateStory();
  }

  // ==========================================================
  // GENERATE STORY FROM LIVE YATRA AI BACKEND
  // ==========================================================

  Future<void> _generateStory() async {
    final name = widget.place['name'] ?? 'Unknown Place';
    final city = widget.place['city'] ?? '';
    final location = widget.place['location'] ?? '';

    if (mounted) {
      setState(() {
        _loading = true;
        _error = null;
      });
    }

    try {
      final response = await http
          .post(
            Uri.parse(
              'https://yatra-ai-backend.onrender.com/generate-story',
            ),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'place': '$name, $city, $location',
            }),
          )
          .timeout(const Duration(seconds: 30));

      debugPrint('YATRA AI status: ${response.statusCode}');
      debugPrint('YATRA AI response: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (!mounted) return;

        setState(() {
          _aiStory = data['story']?.toString() ?? '';
          _loading = false;
        });
      } else {
        if (!mounted) return;

        setState(() {
          _error = 'YATRA AI returned an error.';
          _loading = false;
        });
      }
    } catch (e) {
      debugPrint('YATRA AI connection error: $e');

      if (!mounted) return;

      setState(() {
        _error = 'Could not connect to YATRA AI.';
        _loading = false;
      });
    }
  }

  // ==========================================================
  // CLEAN AI TEXT
  // ==========================================================

  String _clean(String text) {
    return text
        .replaceAll('###', '')
        .replaceAll('##', '')
        .replaceAll('#', '')
        .replaceAll('**', '')
        .trim();
  }

  // ==========================================================
  // PARSE AI STORY INTO PREMIUM JOURNAL SECTIONS
  // ==========================================================

  Map<String, String> _parseStory(String text) {
    final sections = <String, String>{};

    const headings = [
      'THE STORY',
      'HISTORY',
      'ARCHITECTURE',
      'WHAT MAKES IT SPECIAL',
      'DID YOU KNOW?',
      'VISITOR CONTEXT',
    ];

    String? currentHeading;
    final buffer = StringBuffer();

    for (final rawLine in text.replaceAll('\r\n', '\n').split('\n')) {
      var line = rawLine.trim();

      line = _clean(line);

      final upper = line.toUpperCase();

      String? matchedHeading;

      for (final heading in headings) {
        if (upper == heading) {
          matchedHeading = heading;
          break;
        }
      }

      if (matchedHeading != null) {
        if (currentHeading != null &&
            buffer.toString().trim().isNotEmpty) {
          sections[currentHeading] = buffer.toString().trim();
        }

        currentHeading = matchedHeading;
        buffer.clear();
      } else if (currentHeading != null) {
        buffer.writeln(rawLine.trim());
      }
    }

    if (currentHeading != null &&
        buffer.toString().trim().isNotEmpty) {
      sections[currentHeading] = buffer.toString().trim();
    }

    return sections;
  }

  // ==========================================================
  // BUILD PREMIUM YATRA STORY SCREEN
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    final name = widget.place['name'] ?? 'Unknown Place';
    final city = widget.place['city'] ?? '';
    final location = widget.place['location'] ?? '';

    final parsed = _aiStory == null
        ? <String, String>{}
        : _parseStory(_aiStory!);

    String intro = '';

    if (_aiStory != null) {
      final storyIndex = _aiStory!.toUpperCase().indexOf('THE STORY');

      if (storyIndex > 0) {
        intro = _clean(
          _aiStory!.substring(0, storyIndex),
        );
      }
    }

    return YatraStoryVisual(
      name: name,
      city: city,
      location: location,
      image: widget.place['image'],
      intro: intro,
      sections: parsed,
      loading: _loading,
      error: _error,
      onRetry: _generateStory,
      onBack: () {
        Navigator.pop(context);
      },
    );
  }
}