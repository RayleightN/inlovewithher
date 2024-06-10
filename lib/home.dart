import 'package:flutter/material.dart';
import 'anniversary_page.dart';
import 'day_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ValueNotifier<double> valueNotifier = ValueNotifier(0.0);
  DateTime now = DateTime.now();

  @override
  void initState() {
    valueNotifier.value = 100;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: [
          AnniversaryPage(date: dayInLove, title: "Days in love"),
          AnniversaryPage(date: firstMessageDay, title: "Days since first message"),
          AnniversaryPage(date: dayWeMet, title: "Days since we met"),
          AnniversaryPage(date: firstKissDay, title: "Days since our first kiss"),
          AnniversaryPage(date: daySayLove, title: "Days since says love"),
        ],
      ),
    );
  }
}
