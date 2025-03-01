
import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/post.dart';
import '../../repositories/post_repository.dart';
import '../base/usecase.dart';

class GetPostsUseCase implements UseCase<List<Post>, NoParams> {
  final PostRepository repository;

  GetPostsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Post>>> call(NoParams params) {
    return repository.getPosts();
  }
}
