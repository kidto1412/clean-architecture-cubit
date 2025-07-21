import 'package:analytic_invest/core/errors/failures.dart';
import 'package:analytic_invest/features/register/domain/entities/user.dart';
import 'package:dartz/dartz.dart';

abstract class RegisterRepository {
  // login
  Future<Either<Failure, User>> register(User data);
}
