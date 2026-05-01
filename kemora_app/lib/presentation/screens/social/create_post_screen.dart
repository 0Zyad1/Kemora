import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../widgets/kemora_app_bar.dart';
import '../../../providers/community_provider.dart';
import '../../../data/local/community_data.dart';
import 'dart:math';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _captionController = TextEditingController();
  String? _selectedImageAsset;
  String _location = 'Pyramids of Giza';
  
  final List<String> _mockImages = [
    'assets/images/mocked/Cairo.png',
    'assets/images/mocked/Luxor.png',
    'assets/images/mocked/Aswan.png',
    'assets/images/mocked/Dahab.png',
    'assets/images/mocked/ThePyramids.png',
  ];

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  void _pickMockImage() {
    setState(() {
      _selectedImageAsset = _mockImages[Random().nextInt(_mockImages.length)];
    });
  }

  void _submitPost() {
    if (_captionController.text.trim().isEmpty && _selectedImageAsset == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add an image or caption.')),
      );
      return;
    }

    final post = CommunityPost(
      id: 'cp_${DateTime.now().millisecondsSinceEpoch}',
      authorName: 'Zaki',
      authorAvatar: 'assets/images/mocked/Cairo.png', // Add a mock avatar
      location: _location,
      content: _captionController.text.trim(),
      hashtags: '#EgyptTravel #KemoraAdventures',
      imageAsset: _selectedImageAsset,
      likes: 0,
      comments: [],
      createdAt: DateTime.now(),
    );
    context.read<CommunityProvider>().addPost(post);

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Post shared to Kemora Community!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KemoraAppBar(
        showBack: true,
        trailing: GestureDetector(
          onTap: _submitPost,
          child: Text('Share', style: AppTypography.titleMedium.copyWith(color: AppColors.primaryContainer)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Image Preview
            GestureDetector(
              onTap: _pickMockImage,
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (_selectedImageAsset != null)
                        Image.asset(_selectedImageAsset!, fit: BoxFit.cover)
                      else
                        const Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add_photo_alternate, size: 64, color: AppColors.outlineVariant),
                              SizedBox(height: 8),
                              Text('Tap to pick image', style: TextStyle(color: AppColors.outlineVariant)),
                            ],
                          ),
                        ),
                      if (_selectedImageAsset != null)
                        Positioned(
                          bottom: 16,
                          right: 16,
                          child: Row(
                            children: [
                              _buildOverlayBtn(Icons.crop),
                              const SizedBox(width: 8),
                              _buildOverlayBtn(Icons.tune),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Caption
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(color: AppColors.surfaceContainerHigh, shape: BoxShape.circle),
                  child: const Icon(Icons.person, color: AppColors.outlineVariant),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _captionController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Write a caption...',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      fillColor: Colors.transparent,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Hashtags
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildHashtag('#EgyptTravel'),
                _buildHashtag('#CairoNights'),
                _buildHashtag('#KemoraAdventures'),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Interaction List (No borders)
            _buildInteractionRow(Icons.location_on, 'Add Location', _location),
            _buildInteractionRow(Icons.person_add, 'Tag People', null),
            _buildInteractionRow(Icons.music_note, 'Add Music', null),
            
            const SizedBox(height: 32),
            Center(
              child: Text('Advanced Settings', style: AppTypography.labelLarge.copyWith(color: AppColors.onSurfaceVariant)),
            ),
            
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _submitPost,
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 56)),
              child: const Text('Post to Kemora Community'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverlayBtn(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }

  Widget _buildHashtag(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(tag, style: AppTypography.labelMedium.copyWith(color: AppColors.primaryContainer)),
    );
  }

  Widget _buildInteractionRow(IconData icon, String title, String? subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: AppColors.primaryContainer.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(icon, color: AppColors.primaryContainer, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.titleMedium),
                if (subtitle != null)
                  Text(subtitle, style: AppTypography.bodySmall.copyWith(color: AppColors.onSurfaceVariant)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.outlineVariant),
        ],
      ),
    );
  }
}
