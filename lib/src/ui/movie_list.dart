import 'package:flutter/material.dart';
import 'package:poc_bloc/src/ui/movie_detail.dart';
import '../models/item_model.dart';
import '../blocs/movies_bloc.dart';

class MovieList extends StatelessWidget {
  static const routeName = '/movie_list';
  @override
  Widget build(BuildContext context) {
    bloc.fetchAllMovies();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Movies'),
      ),
      body: StreamBuilder(
        stream: bloc.allMovies,
        builder: (context, AsyncSnapshot<ItemModel> snapshot) {
          if (snapshot.hasData) {
            return buildList(snapshot);
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget buildList(AsyncSnapshot<ItemModel> snapshot) {
    return GridView.builder(
        itemCount: snapshot.data!.results.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          return TextButton(
            child: Image.network(
              'https://image.tmdb.org/t/p/w185${snapshot.data!
                  .results[index].posterPath}',
              fit: BoxFit.cover,
            ),
            onPressed: (){
              Navigator.of(context).pushNamed(MovieDetails.routeName, arguments: snapshot.data?.results[index].id);
            },
          );
        });
  }
}