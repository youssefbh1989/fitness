
import 'package:equatable/equatable.dart';

abstract class CommunityEvent extends Equatable {
  const CommunityEvent();

  @override
  List<Object?> get props => [];
}

class LoadPostsEvent extends CommunityEvent {}

class CreatePostEvent extends CommunityEvent {
  final String content;
  final String? imageUrl;

  const CreatePostEvent({
    required this.content,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [content, imageUrl];
}

class LikePostEvent extends CommunityEvent {
  final String postId;

  const LikePostEvent({required this.postId});

  @override
  List<Object?> get props => [postId];
}

class UnlikePostEvent extends CommunityEvent {
  final String postId;

  const UnlikePostEvent({required this.postId});

  @override
  List<Object?> get props => [postId];
}

class LoadUserPostsEvent extends CommunityEvent {
  final String userId;

  const LoadUserPostsEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}
