
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../core/error/failures.dart';
import '../../entities/post.dart';
import '../../repositories/post_repository.dart';
import '../base/usecase.dart';

class GetUserPostsUseCase implements UseCase<List<Post>, GetUserPostsParams> {
  final PostRepository repository;

  GetUserPostsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Post>>> call(GetUserPostsParams params) {
    return repository.getUserPosts(params.userId);
  }
}

class GetUserPostsParams extends Equatable {
  final String userId;

  const GetUserPostsParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}
