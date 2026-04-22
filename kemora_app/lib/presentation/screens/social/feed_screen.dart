import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../widgets/filter_chip_row.dart';
import 'create_post_screen.dart';
import '../../widgets/fade_slide_in.dart';
import '../../widgets/tap_scale.dart';
import '../../../core/router/page_transitions.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  int _selectedFilter = 0;
  final List<String> _filters = ['All', 'English', 'Arabic', 'Current Place'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLow,
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: SizedBox(height: 100)),

          // Stories
          SliverToBoxAdapter(
            child: FadeSlideIn(
              delayMs: 0,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    _buildStoryItem(isAdd: true, name: 'Your Story'),
                    const SizedBox(width: 16),
                    _buildStoryItem(name: 'Layla', location: 'Luxor Vibe'),
                    const SizedBox(width: 16),
                    _buildStoryItem(name: 'Omar', location: 'Cairo Eats'),
                    const SizedBox(width: 16),
                    _buildStoryItem(name: 'Sara', location: 'Dahab Blue'),
                  ],
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // Filters
          SliverToBoxAdapter(
            child: FadeSlideIn(
              delayMs: 100,
              child: FilterChipRow(
                chips: _filters,
                selectedIndex: _selectedFilter,
                onSelected: (i) => setState(() => _selectedFilter = i),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // Feed posts
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return FadeSlideIn(
                  delayMs: 200 + (index * 100),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24).copyWith(bottom: 40),
                    child: TapScale(child: _buildPostCard()),
                  ),
                );
              },
              childCount: 3,
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(FadePageRoute(child: const CreatePostScreen()));
          },
          backgroundColor: AppColors.primaryContainer,
          elevation: 8,
          child: const Icon(Icons.add_a_photo, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildStoryItem({bool isAdd = false, required String name, String? location}) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: isAdd
                ? const LinearGradient(colors: [AppColors.primary, AppColors.secondaryContainer])
                : const LinearGradient(colors: [AppColors.primary, AppColors.secondaryContainer]),
          ),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceContainerLowest,
              border: Border.all(color: AppColors.surfaceContainerLowest, width: 2),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipOval(
                  child: Container(
                    color: AppColors.surfaceContainerHigh,
                    child: const Icon(Icons.person, color: AppColors.outlineVariant, size: 40),
                  ),
                ),
                if (location != null)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        location.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: AppTypography.labelSmall.copyWith(color: Colors.white, fontSize: 8),
                      ),
                    ),
                  ),
                if (isAdd)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(Icons.add, size: 12, color: Colors.white),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(name, style: AppTypography.labelSmall.copyWith(color: AppColors.onSurfaceVariant)),
      ],
    );
  }

  Widget _buildPostCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.surfaceContainerHigh,
                  ),
                  child: const Icon(Icons.person, color: AppColors.outlineVariant),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Amira Zaki', style: AppTypography.titleMedium),
                      Text(
                        'Pyramids of Giza • 2h ago',
                        style: AppTypography.labelSmall.copyWith(color: AppColors.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.more_vert, color: AppColors.onSurfaceVariant),
              ],
            ),
          ),

          // Post image
          AspectRatio(
            aspectRatio: 4 / 5,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  color: AppColors.surfaceContainer,
                  child: const Center(child: Icon(Icons.image, size: 64, color: AppColors.outlineVariant)),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                    ),
                    child: Text('EXPERT TIP', style: AppTypography.labelSmall.copyWith(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),

          // Post content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.favorite, color: AppColors.primaryContainer),
                    const SizedBox(width: 8),
                    Text('1.2k', style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 24),
                    const Icon(Icons.chat_bubble_outline, color: AppColors.onSurfaceVariant),
                    const SizedBox(width: 8),
                    Text('84', style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold)),
                    const Spacer(),
                    const Icon(Icons.share, color: AppColors.onSurfaceVariant),
                  ],
                ),
                const SizedBox(height: 16),
                RichText(
                  text: TextSpan(
                    style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurface, height: 1.5),
                    children: [
                      TextSpan(
                        text: 'Amira Zaki ',
                        style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(
                        text: 'Finally caught the sunrise at the Great Sphinx. Pro tip: Arrive at 7 AM to beat the crowd and get that perfect editorial glow. ✨ ',
                      ),
                      TextSpan(
                        text: '#EgyptTravel #CairoNights',
                        style: TextStyle(color: AppColors.primaryContainer, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
