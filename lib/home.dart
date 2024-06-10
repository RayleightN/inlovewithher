import 'package:flutter/material.dart';
import 'package:inlovewithher/home_repository.dart';
import 'package:inlovewithher/models/dating_model.dart';
import 'anniversary_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, this.datingData}) : super(key: key);
  final DatingModel? datingData;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Builder(builder: (_) {
      if (widget.datingData != null) {
        var children = (widget.datingData?.listAnniversary ?? [])
            .map((e) => AnniversaryPage(data: e, people: widget.datingData?.listPeople))
            .toList();
        return PageView(
          children: children,
        );
      }
      return const SizedBox();
    }));
  }
}
