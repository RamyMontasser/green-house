part of 'get_outputs_cubit.dart';

@immutable
sealed class GetOutputsState {}

final class GetOutputsInitial extends GetOutputsState {}
final class GetOutputsLoading extends GetOutputsState {}
final class GetOutputsSuccess extends GetOutputsState {
  final List<SensorModel> sensorData;

  GetOutputsSuccess({required this.sensorData});
}
final class GetOutputsFailure extends GetOutputsState {
  final String message;

  GetOutputsFailure({required this.message});
}
