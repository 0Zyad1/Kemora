import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../../../../providers/community_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../widgets/comment_bottom_sheet.dart';

class StoryViewerScreen extends StatefulWidget {
  final String storyId;

  const StoryViewerScreen({super.key, required this.storyId});

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
      if (!mounted) return;
      setState(() {
        _progress += 0.01;
      });
      if (_progress >= 1.0) {
        _timer?.cancel();
        Navigator.pop(context);
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final community = context.watch<CommunityProvider>();
    final index = community.stories.indexWhere((s) => s.id == widget.storyId);
    if (index == -1) {
      return const Scaffold(backgroundColor: Colors.black, body: Center(child: Text('Story not found', style: TextStyle(color: Colors.white))));
    }
    
    final story = community.stories[index];

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: GestureDetector(
          onTapDown: (_) => _pauseTimer(),
          onTapUp: (_) => _startTimer(),
          onVerticalDragEnd: (details) {
            if (details.primaryVelocity != null && details.primaryVelocity! > 0) {
              Navigator.pop(context);
            }
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(story.imageAsset, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.image, color: Colors.white, size: 64))),
              
              // Gradient for bottom overlay
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 200,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black.withValues(alpha: 0.8), Colors.transparent],
                    ),
                  ),
                ),
              ),

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
                      child: Text(story.userName[0], style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 8),
                    Text(story.userName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, shadows: [Shadow(color: Colors.black54, blurRadius: 4)])),
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

              // Bottom Interaction Overlay
              Positioned(
                bottom: 24,
                left: 24,
                right: 24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (story.caption != null) ...[
                      Text(
                        story.caption!,
                        style: AppTypography.bodyLarge.copyWith(color: Colors.white, shadows: [const Shadow(color: Colors.black54, blurRadius: 4)]),
                      ),
                      const SizedBox(height: 16),
                    ],
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              _pauseTimer();
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (_) => ChangeNotifierProvider.value(
                                  value: community,
                                  child: CommentBottomSheet(postId: story.id, isStory: true),
                                ),
                              ).then((_) => _startTimer());
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.4),
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(color: Colors.white30),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 20),
                                  const SizedBox(width: 8),
                                  Text('Reply...', style: AppTypography.bodyMedium.copyWith(color: Colors.white70)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTap: () {
                            community.toggleStoryLike(story.id);
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                story.isLikedByMe ? Icons.favorite : Icons.favorite_border,
                                color: story.isLikedByMe ? AppColors.error : Colors.white,
                                size: 32,
                                shadows: const [Shadow(color: Colors.black54, blurRadius: 4)],
                              ),
                              if (story.likes > 0)
                                Text(
                                  '${story.likes}',
                                  style: AppTypography.labelSmall.copyWith(color: Colors.white, shadows: [const Shadow(color: Colors.black54, blurRadius: 4)]),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
