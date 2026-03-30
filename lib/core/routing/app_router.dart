import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_queue/core/routing/app_routes.dart';
import 'package:smart_queue/core/routing/auth_notifier.dart';
import 'package:smart_queue/features/ai/ai_screen.dart';
import 'package:smart_queue/features/auth/presentaion/cubit/auth_cubit.dart';
import 'package:smart_queue/features/auth/presentaion/view/login_page.dart';
import 'package:smart_queue/features/auth/presentaion/view/register_page.dart';
import 'package:smart_queue/features/branch_booking/data/repositories/booking_repository.dart';
import 'package:smart_queue/features/branch_booking/presentation/cubit/booking_cubit.dart';
import 'package:smart_queue/features/branch_booking/presentation/cubit/services_cubit.dart';
import 'package:smart_queue/features/branch_booking/presentation/view/branch_booking_screen.dart';
import 'package:smart_queue/features/forget_password/presentation/view/create_new_password_screen.dart';
import 'package:smart_queue/features/forget_password/presentation/view/forget_password_screen.dart';
import 'package:smart_queue/features/main/main_screen.dart';
import 'package:smart_queue/features/map/data/models/government_branch.dart';
import 'package:smart_queue/features/map/presentation/view/map_screen.dart';
import 'package:smart_queue/features/operations_history/presentation/cubit/operations_cubit.dart';
import 'package:smart_queue/features/personal_info/presentation/view/personal_info_screen.dart';
import 'package:smart_queue/features/profile_settings/presentation/view/profile_settings_screen.dart';
import 'package:smart_queue/features/scan_id_card/presentation/view/scan_id_card_screen.dart';
import 'package:smart_queue/features/timer/presentation/veiw/timer_screen.dart';
import 'package:smart_queue/features/verification/presentation/view/verification_screen.dart';
import 'package:smart_queue/features/verification_code/presentation/view/verification_code_screen.dart';

import '../di/service_locator.dart';

class AppRouter {
  static GoRouter createRouter(AuthCubit authCubit) {
    final authNotifier = AuthNotifier(authCubit);

    return GoRouter(
      refreshListenable: authNotifier,
      initialLocation: AppRoutes.login,

      redirect: (context, state) {
        final isLoggedIn = authNotifier.isLoggedIn;
        final isGoingToLogin =
            state.matchedLocation == AppRoutes.login ||
            state.matchedLocation == AppRoutes.register ||
            state.matchedLocation == AppRoutes.createNewPassword ||
            state.matchedLocation == AppRoutes.verificationCode ||
            state.matchedLocation == AppRoutes.forgetPassword;

        if (!isLoggedIn && !isGoingToLogin) {
          return AppRoutes.login;
        }

        if (isLoggedIn && isGoingToLogin) {
          return AppRoutes.main;
        }

        return null;
      },

      routes: [
        GoRoute(
          path: AppRoutes.login,
          name: 'login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: AppRoutes.register,
          name: 'register',
          builder: (context, state) => const RegisterPage(),
        ),
        GoRoute(
          path: AppRoutes.forgetPassword,
          name: 'forgetPassword',
          builder: (context, state) => const ForgetPasswordScreen(),
        ),
        GoRoute(
          path: AppRoutes.verificationCode,
          name: 'verificationCode',
          builder: (context, state) => const VerificationCodeScreen(),
        ),
        GoRoute(
          path: AppRoutes.createNewPassword,
          name: 'createNewPassword',
          builder: (context, state) => const CreateNewPasswordScreen(),
        ),
        GoRoute(
          path: AppRoutes.main,
          name: 'main',
          builder:
              (context, state) => BlocProvider(
                create:
                    (context) =>
                        OperationsCubit(sl<BookingRepository>())
                          ..fetchOperations(),
                child: MainScreen(),
              ),
        ),
        GoRoute(
          path: AppRoutes.ai,
          name: 'ai',
          builder: (context, state) => const ChatScreen(),
        ),
        GoRoute(
          path: AppRoutes.verification,
          name: 'verification',
          builder: (context, state) => const VerificationScreen(),
        ),
        GoRoute(
          path: AppRoutes.timer,
          name: 'timer',
          builder: (context, state) => const TimerScreen(),
        ),

        GoRoute(
          path: AppRoutes.profileSettings,
          name: 'profileSettings',
          builder: (context, state) => const ProfileSettingsScreen(),
        ),

        GoRoute(
          path: AppRoutes.personalInfo,
          name: 'personalInfo',
          builder: (context, state) => const PersonalInfoScreen(),
        ),

        GoRoute(
          path: AppRoutes.scanIdCard,
          name: 'scanIdCard',
          builder: (context, state) => const ScanIdCardScreen(),
        ),
        GoRoute(
          path: AppRoutes.branchBooking,
          name: 'branchBooking',
          builder: (context, state) {
            final branch = state.extra as GovernmentBranch;

            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (_) => sl<ServicesCubit>()..fetchServices(),
                ),
                BlocProvider(create: (_) => sl<BookingCubit>()),
              ],
              child: BranchBookingScreen(branch: branch),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.map,
          name: 'map',
          builder: (context, state) => const MapScreen(),
        ),
      ],
    );
  }
}
