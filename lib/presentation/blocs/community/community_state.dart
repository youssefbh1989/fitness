
import 'package:equatable/equatable.dart';
import '../../../domain/entities/post.dart';

abstract class CommunityState extends Equatable {
  const CommunityState();

  @override
  List<Object?> get props => [];
}

class CommunityInitial extends CommunityState {}

class PostsLoading extends CommunityState {}

class PostsLoaded extends CommunityState {
  final List<Post> posts;

  const PostsLoaded({required this.posts});

  @override
  List<Object?> get props => [posts];
}

class UserPostsLoaded extends CommunityState {
  final List<Post> posts;

  const UserPostsLoaded({required this.posts});

  @override
  List<Object?> get props => [posts];
}

class PostCreated extends CommunityState {
  final Post post;

  const PostCreated({required this.post});

  @override
  List<Object?> get props => [post];
}

class PostLiked extends CommunityState {
  final String postId;

  const PostLiked({required this.postId});

  @override
  List<Object?> get props => [postId];
}

class PostUnliked extends CommunityState {
  final String postId;

  const PostUnliked({required this.postId});

  @override
  List<Object?> get props => [postId];
}

class CommunityError extends CommunityState {
  final String message;

  const CommunityError({required this.message});

  @override
  List<Object?> get props => [message];
}
