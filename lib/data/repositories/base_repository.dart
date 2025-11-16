
import 'package:dartz/dartz.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';

abstract class BaseRepository {
  Future<Either<Failure, T>> executeWithErrorHandling<T>(
    Future<T> Function() function,
  ) async {
    try {
      final result = await function();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
