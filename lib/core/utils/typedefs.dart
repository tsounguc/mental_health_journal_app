import 'package:dartz/dartz.dart';
import 'package:mental_health_journal_app/core/errors/failures.dart';

typedef ResultFuture<T> = Future<Either<Failure, T>>;
typedef ResultVoid = Future<void>;