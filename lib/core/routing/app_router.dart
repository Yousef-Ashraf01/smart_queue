import 'package:go_router/go_router.dart';
import 'package:smart_queue/core/routing/app_routes.dart';
import 'package:smart_queue/features/ai/ai_screen.dart';
import 'package:smart_queue/features/auth/presentaion/view/login_page.dart';
import 'package:smart_queue/features/auth/presentaion/view/register_page.dart';
import 'package:smart_queue/features/main/main_screen.dart';
import 'package:smart_queue/features/timer/presentation/veiw/timer_screen.dart';
import 'package:smart_queue/features/verification/presentation/view/verification_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.login,
    debugLogDiagnostics: true,
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
        path: AppRoutes.main,
        name: 'main',
        builder: (context, state) => const MainScreen(),
      ),
      GoRoute(
        path: AppRoutes.ai,
        name: 'ai',
        builder: (context, state) => const AiScreen(),
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
    ],
  );
}
