import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:inlovewithher/database_helper.dart';
import 'package:inlovewithher/repositories/home_repository.dart';
import 'package:inlovewithher/models/anniversary_model.dart';
import 'package:inlovewithher/models/dating_model.dart';
import 'package:inlovewithher/models/person_model.dart';
import 'package:inlovewithher/screen_utils.dart';

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
    getDataDating().then((value) {
      context.go("/home");
    });
  }

  Future<void> getDataDating() async {
    var repo = HomeRepository();
    List<AnniversaryModel> listAnniversary = [];
    List<PersonModel> listPeople = [];
    DatingModel? datingModel = await repo.getDatingData();
    List<Future> listAnniversaryFuture =
        (datingModel?.anniversaryDay ?? []).map((anniversaryId) => repo.getAnniversaryData(anniversaryId)).toList();
    List<Future> listPeopleFuture =
        (datingModel?.people ?? []).map((personId) => repo.getPersonData(personId)).toList();
    var response = await Future.wait<dynamic>([
      ...listAnniversaryFuture,
      ...listPeopleFuture,
    ]);
    for (var element in response) {
      if (element is AnniversaryModel) {
        listAnniversary.add(element);
      }
      if (element is PersonModel) {
        listPeople.add(element);
      }
    }
    datingModel?.listAnniversary = listAnniversary;
    datingModel?.listPeople = listPeople;
    DatabaseHelper().datingData = datingModel;
  }
}
