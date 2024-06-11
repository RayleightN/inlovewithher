import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:inlovewithher/ui/home.dart';
import 'package:inlovewithher/ui/splash_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case "home":
      return defaultBuilder(settings: settings, screen: const HomePage());
    case "splash":
      return defaultBuilder(settings: settings, screen: const SplashScreen());
    default:
      return defaultBuilder(settings: settings, screen: const SplashScreen());
  }
}

dynamic defaultBuilder({required RouteSettings settings, required Widget screen, bool fullScreenDialog = false}) {
  return CupertinoPageRoute(
    fullscreenDialog: fullScreenDialog,
    builder: (context) => screen,
    settings: settings,
  );
}

final goRouter = GoRouter(initialLocation: "/", routes: [
  GoRoute(
    path: "/",
    builder: (context, state) => const SplashScreen(),
    routes: [
      GoRoute(
        path: "home",
        builder: (context, state) {
          return const HomePage();
        },
      ),
      // ... add other routes
    ],
  ),
]);
