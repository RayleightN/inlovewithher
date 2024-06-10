import 'package:flutter/material.dart';
import 'package:inlovewithher/home_repository.dart';
import 'anniversary_page.dart';
import 'day_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

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
    return Scaffold(
        body: FutureBuilder(
            future: HomeRepository().getDatingData(),
            builder: (_, snap) {
              if (snap.hasData && snap.data != null) {
                var children = (snap.data?.anniversaryDay ?? [])
                    .map((e) => AnniversaryPage(id: e, people: snap.data?.people))
                    .toList();
                return PageView(
                  children: children,
                );
              }
              return const SizedBox();
            }));
  }
}
