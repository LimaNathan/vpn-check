import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:trust_location/trust_location.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _latitude;
  String? _longitude;
  bool? _isMockLocation;
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    super.initState();
    requestLocationPermission();
    getLocation();
    TrustLocation.start(5);
  }

  Future<void> getLocation() async {
    try {
      TrustLocation.onChange.listen((event) => setState(() {
            _latitude = event.latitude;
            _longitude = event.longitude;
            _isMockLocation = event.isMockLocation;
            print(event);
          }));
    } on PlatformException catch (e) {
      print('PlatformException $e');
    }
  }

  void requestLocationPermission() async {
    PermissionStatus permission = await Permission.location.request();
    print('permissions: $permission');
  }

  @override
  void dispose() {
    TrustLocation.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trust Location Plugin')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Mock Location: $_isMockLocation'),
            Text('Latitude: $_latitude, Longitude: $_longitude'),
          ],
        )),
      ),
    );
  }
}
