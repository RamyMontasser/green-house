import 'package:dio/dio.dart';

class Failure {
  final String errMsg;

  Failure({required this.errMsg});
}

class ApiFailure extends Failure {
  ApiFailure({required super.errMsg});

  factory ApiFailure.fromDioException(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
        return ApiFailure(errMsg: 'Connction time outTime with api');
      case DioExceptionType.sendTimeout:
        return ApiFailure(errMsg: 'Send messege fail with api');
      case DioExceptionType.receiveTimeout:
        return ApiFailure(errMsg: 'Receive messege fail with api');
      case DioExceptionType.badCertificate:
        return ApiFailure(errMsg: 'Bad certificate received');
      case DioExceptionType.badResponse:
        return ApiFailure.fromResponse(
          dioException.response!.statusCode!,
          dioException.response!.data,
        );
      case DioExceptionType.cancel:
        return ApiFailure(errMsg: 'the reust was cancelled ,please try again!');
      case DioExceptionType.connectionError:
        return ApiFailure(
          errMsg: 'the internet connection fail,please try again!',
        );
      case DioExceptionType.unknown:
        return ApiFailure(errMsg: 'Unexpected error ,please try again!');
    }
  }
  factory ApiFailure.fromResponse(
    int satatusCode,
    Map<String, dynamic> responsData,
  ) {
    if (satatusCode == 400 || satatusCode == 401 || satatusCode == 403) {
      return ApiFailure(errMsg: responsData['error']['message']);
    } else if (satatusCode == 404) {
      return ApiFailure(errMsg: 'You requst not found,please try later!');
    } else if (satatusCode == 500) {
      return ApiFailure(errMsg: 'the Server has an error ,please try later!');
    } else {
      return ApiFailure(errMsg: 'Unexpected error ,please try again!');
    }
  }
}
