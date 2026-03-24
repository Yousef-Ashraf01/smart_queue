import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_queue/core/di/service_locator.dart';
import 'package:smart_queue/core/routing/app_router.dart';
import 'package:smart_queue/features/auth/presentaion/cubit/auth_cubit.dart';
import 'package:smart_queue/features/personal_info/presentation/cubit/personal_info_cubit.dart';

late final AuthCubit authCubit;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupServiceLocator();

  authCubit = sl<AuthCubit>();
  final personalInfoCubit = sl<PersonalInfoCubit>();

  await authCubit.checkAuthStatus();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider.value(value: authCubit),
        BlocProvider.value(value: personalInfoCubit..getProfile()),
      ],
      child: const SmartQueueApp(),
    ),
  );
}

class SmartQueueApp extends StatelessWidget {
  const SmartQueueApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    return MaterialApp.router(
      routerConfig: AppRouter.createRouter(authCubit),
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
    );
  }
}
