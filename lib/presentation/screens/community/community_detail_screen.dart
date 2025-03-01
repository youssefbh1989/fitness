
import 'package:flutter/material.dart';
import '../../../domain/entities/post.dart';

class CommunityDetailScreen extends StatefulWidget {
  final Post post;

  const CommunityDetailScreen({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  State<CommunityDetailScreen> createState() => _CommunityDetailScreenState();
}

class _CommunityDetailScreenState extends State<CommunityDetailScreen> {
  final TextEditingController _commentController = TextEditingController();
  final List<Comment> _comments = [];
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    // Load mock comments
    _comments.addAll(_getMockComments());
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Details'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPostHeader(),
                  const SizedBox(height: 16),
                  Text(
                    widget.post.content,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  if (widget.post.imageUrl != null) ...[
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        widget.post.imageUrl!,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: double.infinity,
                            height: 200,
                            color: Colors.grey[300],
                            child: const Icon(Icons.image, size: 40),
                          );
                        },
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  _buildInteractionBar(),
                  const Divider(),
                  const SizedBox(height: 16),
                  Text(
                    'Comments (${_comments.length})',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  ..._buildComments(),
                ],
              ),
            ),
          ),
          _buildCommentInput(),
        ],
      ),
    );
  }

  Widget _buildPostHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundImage: NetworkImage(widget.post.userAvatar),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.post.userName,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                '${_formatDate(widget.post.createdAt)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            // Show options menu
          },
        ),
      ],
    );
  }

  Widget _buildInteractionBar() {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            _isLiked ? Icons.favorite : Icons.favorite_border,
            color: _isLiked ? Colors.red : null,
          ),
          onPressed: () {
            setState(() {
              _isLiked = !_isLiked;
            });
          },
        ),
        Text(
          '${widget.post.likes}',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(width: 16),
        const Icon(Icons.chat_bubble_outline),
        const SizedBox(width: 8),
        Text(
          '${widget.post.comments}',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const Spacer(),
        const Icon(Icons.share_outlined),
      ],
    );
  }

  List<Widget> _buildComments() {
    return _comments.map((comment) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(comment.userAvatar),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        comment.userName,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatDate(comment.createdAt),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    comment.content,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.favorite_border, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${comment.likes}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.reply, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        'Reply',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildCommentInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: 'Write a comment...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
                maxLines: null,
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 20,
              backgroundColor: Theme.of(context).primaryColor,
              child: IconButton(
                icon: const Icon(Icons.send, size: 18, color: Colors.white),
                onPressed: () {
                  if (_commentController.text.isNotEmpty) {
                    setState(() {
                      _comments.insert(
                        0,
                        Comment(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          userId: 'current_user',
                          userName: 'You',
                          userAvatar:
                              'https://randomuser.me/api/portraits/men/1.jpg',
                          content: _commentController.text,
                          createdAt: DateTime.now(),
                          likes: 0,
                        ),
                      );
                      _commentController.clear();
                    });
                  }
                },
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

    if (difference.inDays > 7) {
      return '${date.day}/${date.month}/${date.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  List<Comment> _getMockComments() {
    return [
      Comment(
        id: '1',
        userId: 'user2',
        userName: 'Jane Smith',
        userAvatar: 'https://randomuser.me/api/portraits/women/2.jpg',
        content: 'Great job! Keep up the good work! 💪',
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        likes: 5,
      ),
      Comment(
        id: '2',
        userId: 'user3',
        userName: 'Sam Wilson',
        userAvatar: 'https://randomuser.me/api/portraits/men/3.jpg',
        content: 'What\'s your training split like?',
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        likes: 2,
      ),
      Comment(
        id: '3',
        userId: 'user4',
        userName: 'Emma Johnson',
        userAvatar: 'https://randomuser.me/api/portraits/women/4.jpg',
        content: 'This is inspiring! I need to get back to my training routine.',
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        likes: 8,
      ),
    ];
  }
}

class Comment {
  final String id;
  final String userId;
  final String userName;
  final String userAvatar;
  final String content;
  final DateTime createdAt;
  final int likes;

  Comment({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.content,
    required this.createdAt,
    required this.likes,
  });
}
