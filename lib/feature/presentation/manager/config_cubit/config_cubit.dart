import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:green_house/core/service/api_service.dart';
import 'package:green_house/feature/data/models/sensor_model.dart';

part 'config_state.dart';

class ConfigCubit extends Cubit<ConfigState> {
  final ApiService _apiService;

  ConfigCubit(this._apiService) : super(ConfigInitial());

  Future<void> updateThresholds(SensorModel config) async {
    emit(ConfigSubmitting());
    try {
      await _apiService.updateThresholds(config);
      emit(ConfigSuccess("تم تحديث الإعدادات بنجاح"));
    } catch (e) {
      emit(ConfigError(e.toString().replaceAll("Exception: ", "")));
    }
  }

  Future<void> getThresholds() async {
    emit(ConfigLoadingThresholds());
    try {
      final thresholds = await _apiService.fetchThresholds();
      emit(ConfigThresholdsLoaded(thresholds));
    } catch (e) {
      emit(ConfigError(e.toString().replaceAll("Exception: ", "")));
    }
  }

  Future<void> toggleAutoControl(bool value) async {
    // Save current thresholds for optimistic update
    SensorModel? currentThresholds;
    if (state is ConfigThresholdsLoaded) {
      currentThresholds = (state as ConfigThresholdsLoaded).thresholds;
    }

    if (currentThresholds != null) {
      // Optimistically update the UI
      emit(ConfigThresholdsLoaded(
        SensorModel(
          temp: currentThresholds.temp,
          humidity: currentThresholds.humidity,
          soil: currentThresholds.soil,
          light: currentThresholds.light,
          isEnabled: value,
        ),
      ));
    } else {
      emit(ConfigSubmitting());
    }

    try {
      await _apiService.toggleAutoControl(value);
      // Refresh data from server to maintain consistency
      final thresholds = await _apiService.fetchThresholds();
      emit(ConfigThresholdsLoaded(thresholds));
    } catch (e) {
      // If failed, emit error but also try to revert UI or just let subsequent fetch handle it
      emit(ConfigError(e.toString().replaceAll("Exception: ", "")));
      // Re-fetch to get the actual state from server after failure
      try {
        final thresholds = await _apiService.fetchThresholds();
        emit(ConfigThresholdsLoaded(thresholds));
      } catch (_) {}
    }
  }
}
