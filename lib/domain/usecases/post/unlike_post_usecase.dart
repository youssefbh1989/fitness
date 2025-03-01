
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../core/error/failures.dart';
import '../../repositories/post_repository.dart';
import '../base/usecase.dart';

class UnlikePostUseCase implements UseCase<void, UnlikePostParams> {
  final PostRepository repository;

  UnlikePostUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(UnlikePostParams params) {
    return repository.unlikePost(params.postId);
  }
}

class UnlikePostParams extends Equatable {
  final String postId;

  const UnlikePostParams({required this.postId});

  @override
  List<Object?> get props => [postId];
}
