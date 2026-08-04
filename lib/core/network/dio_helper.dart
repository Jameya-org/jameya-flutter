import 'package:dio/dio.dart';

class DioHelper {
  late Dio dio;

  DioHelper() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://jameya-backend.onrender.com',
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
  }
  void setToken(String token) {
    dio.options.headers['Authorization'] = 'Bearer $token';
  }
}