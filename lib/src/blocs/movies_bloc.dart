import 'package:rxdart/rxdart.dart';
import '../models/item_model.dart';
import '../resources/repository.dart';

class MoviesBloc {
  final _repository = Repository();

  // Sink and Stream both. Allows sending data , errors and done events to the listener
  final _moviesFetcher = PublishSubject<ItemModel>();
  final _movieDetails = PublishSubject<Result>();

  // sends the list of all movies to UI
  Observable<ItemModel> get allMovies => _moviesFetcher.stream;

  Observable<Result> get movieDetails => _movieDetails.stream;

  fetchAllMovies() async {
    ItemModel itemModel = await _repository.fetchAllMovies();
    print('Result in Movie List to sink $itemModel');
    _moviesFetcher.sink.add(itemModel);
  }

  fetchMovieDetails(String movieId) async {
    Result result = await _repository.fetchMovieDetails(movieId);
    _movieDetails.sink.add(result);
  }

  dispose() {
    _moviesFetcher.close();
  }
}

final bloc = MoviesBloc();
