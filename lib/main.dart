import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:smart_queue/core/di/service_locator.dart';
import 'package:smart_queue/core/routing/app_router.dart';
import 'package:smart_queue/core/services/notification_service.dart';
import 'package:smart_queue/features/auth/presentaion/cubit/auth_cubit.dart';
import 'package:smart_queue/features/branch_booking/presentation/cubit/active_booking_cubit.dart';
import 'package:smart_queue/features/personal_info/presentation/cubit/personal_info_cubit.dart';

late final AuthCubit authCubit;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  Stripe.publishableKey =
      'pk_test_51Q0BxtASiJSav9RQ0WPOOSAXW14kvFUHxgYOHErs9qlScsq4NA6ArUFXMnzkFGN7Ualq1UaF5B5IgAwPtHGaHLKu00DjOHTNrT';

  await NotificationService.init();

  setupServiceLocator();

  authCubit = sl<AuthCubit>();
  final personalInfoCubit = sl<PersonalInfoCubit>();

  await authCubit.checkAuthStatus();

  if (authCubit.state is LoginSuccess) {
    personalInfoCubit.getProfile();
  }

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: authCubit),
          BlocProvider.value(value: personalInfoCubit),
          BlocProvider(create: (_) => sl<ActiveBookingCubit>()),
        ],
        child: const SmartQueueApp(),
      ),
    ),
  );
}

class SmartQueueApp extends StatelessWidget {
  const SmartQueueApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    return MaterialApp.router(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      routerConfig: AppRouter.createRouter(authCubit),
      debugShowCheckedModeBanner: false,
    );
  }
}
