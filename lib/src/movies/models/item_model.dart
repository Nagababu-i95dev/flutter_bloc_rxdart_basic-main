class ItemModel {
  int _page = 0;
  int _totalResults = 0;
  int _totalPages = 0;
  List<Result> _results = [];
  String? error;

  ItemModel();

  ItemModel.withError(String errorMessage) {
    error = errorMessage;
  }

  ItemModel.fromJson(Map<String, dynamic> parsedJson) {
    _page = parsedJson['page'];
    _totalResults = parsedJson['total_results'];
    _totalPages = parsedJson['total_pages'];
    List<Result> temp = [];
    for (int i = 0; i < parsedJson['results'].length; i++) {
      Result result = Result(parsedJson['results'][i]);
      temp.add(result);
    }
    _results = temp;
  }



  List<Result> get results => _results;

  int get totalPages => _totalPages;

  int get totalResults => _totalResults;

  int get page => _page;


}

class Result {
  int _voteCount = 0 ;
  int _id = 0 ;
  bool _video = false;
  dynamic _voteAverage = 0;
  String _title = '';
  double _popularity = 0.0;
  String _posterPath = '';
  String _originalLanguage = '';
  String _originalTitle = '';
  List<int> _genreIds = [];
  String _backdropPath = '';
  bool _adult = false;
  String _overview = '';
  String _releaseDate= '';
  String? error;
  Result.withError(String errorMessage) {
    error = errorMessage;
  }

  Result(result) {
    _voteCount = result['vote_count'];
    _id = result['id'];
    _video = result['video'];
    _voteAverage = result['vote_average'] ;
    _title = result['title'];
    _popularity = result['popularity'];
    _posterPath = result['poster_path'];
    _originalLanguage = result['original_language'];
    _originalTitle = result['original_title'];
    for (int i = 0; i < result['genre_ids'].length; i++) {
      _genreIds.add(result['genre_ids'][i]);
    }
    _backdropPath = result['backdrop_path'];
    _adult = result['adult'];
    _overview = result['overview'];
    _releaseDate = result['release_date'];
  }

  String get releaseDate => _releaseDate;

  String get overview => _overview;

  bool get adult => _adult;

  String get backdropPath => _backdropPath;

  List<int> get genreIds => _genreIds;

  String get originalTitle => _originalTitle;

  String get originalLanguage => _originalLanguage;

  String get posterPath => _posterPath;

  double get popularity => _popularity;

  String get title => _title;

  int get voteAverage => _voteAverage;

  bool get video => _video;

  int get id => _id;

  int get voteCount => _voteCount;

  Result.fromJson(Map<String, dynamic> parsedJson) {
    _id = parsedJson['id'];
    _title = parsedJson['title'];
    _originalTitle = parsedJson['original_title'];
    _posterPath = parsedJson['poster_path'];
    _overview = parsedJson['overview'];
    _posterPath = parsedJson['poster_path'];

  }
}