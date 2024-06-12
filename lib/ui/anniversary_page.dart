import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inlovewithher/cubit/main_cubit.dart';
import 'package:inlovewithher/models/anniversary_model.dart';
import 'package:inlovewithher/models/image_picker_model.dart';
import 'package:inlovewithher/ui/display_image.dart';
import 'package:inlovewithher/utils.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

import 'clock.dart';

class AnniversaryPage extends StatefulWidget {
  const AnniversaryPage({Key? key, required this.page}) : super(key: key);
  final int page;

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
      body: Builder(
        builder: (BuildContext context) {
          var mainCubit = context.read<MainCubit>();
          AnniversaryModel data = (mainCubit.datingData?.listAnniversary ?? [])[widget.page];
          return Stack(
            alignment: Alignment.center,
            children: [
              buildBackground(data),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildDisplayDateTime(data),
                  const SizedBox(height: 24),
                  buildProgressDays(data),
                  const SizedBox(height: 48),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildBackground(AnniversaryModel data) {
    var placeHolder = Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment(0.00, -1.00),
          end: Alignment(0, 1),
          colors: [Color(0xFFFFF2F9), Color(0xFFFDF3E8)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
    );
    return DisplayImage(
      width: double.infinity,
      height: double.infinity,
      image: ImagesPickerModel(url: data.bgImage ?? ''),
      fit: BoxFit.fill,
      placeHolder: placeHolder,
    );
  }

  Widget buildProgressDays(AnniversaryModel data) {
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
                  if (data.dateTimeStamp == null) {
                    return const Text("");
                  }
                  return Text(
                    '${((now.difference(data.dateTimeStamp!).inDays) * value ~/ 100).toInt()}\nngày',
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
                "${data.title}",
                style: GoogleFonts.abrilFatface(
                  textStyle: const TextStyle(color: Colors.purpleAccent, letterSpacing: .5, fontSize: 20),
                ),
              ),
            ],
          );
        });
  }

  Widget buildDisplayDateTime(AnniversaryModel data) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Clock(
            type: ClockType.timeDiff,
            dateCompared: data.dateTimeStamp,
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
                  formatDateTime(data.dateTimeStamp, formatter: "dd/MM/yyyy"),
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

  @override
  bool get wantKeepAlive => true;
}
