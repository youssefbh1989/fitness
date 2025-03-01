
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../core/error/failures.dart';
import '../../entities/post.dart';
import '../../repositories/post_repository.dart';
import '../base/usecase.dart';

class CreatePostUseCase implements UseCase<Post, CreatePostParams> {
  final PostRepository repository;

  CreatePostUseCase(this.repository);

  @override
  Future<Either<Failure, Post>> call(CreatePostParams params) {
    return repository.createPost(params.content, params.imageUrl);
  }
}

class CreatePostParams extends Equatable {
  final String content;
  final String? imageUrl;

  const CreatePostParams({
    required this.content,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [content, imageUrl];
}
