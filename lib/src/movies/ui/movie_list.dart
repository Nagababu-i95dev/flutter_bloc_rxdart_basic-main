import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:poc_bloc/src/movies/ui/movie_detail.dart';
import '../../common/blocs/connectivity_bloc.dart';
import '../models/item_model.dart';
import '../blocs/movies_bloc.dart';

class MovieList extends StatefulWidget {
  static const routeName =  '/movie_list';

  @override
  State<MovieList> createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  var _movieList = new ItemModel();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: connectivityBloc.internetStatus,
        builder: (context, AsyncSnapshot _internetStatus) {
          return Scaffold(
              appBar: AppBar(
                title: const Text('Popular Movies'),
              ),
              body:
              _render(context, _internetStatus));
        });
  }

  Widget _render(BuildContext context, AsyncSnapshot _internetStatus) {
    return (_internetStatus.data == ConnectivityResult.none)
        ? (_movieList.results.isNotEmpty ? _buildScreen()
            : _buildPage('No Network Connection'))
        : _buildScreen();
  }

  Widget _buildPage(String message) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '$message',
          style: TextStyle(
            fontSize: 20, color: Colors.black
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildScreen() {
    bloc.fetchAllMovies();
    return StreamBuilder(
      stream: bloc.allMovies,
      builder: (context, AsyncSnapshot<ItemModel> movieList) {
        if (movieList.hasData) {
          if (movieList.data!.error == null) {
            _movieList = movieList.data!;
            return _buildList(_movieList);
          } else {
            if (_movieList.error == null)
              return _buildList(_movieList);
          }
        } else if (movieList.hasError) {
          _movieList = movieList.data!;
          return Text(movieList.error.toString());
        }
        return _buildPage('No Internet Connection');
      },
    );
  }

  Widget _buildList(ItemModel movieList) {
    return GridView.builder(
        itemCount: movieList.results.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          return TextButton(
            child: Image.network(
              'https://image.tmdb.org/t/p/w185${movieList.results[index].posterPath}',
              fit: BoxFit.cover,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(MovieDetails.routeName, arguments: movieList.results[index].id);
            },
          );
        });
  }
}
