
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../core/utils/size_config.dart';
import '../../domain/entities/post.dart';

class PostItem extends StatelessWidget {
  final Post post;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onProfile;

  const PostItem({
    Key? key,
    required this.post,
    required this.onLike,
    required this.onComment,
    required this.onProfile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: SizeConfig.defaultPadding),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User info
          ListTile(
            leading: GestureDetector(
              onTap: onProfile,
              child: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(post.userAvatar),
              ),
            ),
            title: Text(post.userName),
            subtitle: Text(
              _formatDate(post.createdAt),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                // Show options menu
              },
            ),
          ),
          
          // Post content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.defaultPadding),
            child: Text(
              post.content,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          
          // Post image if available
          if (post.imageUrl != null)
            Padding(
              padding: EdgeInsets.only(top: SizeConfig.smallPadding),
              child: CachedNetworkImage(
                imageUrl: post.imageUrl!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          
          // Post stats and actions
          Padding(
            padding: EdgeInsets.all(SizeConfig.defaultPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${post.likes} likes • ${post.comments} comments',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          
          // Action buttons
          Divider(height: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(
                context,
                icon: post.isLiked ? Icons.favorite : Icons.favorite_border,
                label: 'Like',
                color: post.isLiked ? Colors.red : null,
                onPressed: onLike,
              ),
              _buildActionButton(
                context,
                icon: Icons.comment_outlined,
                label: 'Comment',
                onPressed: onComment,
              ),
              _buildActionButton(
                context,
                icon: Icons.share_outlined,
                label: 'Share',
                onPressed: () {
                  // Share post
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    Color? color,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(icon, color: color),
            SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: color ?? Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d').format(date);
    }
  }
}
