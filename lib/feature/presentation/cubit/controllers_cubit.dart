import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

part 'controllers_state.dart';

class ControllersCubit extends Cubit<ControllersState> {
  final Dio _dio = Dio();
  final String baseUrl = "http://touchofnature.runasp.net/api/Greenhouse";
  ControllersCubit() : super(ControllersInitial( isOn: false));

 Future<void> toggleDevice(String onEndpoint, String offEndpoint) async {
    final currentState = state.isOn;
    emit(
      ControllersLoading(isOn: currentState),
    ); 

    try {
      final endpoint = currentState ? offEndpoint : onEndpoint;
      await _dio.post("$baseUrl/$endpoint");

      emit(ControllersSuccess(isOn: !currentState));
    } catch (e) {
      emit(ControllersFailure( isOn: currentState, errorMessage: e.toString()));
    }
  }

  Future<void> toggleAutoControl(bool shouldEnable) async {
    emit(ControllersLoading(isOn: state.isOn));

    try {
      // نرسل القيمة كـ Body للطلب
      await _dio.post(
        "http://touchofnature.runasp.net/api/Greenhouse/auto-control-enable",
        data: shouldEnable, 
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      emit(ControllersSuccess(isOn: shouldEnable));
    } catch (e) {
      emit(ControllersFailure(isOn: state.isOn, errorMessage: e.toString()));
    }
  }
}
