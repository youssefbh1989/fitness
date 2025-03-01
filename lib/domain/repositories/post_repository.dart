
import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/post.dart';

abstract class PostRepository {
  Future<Either<Failure, List<Post>>> getPosts();
  Future<Either<Failure, Post>> createPost(String content, String? imageUrl);
  Future<Either<Failure, void>> likePost(String postId);
  Future<Either<Failure, void>> unlikePost(String postId);
  Future<Either<Failure, List<Post>>> getUserPosts(String userId);
}
