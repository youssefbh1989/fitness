
import 'package:equatable/equatable.dart';

class Post extends Equatable {
  final String id;
  final String userId;
  final String userName;
  final String userAvatar;
  final String content;
  final String? imageUrl;
  final DateTime createdAt;
  final int likes;
  final int comments;
  final bool isLiked;

  const Post({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.content,
    this.imageUrl,
    required this.createdAt,
    required this.likes,
    required this.comments,
    this.isLiked = false,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        userName,
        userAvatar,
        content,
        imageUrl,
        createdAt,
        likes,
        comments,
        isLiked,
      ];
}
