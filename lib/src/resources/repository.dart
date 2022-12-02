import 'dart:async';
import 'api_provider.dart';
import '../models/item_model.dart';

class Repository {
  final moviesApiProvider = MovieApiProvider();

  Future<ItemModel> fetchAllMovies() => moviesApiProvider.fetchMovieList();

  Future<Result> fetchMovieDetails(String movieId) =>
      moviesApiProvider.fetchMovieDetails(movieId);
}
