// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key});

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final List<Movie> movieList = [];

  @override
  void initState() {
    super.initState();
    // _getMovieList();
  }

  void _getMovieList(){
    _firebaseFirestore.collection('movies').get().then((value) {
      movieList.clear();
      for (QueryDocumentSnapshot doc in value.docs) {
        // print(doc.data());
        movieList.add(
          Movie.fromJson(doc.id, doc.data() as Map<String, dynamic>),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Movies'),
      ),
      body: StreamBuilder<Object>(
        stream: _firebaseFirestore.collection('movies').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {

          if(snapshot.hasError){
            return Center(
              child: Text(snapshot.error.toString());
            )
          }
          movieList.clear();
          for (QueryDocumentSnapshot doc in (snapshot.data?.docs ?? [])) {
            // print(doc.data());
            movieList.add(
              Movie.fromJson(doc.id, doc.data() as Map<String, dynamic>),
            );
          }
          return ListView.separated(
              itemCount: movieList.length,
              itemBuilder: (context, index){
                return  ListTile(
                  title: Text(movieList[index].name),
                  subtitle: Text(movieList[index].language),
                  leading: Text(movieList[index].ratings),
                  trailing: Text(movieList[index].year),
                );
              },
              separatorBuilder: (_, __) => const Divider(),
              );
        }
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: (){
              Map<String, dynamic> newMovie = {
                'name' : 'King Kong',
                'year' : '1996',
                'languages' : 'English, Bangla',
                'rating' : '5'
              };
              _firebaseFirestore.collection('movies').doc('new-doc-1').set(newMovie);
            },
            child: const Icon(Icons.add),
          ),
          const SizedBox(width: 14,),
          FloatingActionButton(
            onPressed: (){

              _firebaseFirestore.collection('movies').doc('new-doc-1').delete();
            },
            child: const Icon(Icons.delete_outline),
          ),
        ],
      ),
    );
  }
}

class Movie{
  final String id, name, year, language, ratings;

  Movie(
      {required this.id,
      required this.name,
      required this.year,
      required this.language,
      required this.ratings,
      });

  factory Movie.fromJson(String id, Map<String, dynamic> json){
    return Movie(
        id: id,
        name: json['name'] ?? '',
        year: json['year'] ?? '',
        language: json['languages'] ?? '',
        ratings: json['ratings'] ?? 'Unknown',
    );
  }
}
