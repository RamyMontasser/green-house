import 'package:dio/dio.dart';
import 'package:green_house/feature/data/models/sensor_model.dart';

class ApiService {
  final Dio _dio = Dio();
  final String url = "http://touchofnature.runasp.net";

  Future<List<SensorModel>> fetchSensorData() async {
    try {
      final response = await _dio.get('$url/api/SensorsOutput');
      List<dynamic> data = response.data;
      return data.map((json) => SensorModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception("خطأ في الاتصال بالسيرفر: $e");
    }
  }

  Future<SensorModel> fetchThresholds() async {
    try {
      final response = await _dio.get('$url/api/Greenhouse/auto-control-get');
      return SensorModel.fromThresholdJson(response.data);
    } catch (e) {
      throw Exception("خطأ في جلب الإعدادات: $e");
    }
  }

  Future<void> toggleAutoControl(bool enabled) async {
    try {
      await _dio.post(
        '$url/api/Greenhouse/auto-control-enable',
        queryParameters: {
          'Enable': enabled,
        },
      );
    } catch (e) {
      throw Exception("خطأ في تغيير وضع التحكم التلقائي: $e");
    }
  }

  Future<void> updateThresholds(SensorModel config) async {
    try {
      await _dio.post(
        '$url/api/Greenhouse/auto-control-update',
        data: config.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
    } catch (e) {
      throw Exception("خطأ في تحديث الإعدادات: $e");
    }
  }

  Future<Map<String, dynamic>> predictLeafDisease(String imagePath) async {
    try {
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(imagePath, filename: imagePath.split('/').last),
      });

      final response = await _dio.post(
        '$url/api/Model/predict-leaf-disease',
        data: formData,
      );

      return response.data;
    } catch (e) {
      throw Exception("خطأ في تصنيف المرض: $e");
    }
  }
}
