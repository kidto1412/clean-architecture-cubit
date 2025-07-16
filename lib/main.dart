import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/di/injection_container.dart' as di;
import 'core/theme/app_theme.dart';
import 'features/main_page/presentation/pages/main_page.dart';
import 'features/analytics/presentation/cubit/analytics_cubit.dart';
import 'features/home/presentation/cubit/home_cubit.dart';
import 'features/profile/presentation/cubit/profile_cubit.dart';
import 'features/main_page/presentation/cubit/main_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<MainCubit>(
              create: (context) => di.sl<MainCubit>(),
            ),
            BlocProvider<HomeCubit>(
              create: (context) => di.sl<HomeCubit>()..loadHomeData(),
            ),
            BlocProvider<AnalyticsCubit>(
              create: (context) => di.sl<AnalyticsCubit>(),
            ),
            BlocProvider<ProfileCubit>(
              create: (context) => di.sl<ProfileCubit>(),
            ),
          ],
          child: MaterialApp(
            title: 'Analytic Invest',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            home: const MainPage(),
          ),
        );
      },
    );
  }
}
