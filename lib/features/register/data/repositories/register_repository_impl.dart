import 'package:analytic_invest/core/errors/failures.dart';
import 'package:analytic_invest/core/network/network_info.dart';
import 'package:analytic_invest/features/register/data/datasources/local/register_local_source.dart';
import 'package:analytic_invest/features/register/data/datasources/remote/register_remote.dart';
import 'package:analytic_invest/features/register/data/models/user_model.dart';
import 'package:analytic_invest/features/register/domain/entities/user.dart';
import 'package:analytic_invest/features/register/domain/repositories/register_repository.dart';
import 'package:analytic_invest/features/register/domain/usecase/register_usecase.dart';
import 'package:dartz/dartz.dart';

class RegisterRepositoryImpl extends RegisterRepository {
  final RegisterLocalSource localDataSource;
  final RegisterRemote remoteDataSource;
  final NetworkInfo networkInfo;

  RegisterRepositoryImpl(
      {required this.localDataSource,
      required this.remoteDataSource,
      required this.networkInfo});

  @override
  Future<Either<Failure, User>> register(User data) async {
    // TODO: implement login

    try {
      final connected = await networkInfo.isConnected;
      if (!connected) return Left(NetworkFailure("Tidak ada koneksi"));

      RegisterModel result = await remoteDataSource.register(data);
      // print('result' + result.toString());

      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }

    // throw UnimplementedError();
  }
}
