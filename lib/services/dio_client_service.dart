import 'package:dio/dio.dart';
import 'package:news_app_mayank/app/environment_config.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioClientService {
  DioClientService() {
    configureDio();
  }

  final _dio = Dio();

  get dio => _dio;

  configureDio() {
    _dio.options
      ..baseUrl = EnvironmentConfig.baseUrl
      ..contentType = "application/json"
      ..headers = {
        "Authorization": EnvironmentConfig.apiKey,
        "X-Requested-With": "XmlHttpRequest",
        "content-type": "application/json"
      };

    if (EnvironmentConfig.showLogs) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: false,
          requestBody: true,
          responseBody: false,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
      );
    }
  }
}
