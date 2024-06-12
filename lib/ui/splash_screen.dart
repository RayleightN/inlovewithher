import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:inlovewithher/cubit/main_cubit.dart';
import 'package:inlovewithher/route_generator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with AfterLayoutMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              image: AssetImage("assets/images/love3.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SpinKitThreeBounce(
          size: 30,
          color: Colors.pinkAccent.withOpacity(0.8),
        ),
      ],
    ));
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    context.read<MainCubit>().getDataDating().then((value) {
      goRouter.go("/home");
    });
  }
}
