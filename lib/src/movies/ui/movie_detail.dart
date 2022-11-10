import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:poc_bloc/src/movies/blocs/movies_bloc.dart';
import 'package:poc_bloc/src/movies/models/item_model.dart';

import '../../common/blocs/connectivity_bloc.dart';

class MovieDetails extends StatefulWidget {
  get routeName => '/movie_details';

  const MovieDetails({Key? key}) : super(key: key);

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final movieId = ModalRoute
        .of(context)
        ?.settings
        .arguments
        .toString();
    bloc.fetchMovieDetails(movieId!);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: connectivityBloc.internetStatus,
        builder: (context, AsyncSnapshot internetStatus) {
          return Scaffold(
              appBar: AppBar(
                title: const Text('Movie Details '),
              ),
              body: _render(context, internetStatus));
        });
  }

  Widget _buildScreen() {
    return
      StreamBuilder(
        stream: bloc.movieDetails,
        builder: (context, AsyncSnapshot<Result> snapshot) {
          if (snapshot.hasData) {
            return buildList(snapshot);
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return const Center(child: CircularProgressIndicator());
        },
      );
  }

  Widget _buildPage(String message) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('$message', style: TextStyle(fontSize: 20, color: Colors.black),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _render(BuildContext context, AsyncSnapshot _internetStatus) {
    return (_internetStatus.data == ConnectivityResult.none)
        ? _buildPage('No Network Connection')
        : _buildScreen();
  }

  Widget buildList(AsyncSnapshot<Result> snapshot) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Column(
        children: [
          Center(
            child: CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(
                  'https://image.tmdb.org/t/p/w185${snapshot.data!
                      .posterPath}'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
            child: Column(
              children: [
                Text(
                  'Title : ${snapshot.data?.originalTitle}',
                  textAlign: TextAlign.justify,
                ),
                snapshot.data!.adult
                    ? Icon(Icons.child_friendly)
                    : Icon(Icons.no_adult_content),
                SizedBox(
                  height: 10,
                ),
                Text('Overview : ${snapshot.data?.overview}'),
              ],
            ),
          )
        ],
      ),
    );
  }
}
