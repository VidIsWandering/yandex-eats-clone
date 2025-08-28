import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:yandex_eats_clone/app/app.dart';
import 'package:yandex_eats_clone/auth/auth.dart';
import 'package:yandex_eats_clone/home/view/home_page.dart';

class AppRouter {
  GoRouter router(AppBloc appBloc) => GoRouter(
    initialLocation: AppRoutes.auth.route,
    routes: [
      GoRoute(
        path: AppRoutes.auth.route,
        name: AppRoutes.auth.name,
        builder: (context, state) => const AuthPage(),
      ),
      GoRoute(
        path: AppRoutes.home.route,
        name: AppRoutes.home.name,
        builder: (context, state) =>
            const MyHomePage(title: 'Yandex Eats Clone'),
      ),
    ],
    redirect: (context, state) {
      final authenticated = appBloc.state.status == AppStatus.authenticated;
      final authenticating = state.matchedLocation == AppRoutes.auth.route;
      final isInHome = state.matchedLocation == AppRoutes.home.route;

      if (isInHome && !authenticated) return AppRoutes.auth.route;
      if (!authenticated) return AppRoutes.auth.route;
      if (authenticating && authenticated) return AppRoutes.home.route;

      return null;
    },
    refreshListenable: GoRouterAppBlocRefreshStream(appBloc.stream),
  );
}

class GoRouterAppBlocRefreshStream extends ChangeNotifier {
  GoRouterAppBlocRefreshStream(Stream<AppState> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
