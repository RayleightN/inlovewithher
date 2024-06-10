import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inlovewithher/models/anniversary_model.dart';
import 'package:inlovewithher/screen_utils.dart';
import 'package:inlovewithher/utils.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

import 'home_repository.dart';

class AnniversaryPage extends StatefulWidget {
  const AnniversaryPage({Key? key, required this.id, this.people}) : super(key: key);
  final String id;
  final List<String>? people;

  @override
  State<AnniversaryPage> createState() => _AnniversaryPageState();
}

class _AnniversaryPageState extends State<AnniversaryPage> with AutomaticKeepAliveClientMixin {
  ValueNotifier<double> valueNotifier = ValueNotifier(0.0);
  DateTime now = DateTime.now();
  AnniversaryModel? data;

  @override
  void initState() {
    valueNotifier.value = 100;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        body: FutureBuilder(
            future: HomeRepository().getAnniversaryData(widget.id),
            builder: (_, snap) {
              if (snap.hasData && snap.data != null) {
                data = snap.data;
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    buildBackground(),
                    buildProgressDays(),
                    buildRowPeople(),
                  ],
                );
              }
              return const SizedBox();
            }));
  }

  Widget buildRowPeople() {
    if ((widget.people ?? []).length < 2) {
      return const SizedBox();
    }
    return Positioned(
      bottom: ScreenUtils().pdBot + 12,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildInformation(widget.people!.first),
          Image.asset(
            "assets/gif/heart.gif",
            width: 40,
            height: 40,
            fit: BoxFit.fill,
          ),
          buildInformation(widget.people!.last),
        ],
      ),
    );
  }

  Widget buildBackground() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: NetworkImage(data?.bgImage ?? ""),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget buildProgressDays() {
    return ValueListenableBuilder<double>(
        valueListenable: valueNotifier,
        builder: (_, value, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SimpleCircularProgressBar(
                size: 200,
                animationDuration: 2,
                backStrokeWidth: 10,
                progressStrokeWidth: 10,
                valueNotifier: valueNotifier,
                mergeMode: false,
                backColor: Colors.pinkAccent,
                progressColors: const [
                  Colors.cyan,
                  Colors.green,
                  Colors.amberAccent,
                  Colors.redAccent,
                  Colors.purpleAccent
                ],
                onGetText: (double value) {
                  if (data?.dateTimeStamp == null) {
                    return const Text("");
                  }
                  return Text(
                    '${((now.difference(data!.dateTimeStamp!).inDays) * value ~/ 100).toInt()}',
                    style: const TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  );
                },
              ),
              const SizedBox(height: 12),
              Text(
                "${data?.title}",
                style: GoogleFonts.abrilFatface(
                  textStyle: const TextStyle(color: Colors.white, letterSpacing: .5, fontSize: 20),
                ),
              ),
            ],
          );
        });
  }

  Widget buildDisplayDateTime() {
    DateTime? date = data?.dateTimeStamp;
  }

  Widget buildInformation(String personId) {
    return FutureBuilder(
        future: HomeRepository().getPersonData(personId),
        builder: (_, snap) {
          if (!snap.hasData) {
            return buildAvatar();
          }
          var person = snap.data;
          return Column(
            children: [
              buildAvatar(imageUrl: snap.data?.avatar),
              const SizedBox(height: 4),
              Text(
                "${person?.name}",
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  buildAgeZodiac(bgColor: Colors.orange, text: calculateAge(person?.dateOfBirth).toString()),
                  const SizedBox(width: 8),
                  buildAgeZodiac(bgColor: Colors.purpleAccent, text: getZodiacSign(person?.dateOfBirth).toString()),
                ],
              ),
            ],
          );
        });
  }

  Widget buildAvatar({String? imageUrl}) {
    const double size = 80;
    if (imageUrl == null) {
      return Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.pinkAccent,
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(48),
      child: Image.network(imageUrl, height: size, width: size, fit: BoxFit.fill),
    );
  }

  Widget buildAgeZodiac({required Color bgColor, String? text}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: bgColor,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.cloud,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            "$text",
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
