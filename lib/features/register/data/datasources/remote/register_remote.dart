import 'package:analytic_invest/core/constants/app_constants.dart';
import 'package:analytic_invest/core/di/injection_container.dart';
import 'package:analytic_invest/features/register/data/models/user_model.dart';
import 'package:analytic_invest/features/register/domain/entities/user.dart';
import 'package:dio/dio.dart';

abstract class RegisterRemote {
  Future<RegisterModel> register(User data);
}

class RegisterService extends RegisterRemote {
  final Dio dio;
  RegisterService(this.dio);

  @override
  Future<RegisterModel> register(User request) async {
    print(RegisterModel.fromEntity(request).toJson());
    var response = await dio.post(AppConstants.baseUrl + "/user/register",
        data: RegisterModel.fromEntity(request).toJson());
    final data = response.data['data']; // ambil token dari 'data'
    return RegisterModel.formJson(data);
  }
}
