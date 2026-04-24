import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:green_house/core/service/api_service.dart';
import 'package:image_picker/image_picker.dart';

part 'model_state.dart';

class ModelCubit extends Cubit<ModelState> {
  final ApiService _apiService;
  final ImagePicker _picker = ImagePicker();

  ModelCubit(this._apiService) : super(ModelInitial());

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        emit(ModelImageSelected(image.path));
      }
    } catch (e) {
      emit(ModelError("خطأ في اختيار الصورة: $e"));
    }
  }

  Future<void> classifyImage(String imagePath) async {
    emit(ModelLoading());
    try {
      final response = await _apiService.predictLeafDisease(imagePath);
      if (response['status'] == 'success') {
        emit(ModelSuccess(response['prediction']));
      } else {
        emit(ModelError("فشل في التنبؤ"));
      }
    } catch (e) {
      emit(ModelError(e.toString().replaceAll("Exception: ", "")));
    }
  }

  void reset() {
    emit(ModelInitial());
  }
}
