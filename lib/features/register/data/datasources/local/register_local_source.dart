import 'dart:convert';

import 'package:analytic_invest/core/di/injection_container.dart';
import 'package:analytic_invest/features/register/data/models/user_model.dart';
import 'package:analytic_invest/features/register/domain/entities/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class RegisterLocalSource {
  Future<RegisterModel> register();
}

class RegisterLocalSourceImpl extends RegisterLocalSource {
  final SharedPreferences prefs;

  // AnalyticsLocalDataSourceImpl({required this.sharedPreferences});

  RegisterLocalSourceImpl({required this.prefs});

  @override
  Future<RegisterModel> register() async {
    final jsonString = prefs.getString('register_data');
    if (jsonString != null) {
      final Map<String, dynamic> data = json.decode(jsonString);
      return RegisterModel.formJson(data);
    } else {
      throw Exception('Data register not found');
    }
  }
}
