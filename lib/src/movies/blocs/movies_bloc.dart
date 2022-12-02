import 'dart:async';

import 'package:rxdart/rxdart.dart';
import '../models/item_model.dart';
import '../../resources/repository.dart';

class MoviesBloc {
  final _repository = Repository();

  // Sink and Stream both. Allows sending data , errors and done events to the listener
  final BehaviorSubject<ItemModel> _moviesFetcher = BehaviorSubject<ItemModel>();
  final _movieDetails = BehaviorSubject<Result>();

  // sends the list of all movies to UI
  Stream<ItemModel> get allMovies => _moviesFetcher.stream;

  Stream<Result> get movieDetails => _movieDetails.stream;

  fetchAllMovies() async {
    ItemModel itemModel = await _repository.fetchAllMovies();
    _moviesFetcher.sink.add(itemModel);
  }

  // fetchMovieDetails(String movieId) async {
  //   Result result = await _repository.fetchMovieDetails(movieId);
  //   _movieDetails.sink.add(result);
  // }

  fetchMovieDetails(String movieId) async {
    print("movieId --> $movieId");
    _moviesFetcher.stream.listen((event) {
      print(event.totalPages);
      print("length -->${event.results.length}");
      for (int i = 0; i < event.results.length; i++) {
        print("originalTitle --> ${event.results[i].id}");
        if(event.results[i].id.toString() == (movieId)){
          print("originalTitle --> ${event.results[i].originalTitle}");
          _movieDetails.sink.add(event.results[i]);
        }
      }
    });

  }

  dispose() {
    print('Movie Bloc disposed');
    _moviesFetcher.close();
  }
}

final bloc = MoviesBloc();
