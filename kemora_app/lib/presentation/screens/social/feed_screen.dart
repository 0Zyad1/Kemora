import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../widgets/filter_chip_row.dart';
import '../../../providers/community_provider.dart';
import 'create_post_screen.dart';
import 'widgets/feed_post_card.dart';
import 'widgets/story_viewer_screen.dart';
import 'widgets/comment_bottom_sheet.dart';
import '../../widgets/fade_slide_in.dart';
import '../../../core/router/page_transitions.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  int _selectedFilter = 0;
  final List<String> _filters = ['All', 'English', 'Arabic', 'Current Place'];

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    final community = context.watch<CommunityProvider>();
    final stories = community.stories;
    final posts = community.posts;

    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLow,
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: SizedBox(height: 100)),

          // Stories — from CommunityProvider
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
                    ...stories.map((story) => Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: _buildStoryItem(
                            name: story.userName,
                            imageAsset: story.imageAsset,
                            location: story.location,
                          ),
                        )),
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

          // Feed posts — from CommunityProvider
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final post = posts[index];
                return FadeSlideIn(
                  delayMs: 200 + (index * 100),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24).copyWith(bottom: 40),
                    child: FeedPostCard(
                      postId: post.id,
                      authorName: post.authorName,
                      location: post.location,
                      timeAgo: _timeAgo(post.createdAt),
                      content: post.content,
                      hashtags: post.hashtags,
                      imageUrl: post.imageAsset ?? 'assets/images/mocked/CommunityPost.jpg',
                      initialLikes: post.likes,
                      isLiked: post.isLikedByMe,
                      initialComments: post.comments.length,
                      onLikeTap: () => community.toggleLike(post.id),
                      onCommentTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => ChangeNotifierProvider.value(
                            value: community,
                            child: CommentBottomSheet(postId: post.id),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
              childCount: posts.length,
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

  Widget _buildStoryItem({
    bool isAdd = false,
    required String name,
    String? imageAsset,
    String? location,
  }) {
    final fallbackImage = 'assets/images/mocked/CommunityStory.jpg';
    final img = imageAsset ?? fallbackImage;

    return GestureDetector(
      onTap: () {
        if (!isAdd) {
          Navigator.push(context, FadePageRoute(child: StoryViewerScreen(userName: name, imageUrl: img)));
        } else {
          Navigator.push(context, FadePageRoute(child: const CreatePostScreen()));
        }
      },
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: [AppColors.primary, AppColors.secondaryContainer]),
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
                    child: Image.asset(img, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                              color: AppColors.surfaceContainerHigh,
                              child: const Icon(Icons.person, color: AppColors.outlineVariant, size: 40),
                            )),
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
      ),
    );
  }
}
