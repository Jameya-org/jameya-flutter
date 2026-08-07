import 'package:dio/dio.dart';

import '../cache/cache_helper.dart';
import 'app_interceptor.dart';

class DioHelper {
  DioHelper(CacheHelper cacheHelper) {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://jameya-backend.onrender.com',
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // Attach the single interceptor that handles both auth injection
    // and structured request / response / error logging.
    dio.interceptors.add(AppInterceptor(cacheHelper));
  }
  late Dio dio;
}
