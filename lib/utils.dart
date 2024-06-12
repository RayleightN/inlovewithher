import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:inlovewithher/models/zodiac_model.dart';
import 'package:intl/intl.dart';

List<ZodiacModel> zodiacList = [
  ZodiacModel(name: "Capricorn", imagePath: "assets/images/zodiac/10.png"),
  ZodiacModel(name: "Aquarius", imagePath: "assets/images/zodiac/11.png"),
  ZodiacModel(name: "Pisces", imagePath: "assets/images/zodiac/12.png"),
  ZodiacModel(name: "Aries", imagePath: "assets/images/zodiac/1.png"),
  ZodiacModel(name: "Taurus", imagePath: "assets/images/zodiac/2.png"),
  ZodiacModel(name: "Gemini", imagePath: "assets/images/zodiac/3.png"),
  ZodiacModel(name: "Cancer", imagePath: "assets/images/zodiac/4.png"),
  ZodiacModel(name: "Leo", imagePath: "assets/images/zodiac/5.png"),
  ZodiacModel(name: "Virgo", imagePath: "assets/images/zodiac/6.png"),
  ZodiacModel(name: "Libra", imagePath: "assets/images/zodiac/7.png"),
  ZodiacModel(name: "Scorpio", imagePath: "assets/images/zodiac/8.png"),
  ZodiacModel(name: "Sagittarius", imagePath: "assets/images/zodiac/9.png"),
];

ZodiacModel getZodiac(DateTime? birthdate) {
  const List<int> signDays = [0, 22, 20, 21, 21, 22, 23, 23, 23, 23, 23, 22, 22];
  if (birthdate == null) {
    return ZodiacModel();
  }

  if (birthdate.day < signDays[birthdate.month]) {
    return zodiacList[birthdate.month - 1];
  } else {
    return zodiacList[birthdate.month];
  }
}

int calculateAge(DateTime? birthDate) {
  if (birthDate == null) return 0;
  DateTime currentDate = DateTime.now();
  int age = currentDate.year - birthDate.year;
  int month1 = currentDate.month;
  int month2 = birthDate.month;
  if (month2 > month1) {
    age--;
  } else if (month1 == month2) {
    int day1 = currentDate.day;
    int day2 = birthDate.day;
    if (day2 > day1) {
      age--;
    }
  }
  return age;
}

String formatDateTime(DateTime? date, {String? formatter}) {
  if (date == null) {
    return "";
  }
  String formattedDate = DateFormat(formatter ?? 'yyyy-MM-dd').format(date);
  return formattedDate;
}

void showToast(message) {
  BotToast.showText(text: message, textStyle: const TextStyle(fontSize: 14, color: Colors.white));
}

extension IterableExtension<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
