import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
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

  // Initialize Notification Service
  await NotificationService.init();

  setupServiceLocator();

  authCubit = sl<AuthCubit>();
  final personalInfoCubit = sl<PersonalInfoCubit>();

  await authCubit.checkAuthStatus();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: authCubit),
          BlocProvider.value(value: personalInfoCubit..getProfile()),
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
    // GoTransition.defaultCurve = Curves.linearToEaseOut;
    // // GoTransition.defaultCurve = Curves.fastOutSlowIn;
    // GoTransition.defaultDuration = const Duration(milliseconds: 350);

    final authCubit = context.read<AuthCubit>();
    return MaterialApp.router(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      // theme: ThemeData(
      //   pageTransitionsTheme: const PageTransitionsTheme(
      //     builders: {
      //       TargetPlatform.android: GoTransitions.fadeUpwards,
      //       TargetPlatform.iOS: GoTransitions.cupertino,
      //       TargetPlatform.macOS: GoTransitions.cupertino,
      //     },
      //   ),
      // ),
      routerConfig: AppRouter.createRouter(authCubit),
      debugShowCheckedModeBanner: false,
      //theme: ThemeData.light(),
    );
  }
}
