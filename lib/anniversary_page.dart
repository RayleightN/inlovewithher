import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inlovewithher/models/anniversary_model.dart';
import 'package:inlovewithher/models/person_model.dart';
import 'package:inlovewithher/screen_utils.dart';
import 'package:inlovewithher/utils.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

import 'clock.dart';

class AnniversaryPage extends StatefulWidget {
  const AnniversaryPage({Key? key, required this.data, this.people}) : super(key: key);
  final AnniversaryModel data;
  final List<PersonModel>? people;

  @override
  State<AnniversaryPage> createState() => _AnniversaryPageState();
}

class _AnniversaryPageState extends State<AnniversaryPage> with AutomaticKeepAliveClientMixin {
  ValueNotifier<double> valueNotifier = ValueNotifier(0.0);
  DateTime now = DateTime.now();

  @override
  void initState() {
    valueNotifier.value = 100;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          buildBackground(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildDisplayDateTime(),
              const SizedBox(height: 24),
              buildProgressDays(),
              const SizedBox(height: 48),
            ],
          ),
          buildRowPeople(),
        ],
      ),
    );
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
    var placeHolder = Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.pinkAccent.withOpacity(0.5),
      ),
    );
    return CachedNetworkImage(
      width: double.infinity,
      height: double.infinity,
      imageUrl: widget.data.bgImage ?? '',
      fit: BoxFit.fill,
      placeholder: (_, __) {
        return placeHolder;
      },
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
                  if (widget.data.dateTimeStamp == null) {
                    return const Text("");
                  }
                  return Text(
                    '${((now.difference(widget.data.dateTimeStamp!).inDays) * value ~/ 100).toInt()}',
                    style: const TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.purpleAccent,
                    ),
                    textAlign: TextAlign.center,
                  );
                },
              ),
              const SizedBox(height: 12),
              Text(
                "${widget.data.title}",
                style: GoogleFonts.abrilFatface(
                  textStyle: const TextStyle(color: Colors.purpleAccent, letterSpacing: .5, fontSize: 20),
                ),
              ),
            ],
          );
        });
  }

  Widget buildDisplayDateTime() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Clock(
            type: ClockType.timeDiff,
            dateCompared: widget.data.dateTimeStamp,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.withOpacity(0.5),
                ),
                child: Text(
                  formatDateTime(widget.data.dateTimeStamp, formatter: "dd/MM/yyyy"),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const Clock(type: ClockType.time),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildInformation(PersonModel person) {
    return Column(
      children: [
        buildAvatar(imageUrl: person.avatar),
        const SizedBox(height: 4),
        Text(
          "${person.name}",
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            buildAgeZodiac(
                bgColor: Colors.orange, text: calculateAge(person.dateOfBirth).toString(), icon: person.getIconSex()),
            const SizedBox(width: 8),
            buildAgeZodiac(
              bgColor: Colors.purpleAccent,
              text: getZodiac(person.dateOfBirth).name,
              iconPath: getZodiac(person.dateOfBirth).imagePath,
            ),
          ],
        ),
      ],
    );
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

  Widget buildAgeZodiac({required Color bgColor, String? text, IconData? icon, String? iconPath}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: bgColor,
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
          ],
          if (iconPath != null) ...[
            Image.asset(iconPath, fit: BoxFit.fill, width: 20, height: 20),
            const SizedBox(width: 4),
          ],
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
