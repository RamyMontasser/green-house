part of 'model_cubit.dart';

sealed class ModelState {
  final String? imagePath;
  ModelState({this.imagePath});
}

class ModelInitial extends ModelState {}

class ModelImageSelected extends ModelState {
  ModelImageSelected(String imagePath) : super(imagePath: imagePath);
}

class ModelLoading extends ModelState {
}

class ModelSuccess extends ModelState {
  final String prediction;
  ModelSuccess(this.prediction);
}

class ModelError extends ModelState {
  final String message;
  ModelError(this.message,);
}
