
import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {}

class Params {
  final String? id;
  final String? category;
  final String? goal;

  Params({this.id, this.category, this.goal});
}
