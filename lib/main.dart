
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_project/firebase_massaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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
  void initState() {
    super.initState();
    _onScreenStart();
  }

  Future<void> _onScreenStart() async {
    LocationPermission locationPermission = await Geolocator.checkPermission();
    print(locationPermission);

    if (locationPermission == LocationPermission.whileInUse ||
        locationPermission == LocationPermission.always) {
      Position position = await Geolocator.getCurrentPosition();
      print(position);
    }else{
      LocationPermission requestStatus = await Geolocator.requestPermission();
      if (requestStatus == LocationPermission.whileInUse ||
          requestStatus == LocationPermission.always) {
        _onScreenStart();
      }else{
        print('permission denied');
      }
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Map'),
      ),
      body: /*GoogleMap(
        zoomControlsEnabled: true,
        initialCameraPosition: const CameraPosition(
          target: LatLng(24.227928802754363, 90.16462487803568),
          zoom: 17,
          bearing: 90,
          tilt: 90,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onTap: (LatLng latLng) {
          print('tap on map : Latlng $latLng');
        },
        onLongPress: (LatLng latLng) {
          print('on long press : Latlng $latLng');
        },
        *//*compassEnabled: true,
        zoomGesturesEnabled: true,
        liteModeEnabled: true,*//*
        markers: {
          Marker(
            markerId: const MarkerId('my-new-resturant'),
            position: const LatLng(23.86114041722582, 90.00732421875003),
            infoWindow: const InfoWindow(title: 'Montaj Hotel & Resturant'),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            // draggable: true,
            draggable: false,
            flat: false,
          ),
          Marker(
            markerId: const MarkerId('my-new-resturant'),
            position: const LatLng(23.863715587282346, 89.98641595244408),
            infoWindow: const InfoWindow(title: 'Montaj Hotel & Resturant'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueYellow),
            // draggable: true,
            draggable: false,
            flat: false,
          ),
          Marker(
            markerId: const MarkerId('my-new-resturant'),
            position: const LatLng(23.843769151308564, 90.01542337238789),
            infoWindow: const InfoWindow(title: 'Montaj Hotel & Resturant'),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
            // draggable: true,
            draggable: false,
            flat: false,
          ),
          Marker(
            markerId: const MarkerId('my-new-resturant'),
            position: const LatLng(23.882288286866036, 90.03135770559311),
            infoWindow: const InfoWindow(title: 'Montaj Hotel & Resturant'),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
            draggable: true,
            // draggable: false,
            flat: false,
          ),
        },
        circles: {
          Circle(
            circleId: const CircleId('new resturant'),
            center:const LatLng(24.227928802754363, 90.16462487803568),
            radius: 50,
            strokeColor: Colors.orange,
            strokeWidth: 3,
            fillColor: Colors.red.withOpacity(0.15),
          ),
        },
      ),*/
      const Center(
        child: Text('current location'),
      ),
    );
  }
}
