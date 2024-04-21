import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_project/firebase_massaging.dart';
import 'package:firebase_project/movie_list_screen.dart';
import 'package:firebase_project/tennis_live_score_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessagingServices.initialize();
  print(await FirebaseMessagingServices.getFCMToken());
  runApp(const MoviesApp());
}

class MoviesApp extends StatelessWidget {
  const MoviesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: MovieListScreen(),
      // home: TennisLiveScoreScreen(docId: '7',),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Map'),
      ),
      body: const GoogleMap(
        zoomControlsEnabled: true,
        initialCameraPosition: CameraPosition(
          target: LatLng(24.227928802754363, 90.16462487803568),
        ),
      ),
    );
  }
}
