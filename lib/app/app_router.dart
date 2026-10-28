import 'package:go_router/go_router.dart';
import 'package:nutri_buddy/features/auth/presentation/pages/auth_gate.dart';

/// AuthGate swaps between sign-in, onboarding and summary for the current session.
abstract final class AppRouter {
  static final GoRouter router = GoRouter(
    routes: [GoRoute(path: '/', builder: (context, state) => const AuthGate())],
  );
}
