import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../widgets/kimora_app_bar.dart';

class CreatePostScreen extends StatelessWidget {
  const CreatePostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KimoraAppBar(
        showBack: true,
        trailing: Text('Share', style: AppTypography.titleMedium.copyWith(color: AppColors.primaryContainer)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Image Preview
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Stack(
                  children: [
                    const Center(child: Icon(Icons.add_photo_alternate, size: 64, color: AppColors.outlineVariant)),
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
                    maxLines: 4,
                    decoration: InputDecoration(
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
                _buildHashtag('#KimoraAdventures'),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Interaction List (No borders)
            _buildInteractionRow(Icons.location_on, 'Add Location', 'Pyramids of Giza'),
            _buildInteractionRow(Icons.person_add, 'Tag People', null),
            _buildInteractionRow(Icons.music_note, 'Add Music', null),
            
            const SizedBox(height: 32),
            Center(
              child: Text('Advanced Settings', style: AppTypography.labelLarge.copyWith(color: AppColors.onSurfaceVariant)),
            ),
            
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 56)),
              child: const Text('Post to Kimora Community'),
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
