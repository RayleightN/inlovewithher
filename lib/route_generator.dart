import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:inlovewithher/home.dart';
import 'package:inlovewithher/models/dating_model.dart';
import 'package:inlovewithher/splash_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case "home":
      return defaultBuilder(settings: settings, screen: HomePage());
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
          DatingModel? data = state.extra as DatingModel?;
          return HomePage(datingData: data);
        },
      ),
      // ... add other routes
    ],
  ),
]);
