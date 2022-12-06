import 'dart:async';
import 'package:dio/dio.dart';

import '../movies/models/item_model.dart';
import 'network_logger.dart';

class MovieApiProvider {
  final _apiKey = '802b2c4b88ea1183e50e6b285a27696e';
  late Dio _dio;

  MovieApiProvider() {
    BaseOptions options =
        BaseOptions(receiveTimeout: 5000, connectTimeout: 5000);
    _dio = Dio(options);
    _dio.interceptors.add(NetWorkLogger());
  }

  Future<ItemModel> fetchMovieList() async {
    try {
      Response response = await _dio
          .get("http://api.themoviedb.org/3/movie/popular?api_key=$_apiKey");
      return ItemModel.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return ItemModel.withError(_handleError(error));
    }
  }

  Future<Result> fetchMovieDetails(String movieId) async {
    try {
      Response response = await _dio
          .get("http://api.themoviedb.org/3/movie/$movieId?api_key=$_apiKey");
      return Result.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return Result.withError(_handleError(error));
    }
  }

  String _handleError(Object error) {
    String errorDescription = "";
    if (error is DioError) {
      DioError dioError = error;
      switch (dioError.type) {
        case DioErrorType.cancel:
          errorDescription = "Request to API server was cancelled";
          break;
        case DioErrorType.connectTimeout:
          errorDescription = "Connection timeout with API server";
          break;
        case DioErrorType.other:
          errorDescription =
              "Connection to API server failed due to internet connection";
          break;
        case DioErrorType.receiveTimeout:
          errorDescription = "Receive timeout in connection with API server";
          break;
        case DioErrorType.response:
          errorDescription =
              "Received invalid status code: ${dioError.response?.statusCode}";
          break;
        case DioErrorType.sendTimeout:
          errorDescription = "Send timeout in connection with API server";
          break;
      }
    } else {
      errorDescription = "Unexpected error occured";
    }
    return errorDescription;
  }
}
