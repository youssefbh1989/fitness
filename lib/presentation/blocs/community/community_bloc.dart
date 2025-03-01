
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/base/usecase.dart';
import '../../../domain/usecases/post/get_posts_usecase.dart';
import '../../../domain/usecases/post/create_post_usecase.dart';
import '../../../domain/usecases/post/like_post_usecase.dart';
import '../../../domain/usecases/post/unlike_post_usecase.dart';
import '../../../domain/usecases/post/get_user_posts_usecase.dart';
import 'community_event.dart';
import 'community_state.dart';

class CommunityBloc extends Bloc<CommunityEvent, CommunityState> {
  final GetPostsUseCase getPostsUseCase;
  final CreatePostUseCase createPostUseCase;
  final LikePostUseCase likePostUseCase;
  final UnlikePostUseCase unlikePostUseCase;
  final GetUserPostsUseCase getUserPostsUseCase;

  CommunityBloc({
    required this.getPostsUseCase,
    required this.createPostUseCase,
    required this.likePostUseCase,
    required this.unlikePostUseCase,
    required this.getUserPostsUseCase,
  }) : super(CommunityInitial()) {
    on<LoadPostsEvent>(_onLoadPosts);
    on<CreatePostEvent>(_onCreatePost);
    on<LikePostEvent>(_onLikePost);
    on<UnlikePostEvent>(_onUnlikePost);
    on<LoadUserPostsEvent>(_onLoadUserPosts);
  }

  Future<void> _onLoadPosts(
    LoadPostsEvent event,
    Emitter<CommunityState> emit,
  ) async {
    emit(PostsLoading());
    final result = await getPostsUseCase(NoParams());
    result.fold(
      (failure) => emit(CommunityError(message: failure.message)),
      (posts) => emit(PostsLoaded(posts: posts)),
    );
  }

  Future<void> _onCreatePost(
    CreatePostEvent event,
    Emitter<CommunityState> emit,
  ) async {
    emit(PostsLoading());
    final result = await createPostUseCase(CreatePostParams(
      content: event.content,
      imageUrl: event.imageUrl,
    ));
    result.fold(
      (failure) => emit(CommunityError(message: failure.message)),
      (post) => emit(PostCreated(post: post)),
    );
  }

  Future<void> _onLikePost(
    LikePostEvent event,
    Emitter<CommunityState> emit,
  ) async {
    final result = await likePostUseCase(LikePostParams(postId: event.postId));
    result.fold(
      (failure) => emit(CommunityError(message: failure.message)),
      (_) => emit(PostLiked(postId: event.postId)),
    );
  }

  Future<void> _onUnlikePost(
    UnlikePostEvent event,
    Emitter<CommunityState> emit,
  ) async {
    final result = await unlikePostUseCase(UnlikePostParams(postId: event.postId));
    result.fold(
      (failure) => emit(CommunityError(message: failure.message)),
      (_) => emit(PostUnliked(postId: event.postId)),
    );
  }

  Future<void> _onLoadUserPosts(
    LoadUserPostsEvent event,
    Emitter<CommunityState> emit,
  ) async {
    emit(PostsLoading());
    final result = await getUserPostsUseCase(GetUserPostsParams(userId: event.userId));
    result.fold(
      (failure) => emit(CommunityError(message: failure.message)),
      (posts) => emit(UserPostsLoaded(posts: posts)),
    );
  }
}
