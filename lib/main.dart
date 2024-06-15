import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inlovewithher/colors.dart';
import 'package:inlovewithher/cubit/main_cubit.dart';
import 'package:inlovewithher/route_generator.dart';

import 'global.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final botToastBuilder = BotToastInit();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => MainCubit()),
        ],
        child: GestureDetector(
          onTap: () {
            hideKeyboard(context);
          },
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Save the day',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: mainColor),
              useMaterial3: true,
            ),
            routerConfig: goRouter,
            key: Keys.navKey,
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1)),
                child: botToastBuilder(context, child ?? const SizedBox.shrink()),
              );
            },
          ),
        ));
  }
}
