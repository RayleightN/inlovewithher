import 'package:flutter/material.dart';
import 'package:inlovewithher/screen_utils.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ValueNotifier<double> valueNotifier = ValueNotifier(0.0);

  @override
  void initState() {
    valueNotifier.value = 80;
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          buildBackground(),
          buildProgressDays(),
          Positioned(
            bottom: ScreenUtils().pdBot,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildInformation(name: "Messi"),
                Image.asset(
                  "assets/gif/heart.gif",
                  width: 40,
                  height: 40,
                  fit: BoxFit.fill,
                ),
                buildInformation(name: "Ronaldo"),
              ],
            ),
          ),
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
          image: AssetImage("assets/images/love3.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget buildProgressDays() {
    return SimpleCircularProgressBar(
      size: 200,
      animationDuration: 2,
      backStrokeWidth: 10,
      progressStrokeWidth: 10,
      valueNotifier: valueNotifier,
      mergeMode: false,
      backColor: Colors.pinkAccent,
      progressColors: const [Colors.cyan, Colors.green, Colors.amberAccent, Colors.redAccent, Colors.purpleAccent],
      onGetText: (double value) {
        return Text(
          '${value.toInt()}',
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        );
      },
    );
  }

  Widget buildInformation({String? name}) {
    return Column(
      children: [
        buildAvatar(),
        SizedBox(height: 4),
        Text(
          "${name}",
          style: TextStyle(color: Colors.white),
        ),
        SizedBox(height: 12),
        Row(
          children: [
            buildAgeZodiac(bgColor: Colors.orange),
            const SizedBox(width: 8),
            buildAgeZodiac(bgColor: Colors.purpleAccent),
          ],
        ),
      ],
    );
  }

  Widget buildAvatar() {
    const double size = 80;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.pinkAccent,
      ),
    );
  }

  Widget buildAgeZodiac({required Color bgColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: bgColor,
      ),
      child: Row(
        children: [
          Icon(
            Icons.cloud,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            "Aries",
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
