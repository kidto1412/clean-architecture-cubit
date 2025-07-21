import 'package:analytic_invest/core/errors/failures.dart';
import 'package:analytic_invest/features/register/domain/entities/user.dart';
import 'package:analytic_invest/features/register/domain/repositories/register_repository.dart';
import 'package:dartz/dartz.dart';

class Register {
  final RegisterRepository registerRepository;

  const Register(this.registerRepository);

  Future<Either<Failure, User>> execute(User data) async {
    return await registerRepository.register(data);
  }
}
