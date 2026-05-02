import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../widgets/filter_chip_row.dart';
import '../../viewmodels/post_view_model.dart';
import 'create_post_screen.dart';
import 'widgets/feed_post_card.dart';
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PostViewModel>().loadFeed();
    });
  }

  @override
  Widget build(BuildContext context) {
    final postVm = context.watch<PostViewModel>();
    final posts = postVm.posts;

    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLow,
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: SizedBox(height: 100)),

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

          // Feed posts — from PostViewModel
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
                      location: post.locationName ?? 'Unknown Location',
                      timeAgo: _timeAgo(post.createdAt),
                      content: post.content,
                      hashtags: '#KemoraAdventures',
                      imageUrl: post.imageUrl ?? 'assets/images/mocked/CommunityPost.jpg',
                      initialLikes: post.likesCount,
                      isLiked: post.isLikedByMe,
                      initialComments: post.commentsCount,
                      onLikeTap: () => postVm.toggleLike(post.id),
                      onCommentTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => ChangeNotifierProvider.value(
                            value: postVm,
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

}
