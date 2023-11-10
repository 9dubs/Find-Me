import "dart:io";
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
//Step 1 - Importing Situm
import 'package:situm_flutter/sdk.dart';
import 'package:situm_flutter/wayfinding.dart';
import 'package:majorfluttertest/auth/secrets.dart';

//Step 2 - Setting credentials and building identifier
//Input here your user credentials ...
dynamic situmApiKey = '$apiKey';
// ... and the building you want visualize
const buildingIdentifier = "14741"; //your building id

class ShowNav extends StatefulWidget {
  const ShowNav({super.key});

  @override
  State<ShowNav> createState() => _ShowNav();
}

class _ShowNav extends State<ShowNav> {
  MapViewController? mapViewController;

  @override
  void initState() {
    super.initState();
    // Initialize SitumSdk class
    _useSitum();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          'Find Me',
          style: TextStyle(
            color: Colors.black54, // Set the color here
          ),
        ),
      ),
      //Step 3 - Showing the building cartography using the MapView
      body: Center(
        //MapView widget will visualize the building cartography
        child: MapView(
          key: const Key("situm_map"),
          configuration: MapViewConfiguration(
            situmApiKey: situmApiKey,
            buildingIdentifier: buildingIdentifier,
          ),
          onLoad: _onLoad,
        ),
      ),
    );
  }

  void _onLoad(MapViewController controller) {
    // Map successfully loaded: now you can register callbacks and perform
    // actions over the map.
    mapViewController = controller;
    debugPrint("Situm> wayfinding> Map successfully loaded.");
    controller.onPoiSelected((poiSelectedResult) {
      debugPrint(
          "Situm> wayfinding> Poi selected: ${poiSelectedResult.poi.name}");
    });
  }

  //Step 4 - Positioning
  void _useSitum() async {
    var situmSdk = SitumSdk();
    // Set up your credentials
    situmSdk.init();
    situmSdk.setApiKey(situmApiKey);
    // Set up location callbacks:
    situmSdk.onLocationUpdate((location) {
      debugPrint(
          "Situm> sdk> Location updated: ${location.toMap().toString()}");
    });
    situmSdk.onLocationStatus((status) {
      debugPrint("Situm> sdk> Status: $status");
    });
    situmSdk.onLocationError((error) {
      debugPrint("Situm> sdk> Error: ${error.message}");
    });
    // Check permissions:
    var hasPermissions = await _requestPermissions();
    if (hasPermissions) {
      // Happy path: start positioning using the default options.
      // The MapView will automatically draw the user location.
      situmSdk.requestLocationUpdates(LocationRequest());
    } else {
      // Handle permissions denial.
      debugPrint("Situm> sdk> Permissions denied!");
    }
  }

  // Requests positioning permissions
  Future<bool> _requestPermissions() async {
    var permissions = <Permission>[
      Permission.locationWhenInUse,
    ];
    if (Platform.isAndroid) {
      permissions.addAll([
        Permission.bluetoothConnect,
        Permission.bluetoothScan,
      ]);
    } else if (Platform.isIOS) {
      permissions.add(Permission.bluetooth);
    }
    Map<Permission, PermissionStatus> statuses = await permissions.request();
    return statuses.values.every((status) => status.isGranted);
  }
}
