# VPN LOCATION CHECK

A Flutter project using [`trust_location`][1] package, to check if the user are using a VPN to change your current location

[1]: https://pub.dev/packages/trust_location 'trust_location'
[2]: https://pub.dev/packages/permission_handler 'trust_location'

## Explaining

First, we need to add dependency [`trust_location`][1] to `pubspec.yaml` file:

```dart
dependencies:
 trust_location: ^2.0.13
```

Next, we need to add [`permission_handler`][2] dependency

```dart
dependencies:
 permission_handler: ^10.2.0
```

Now in the `main.dart` file, declare the variables to check location and if these location is real or mock

```dart
  String? _latitude;
  String? _longitude;
  bool? _isMockLocation;
```

On sequency, we need to request access to location of device using [`permission_handler`][2] package

```dart
  void requestLocationPermission() async {
    PermissionStatus permission = await Permission.location.request();
    print('permissions: $permission');
  }
```

And here is the method that can check location

```dart
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
```

On `initState` method, call booth previously methods to start checking

```dart
  @override
  void initState() {
    super.initState();
    requestLocationPermission();
    getLocation();
  }
```

And for finish, call the method `start` on [`trust_location`][1] package to set the timing of checks

```dart
  @override
  void initState() {
    super.initState();
    requestLocationPermission();
    getLocation();
    TrustLocation.start(5);
  }
```

On screen you can show if the `_isMockLocation` is true or not and the current location

```dart
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
```
