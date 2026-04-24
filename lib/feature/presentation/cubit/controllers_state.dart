part of 'controllers_cubit.dart';

@immutable
sealed class ControllersState {
  final bool isOn;

  ControllersState({required this.isOn});
}

final class ControllersInitial extends ControllersState {
  ControllersInitial({required super.isOn});
}
final class ControllersLoading extends ControllersState {
  ControllersLoading({required super.isOn});
}
final class ControllersSuccess extends ControllersState {
  ControllersSuccess({required super.isOn});
}
final class ControllersFailure extends ControllersState {
  final String errorMessage;
  ControllersFailure({required super.isOn, required this.errorMessage});
}
