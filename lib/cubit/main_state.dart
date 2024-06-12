part of 'main_cubit.dart';

sealed class MainState extends Equatable {
  const MainState({
    this.datingData,
  });
  final DatingModel? datingData;

  MainState copyWith({DatingModel? datingData}) {
    return DatingDataLoaded(datingData: datingData ?? this.datingData);
  }
}

final class MainInitial extends MainState {
  @override
  List<dynamic> get props => [];
}

final class DatingDataLoaded extends MainState {
  const DatingDataLoaded({
    this.datingData,
  });
  final DatingModel? datingData;
  @override
  List<dynamic> get props => [datingData];
}
