import 'package:bloc/bloc.dart';
import 'package:green_house/core/service/api_service.dart';
import 'package:green_house/feature/data/models/sensor_model.dart';
import 'package:meta/meta.dart';

part 'get_outputs_state.dart';

class GetOutputsCubit extends Cubit<GetOutputsState> {
  final ApiService apiService;
  GetOutputsCubit({required this.apiService}) : super(GetOutputsInitial());
  Future<void> getSensorsData() async {
    emit(GetOutputsLoading());
    try {
      List<SensorModel> data = await apiService.fetchSensorData();
      data = getFilteredData(data);
      emit(GetOutputsSuccess(sensorData: data));
    } catch (e) {
      emit(GetOutputsFailure(message: e.toString()));
    }
  }
  List<SensorModel> getFilteredData(List<SensorModel> rawData) {

    if (rawData.length <= 20) return rawData;

    List<SensorModel> sampled = [];
    double step = rawData.length / 20;

    for (int i = 0; i < 20; i++) {
      int index = (i * step).toInt();
      sampled.add(rawData[index]);
    }

    if (sampled.last != rawData.last) {
      sampled.add(rawData.last);
    }

    return sampled;

    // if (rawData.length <= 10) return rawData;

    // return rawData.sublist(rawData.length - 10);

    // if (rawData.length < 70) return rawData;

    // List<SensorModel> filtered = [];
    // for (int i = 0; i < rawData.length; i += 90) {
    //   filtered.add(rawData[i]);
    // }
    // return filtered;
  }
}
