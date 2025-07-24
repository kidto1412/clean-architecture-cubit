import 'package:analytic_invest/features/register/data/models/user_model.dart';
import 'package:analytic_invest/features/register/domain/entities/user.dart';
import 'package:analytic_invest/features/register/domain/usecase/register_usecase.dart';
import 'package:analytic_invest/features/register/presentation/cubit/register_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final Register registerUseCase;
  RegisterCubit({required this.registerUseCase}) : super(RegisterInitial());

  Future<void> register(User data) async {
    emit(RegisterLoading());
    final response = await registerUseCase.execute(data);
    response.fold(
        (failure) => emit(RegisterError(failure.message ?? "Register gagal")),
        (data) => emit(RegisterLoaded(data)));
  }
}
