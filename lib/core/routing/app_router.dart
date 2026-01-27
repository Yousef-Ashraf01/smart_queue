import 'package:go_router/go_router.dart';
import 'package:smart_queue/core/routing/app_routes.dart';
import 'package:smart_queue/features/ai/ai_screen.dart';
import 'package:smart_queue/features/auth/presentaion/view/login_page.dart';
import 'package:smart_queue/features/auth/presentaion/view/register_page.dart';
import 'package:smart_queue/features/main/main_screen.dart';

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
    ],
  );
}
