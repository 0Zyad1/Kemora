import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../viewmodels/post_view_model.dart';

/// Bottom sheet displaying comments for a post with inline add comment.
class CommentBottomSheet extends StatefulWidget {
  final String postId;
  const CommentBottomSheet({super.key, required this.postId});

  @override
  State<CommentBottomSheet> createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

      context.read<PostViewModel>().addComment(widget.postId, text);
    _controller.clear();
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    final postVm = context.watch<PostViewModel>();
    final comments = postVm.getComments(widget.postId);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          const SizedBox(height: 12),
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
              color: AppColors.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Comments (${comments.length})', style: AppTypography.titleLarge),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
              ],
            ),
          ),
          const Divider(),
          // Comments list
          Flexible(
            child: comments.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(32),
                    child: Center(
                      child: Text('No comments yet. Be the first!',
                          style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurfaceVariant)),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    shrinkWrap: true,
                    itemCount: comments.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final c = comments[index];
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: AppColors.surfaceContainerHigh,
                            child: Text(c.authorName.isNotEmpty ? c.authorName[0] : 'U',
                                style: const TextStyle(
                                    color: AppColors.onSurface, fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(c.authorName,
                                        style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold)),
                                    const SizedBox(width: 8),
                                    Text(_timeAgo(c.createdAt),
                                        style: AppTypography.labelSmall.copyWith(color: AppColors.outline)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(c.content, style: AppTypography.bodyMedium),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),
          // Input
          Container(
            padding: EdgeInsets.only(
              left: 24, right: 12, top: 12,
              bottom: MediaQuery.of(context).viewInsets.bottom + 12,
            ),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              border: Border(top: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.3))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: AppColors.surfaceContainer,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _submit,
                  icon: const Icon(Icons.send_rounded, color: AppColors.primaryContainer),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
