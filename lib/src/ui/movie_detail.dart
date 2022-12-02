import 'package:flutter/material.dart';
import 'package:poc_bloc/src/blocs/movies_bloc.dart';
import 'package:poc_bloc/src/models/item_model.dart';

class MovieDetails extends StatefulWidget {
  static const routeName = '/movie_details';

  const MovieDetails({Key? key}) : super(key: key);

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    final movieId = ModalRoute.of(context)?.settings.arguments.toString();
    bloc.fetchMovieDetails(movieId!);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
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

  Widget buildList(AsyncSnapshot<Result> snapshot) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie - ${snapshot.data?.title} '),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: Column(
          children: [
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage('https://image.tmdb.org/t/p/w185${snapshot.data!.posterPath}'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
              child: Column(
                children: [
                  Text('Title : ${snapshot.data?.originalTitle}', textAlign: TextAlign.justify,),
                  snapshot.data!.adult ?Icon(Icons.child_friendly) :Icon(Icons.no_adult_content),
                  SizedBox(height: 10,),
                  Text('Overview : ${snapshot.data?.overview}'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
