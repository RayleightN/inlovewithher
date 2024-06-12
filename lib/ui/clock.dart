import 'dart:async';

import 'package:flutter/material.dart';
import 'package:inlovewithher/utils.dart';

enum ClockType { time, timeDiff }

class Clock extends StatefulWidget {
  const Clock({Key? key, required this.type, this.dateCompared}) : super(key: key);
  final ClockType type;
  final DateTime? dateCompared;

  @override
  State<Clock> createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  String? hour;
  String? minute;
  String? second;

  int? yearsDiff;
  int? monthsDiff;
  int? weeksDiff;
  int? daysDiff;

  @override
  void initState() {
    DateTime now = DateTime.now();
    hour = formatDateTime(now, formatter: "hh");
    minute = formatDateTime(now, formatter: "mm");
    second = formatDateTime(now, formatter: "ss");
    _getTime(shouldSetState: false);

    Timer.periodic(const Duration(seconds: 1), (Timer t) {
      _getTime(shouldSetState: true);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.type == ClockType.time) {
      return Row(
        children: [
          buildCircleNumber(hour),
          dot(),
          buildCircleNumber(minute),
          dot(),
          buildCircleNumber(second),
        ],
      );
    }
    return Row(
      children: [
        Expanded(child: buildNumberClockYear(yearsDiff, text: "year")),
        const SizedBox(width: 8),
        Expanded(child: buildNumberClockYear(monthsDiff, text: "month")),
        const SizedBox(width: 8),
        Expanded(child: buildNumberClockYear(weeksDiff, text: "week")),
        const SizedBox(width: 8),
        Expanded(child: buildNumberClockYear(daysDiff, text: "day")),
      ],
    );
  }

  Widget buildNumberClockYear(int? number, {String? text}) {
    bool showS = (number ?? 0) > 1;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.deepPurpleAccent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text('$number', style: TextStyle(fontSize: 30, color: Colors.white)),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                '$text${showS ? "s" : ""}',
                style: TextStyle(fontSize: 12, color: Colors.deepPurpleAccent),
              )),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget buildCircleNumber(String? num) {
    return Container(
      width: 26,
      height: 26,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.purpleAccent,
      ),
      child: Text('$num',
          style: const TextStyle(
            color: Colors.white,
          )),
    );
  }

  Widget dot() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: const Text(
        ':',
        style: TextStyle(color: Colors.purpleAccent, fontSize: 20, fontWeight: FontWeight.w600),
      ),
    );
  }

  void _getTime({shouldSetState = false}) {
    final DateTime now = DateTime.now();
    hour = formatDateTime(now, formatter: "hh");
    minute = formatDateTime(now, formatter: "mm");
    second = formatDateTime(now, formatter: "ss");
    DateTime compared = widget.dateCompared ?? DateTime.now();
    int totalDays = now.difference(compared).inDays;
    yearsDiff = totalDays ~/ 365;
    monthsDiff = (totalDays - (yearsDiff ?? 0) * 365) ~/ 30;
    weeksDiff = (totalDays - (yearsDiff ?? 0) * 365 - ((monthsDiff ?? 0) * 30)) ~/ 7;
    daysDiff = totalDays - (yearsDiff ?? 0) * 365 - (monthsDiff ?? 0) * 30 - (weeksDiff ?? 0) * 7;
    if (shouldSetState) {
      setState(() {});
    }
  }
}
