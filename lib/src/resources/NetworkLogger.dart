import 'package:dio/dio.dart';

class NetWorkLogger extends Interceptor{

  final int _maxCharactersPerLine = 200;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {

    print("--> ${options.method} ${options.path}");
    print("Content type: ${options.contentType}");
    print("<-- END HTTP");

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {

    print("<-- ${response.statusCode}");
    print(response.data);
    print("<-- END HTTP");
    super.onResponse(response, handler);
  }


  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {

    print("<-- Error -->");
    print(err.error);
    print(err.message);
    super.onError(err, handler);
  }

}