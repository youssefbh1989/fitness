
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../core/error/failures.dart';
import '../../repositories/post_repository.dart';
import '../base/usecase.dart';

class LikePostUseCase implements UseCase<void, LikePostParams> {
  final PostRepository repository;

  LikePostUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(LikePostParams params) {
    return repository.likePost(params.postId);
  }
}

class LikePostParams extends Equatable {
  final String postId;

  const LikePostParams({required this.postId});

  @override
  List<Object?> get props => [postId];
}
