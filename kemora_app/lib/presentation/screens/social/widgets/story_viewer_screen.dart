import 'package:flutter/material.dart';
import 'dart:async';

class StoryViewerScreen extends StatefulWidget {
  final String userName;
  final String imageUrl;

  const StoryViewerScreen({super.key, required this.userName, required this.imageUrl});

  @override
  State<StoryViewerScreen> createState() => _StoryViewerScreenState();
}

class _StoryViewerScreenState extends State<StoryViewerScreen> {
  double _progress = 0.0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        _progress += 0.01;
      });
      if (_progress >= 1.0) {
        _timer?.cancel();
        Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: GestureDetector(
          onTapDown: (_) => _timer?.cancel(),
          onTapUp: (_) => _startTimer(),
          onVerticalDragEnd: (details) {
            if (details.primaryVelocity != null && details.primaryVelocity! > 0) {
              Navigator.pop(context);
            }
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(widget.imageUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.image, color: Colors.white, size: 64))),
              // Progress bar
              Positioned(
                top: 10,
                left: 10,
                right: 10,
                child: Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: _progress,
                        backgroundColor: Colors.white.withValues(alpha: 0.3),
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              // User info
              Positioned(
                top: 30,
                left: 16,
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 16,
                      child: Text(widget.userName[0], style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 8),
                    Text(widget.userName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, shadows: [Shadow(color: Colors.black54, blurRadius: 4)])),
                    const SizedBox(width: 8),
                    const Text('2h', style: TextStyle(color: Colors.white70, shadows: [Shadow(color: Colors.black54, blurRadius: 4)])),
                  ],
                ),
              ),
              // Close button
              Positioned(
                top: 20,
                right: 10,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, shadows: [Shadow(color: Colors.black54, blurRadius: 4)]),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
