import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_queue/core/routing/app_routes.dart';
import 'package:smart_queue/core/routing/auth_notifier.dart';
import 'package:smart_queue/features/ai/ai_screen.dart';
import 'package:smart_queue/features/app_settings/about_us/presentation/about_us_screen.dart';
import 'package:smart_queue/features/app_settings/change_password/presentation/cubit/change_password_cubit.dart';
import 'package:smart_queue/features/app_settings/change_password/presentation/view/change_password_screen.dart';
import 'package:smart_queue/features/app_settings/help_support/presentation/help_support_screen.dart';
import 'package:smart_queue/features/app_settings/presentation/app_settings_screen.dart';
import 'package:smart_queue/features/app_settings/terms_and_policy/presentation/terms_and_policy_screen.dart';
import 'package:smart_queue/features/auth/presentaion/cubit/auth_cubit.dart';
import 'package:smart_queue/features/auth/presentaion/view/login_page.dart';
import 'package:smart_queue/features/auth/presentaion/view/register_page.dart';
import 'package:smart_queue/features/branch_booking/data/models/appointment_response_model.dart';
import 'package:smart_queue/features/branch_booking/presentation/cubit/booking_cubit.dart';
import 'package:smart_queue/features/branch_booking/presentation/cubit/service_counter_cubit.dart';
import 'package:smart_queue/features/branch_booking/presentation/view/branch_booking_screen.dart';
import 'package:smart_queue/features/forget_password/presentation/view/create_new_password_screen.dart';
import 'package:smart_queue/features/forget_password/presentation/view/forget_password_screen.dart';
import 'package:smart_queue/features/main/main_screen.dart';
import 'package:smart_queue/features/map/data/models/branch_model.dart';
import 'package:smart_queue/features/map/presentation/view/map_screen.dart';
import 'package:smart_queue/features/operations_history/presentation/cubit/appointment_details_cubit.dart';
import 'package:smart_queue/features/operations_history/presentation/cubit/operations_cubit.dart';
import 'package:smart_queue/features/operations_history/presentation/view/appointment_details_screen.dart';
import 'package:smart_queue/features/operations_history/presentation/view/update_appointment_screen.dart';
import 'package:smart_queue/features/personal_info/presentation/view/personal_info_screen.dart';
import 'package:smart_queue/features/profile_settings/presentation/view/my_appointments_screen.dart';
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
          path: AppRoutes.changePassword,
          name: 'changePassword',
          builder:
              (context, state) => BlocProvider(
                create: (_) => sl<ChangePasswordCubit>(),
                child: ChangePasswordScreen(),
              ),
        ),
        GoRoute(
          path: AppRoutes.main,
          name: 'main',
          builder:
              (context, state) => BlocProvider(
                create: (_) => sl<OperationsCubit>()..fetchOperations(),
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
          builder: (context, state) {
            final duration = state.extra as Duration?;
            return TimerScreen(initialDuration: duration ?? Duration.zero);
          },
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
          path: AppRoutes.appointmentDetails,
          name: 'appointmentDetails',
          builder: (context, state) {
            final id = state.extra as int;

            return BlocProvider(
              create: (_) => sl<AppointmentDetailsCubit>(),
              child: AppointmentDetailsScreen(id: id),
            );
          },
        ),

        GoRoute(
          path: AppRoutes.scanIdCard,
          name: 'scanIdCard',
          builder: (context, state) => const ScanIdCardScreen(),
        ),
        GoRoute(
          path: AppRoutes.appSettings,
          name: 'appSettings',
          builder: (context, state) => const AppSettingsScreen(),
        ),
        GoRoute(
          path: AppRoutes.myAppointments,
          name: 'myAppointments',
          builder: (context, state) => const MyAppointmentsScreen(),
        ),
        GoRoute(
          path: AppRoutes.helpSupport,
          name: 'helpSupport',
          builder: (context, state) => const HelpSupportScreen(),
        ),
        GoRoute(
          path: AppRoutes.aboutUs,
          name: 'aboutUs',
          builder: (context, state) => const AboutUsScreen(),
        ),
        GoRoute(
          path: AppRoutes.termsAndPolicy,
          name: 'termsAndPolicy',
          builder: (context, state) => const TermsPolicyScreen(),
        ),
        GoRoute(
          path: AppRoutes.branchBooking,
          name: 'branchBooking',
          builder: (context, state) {
            final branch = state.extra as BranchModel;

            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create:
                      (_) =>
                          sl<ServiceCounterCubit>()
                            ..fetchServiceCounters(branch.id!),
                ),
                BlocProvider(create: (_) => sl<BookingCubit>()),
              ],
              child: BranchBookingScreen(branch: branch),
            );
          },
        ),

        GoRoute(
          path: AppRoutes.updateAppointment,
          name: 'updateAppointment',
          builder: (context, state) {
            final appointment = state.extra as AppointmentResponseModel;

            return BlocProvider(
              create: (context) => sl<AppointmentDetailsCubit>(),
              child: UpdateAppointmentScreen(appointment: appointment),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.map,
          name: 'map',
          builder: (context, state) {
            final organizationId = state.extra as int;

            return MapScreen(organizationId: organizationId);
          },
        ),
      ],
    );
  }
}
