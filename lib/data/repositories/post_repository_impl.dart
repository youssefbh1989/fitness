
import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/post.dart';
import '../../domain/repositories/post_repository.dart';

class PostRepositoryImpl implements PostRepository {
  @override
  Future<Either<Failure, List<Post>>> getPosts() async {
    try {
      // This would normally connect to an API or local database
      // Using mock data for now
      await Future.delayed(const Duration(seconds: 1));
      return Right(_getMockPosts());
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to load posts'));
    }
  }

  @override
  Future<Either<Failure, Post>> createPost(String content, String? imageUrl) async {
    try {
      // This would normally connect to an API
      await Future.delayed(const Duration(seconds: 1));
      return Right(Post(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: 'user1',
        userName: 'John Doe',
        userAvatar: 'https://randomuser.me/api/portraits/men/1.jpg',
        content: content,
        imageUrl: imageUrl,
        createdAt: DateTime.now(),
        likes: 0,
        comments: 0,
      ));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to create post'));
    }
  }

  @override
  Future<Either<Failure, void>> likePost(String postId) async {
    try {
      // This would normally connect to an API
      await Future.delayed(const Duration(milliseconds: 500));
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to like post'));
    }
  }

  @override
  Future<Either<Failure, void>> unlikePost(String postId) async {
    try {
      // This would normally connect to an API
      await Future.delayed(const Duration(milliseconds: 500));
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to unlike post'));
    }
  }

  @override
  Future<Either<Failure, List<Post>>> getUserPosts(String userId) async {
    try {
      // This would normally connect to an API or local database
      await Future.delayed(const Duration(seconds: 1));
      return Right(_getMockPosts().where((post) => post.userId == userId).toList());
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to load user posts'));
    }
  }

  List<Post> _getMockPosts() {
    return [
      Post(
        id: '1',
        userId: 'user1',
        userName: 'John Doe',
        userAvatar: 'https://randomuser.me/api/portraits/men/1.jpg',
        content: 'Just completed a 5K run in 25 minutes! Personal best! 🏃‍♂️💪',
        imageUrl: 'https://images.unsplash.com/photo-1571008887538-b36bb32f4571',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        likes: 24,
        comments: 5,
      ),
      Post(
        id: '2',
        userId: 'user2',
        userName: 'Jane Smith',
        userAvatar: 'https://randomuser.me/api/portraits/women/2.jpg',
        content: 'Today\'s workout was brutal but worth it! #fitness #dedication',
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        likes: 18,
        comments: 3,
      ),
      Post(
        id: '3',
        userId: 'user3',
        userName: 'Sam Wilson',
        userAvatar: 'https://randomuser.me/api/portraits/men/3.jpg',
        content: 'New personal record on bench press: 100kg x 3 reps! 💪',
        imageUrl: 'https://images.unsplash.com/photo-1583454110551-21f2fa2afe61',
        createdAt: DateTime.now().subtract(const Duration(hours: 7)),
        likes: 32,
        comments: 8,
      ),
      Post(
        id: '4',
        userId: 'user4',
        userName: 'Emma Johnson',
        userAvatar: 'https://randomuser.me/api/portraits/women/4.jpg',
        content: 'My 30-day yoga challenge is complete! Feeling stronger and more flexible than ever!',
        imageUrl: 'https://images.unsplash.com/photo-1599447292180-45fd84092ef4',
        createdAt: DateTime.now().subtract(const Duration(hours: 12)),
        likes: 45,
        comments: 11,
      ),
      Post(
        id: '5',
        userId: 'user1',
        userName: 'John Doe',
        userAvatar: 'https://randomuser.me/api/portraits/men/1.jpg',
        content: 'Trying out this new protein shake recipe. Tastes amazing!',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        likes: 15,
        comments: 4,
      ),
    ];
  }
}
