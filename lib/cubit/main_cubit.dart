import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/anniversary_model.dart';
import '../models/dating_model.dart';
import '../models/person_model.dart';
import '../repositories/home_repository.dart';

part 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(MainInitial());
  final repo = HomeRepository();

  DatingModel? get datingData => state.datingData;

  Future<void> getDataDating() async {
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
    emit(state.copyWith(datingData: datingModel));
  }
}
