part of 'config_cubit.dart';

abstract class ConfigState {}

class ConfigInitial extends ConfigState {}

class ConfigSubmitting extends ConfigState {}

class ConfigSuccess extends ConfigState {
  final String message;
  ConfigSuccess(this.message);
}

class ConfigError extends ConfigState {
  final String message;
  ConfigError(this.message);
}

class ConfigLoadingThresholds extends ConfigState {}

class ConfigThresholdsLoaded extends ConfigState {
  final SensorModel thresholds;
  ConfigThresholdsLoaded(this.thresholds);
}
