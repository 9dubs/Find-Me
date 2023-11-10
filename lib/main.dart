import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ar_quido/ar_quido.dart';
import 'package:majorfluttertest/screens/nav_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.camera.request();
  await _checkLocationPermission();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);
  SystemChrome.setSystemUIChangeCallback((systemOverlaysAreVisible) async {
    if (systemOverlaysAreVisible) {
      await Future.delayed(const Duration(seconds: 2));
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);
    }
  });

  runApp(const MyApp());
}

Future<void> _checkLocationPermission() async {
  final status = await Permission.locationWhenInUse.status;
  if (!status.isGranted) {
    await Permission.locationWhenInUse.request();
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _HomeState();
}

class _HomeState extends State<MyApp> {
  String? _recognizedImage;

  void _onImageDetected(BuildContext context, String? imageName) {
    if (imageName != null && _recognizedImage != imageName) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Recognized image: $imageName'),
          duration: const Duration(milliseconds: 100),
        ),
      );
    }
    setState(() {
      _recognizedImage = imageName;
    });
  }

  void _onDetectedImageTapped(BuildContext context, String? imageName) {
    if (imageName != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tapped on image: $imageName'),
          duration: const Duration(milliseconds: 1500),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Find Me'),
        ),
        body: Builder(
          builder: (context) {
            return Stack(
              children: [
                ARQuidoView(
                  referenceImageNames: const [
                    'S-301',
                    'S-301(Library)',
                    'R-101',
                    'R-102',
                    'R-103',
                    'R-104',
                    'R-105',
                    'R-105',
                    'S-101',
                    'S-102',
                    'S-103',
                    'S-104',
                    'S-105',
                    'S-106',
                    'S-107',
                    'S-108',
                    'S-109',
                    'S-110',
                    'S-111',
                    'S-112',
                    'S-113',
                  ],
                  onImageDetected: (imageName) =>
                      _onImageDetected(context, imageName),
                  onDetectedImageTapped: (imageName) =>
                      _onDetectedImageTapped(context, imageName),
                ),
                Positioned(
                  bottom: 0,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Hi there!',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 20),
                              const Text('You are currently near:'),
                              Text(
                                  _recognizedImage ??
                                      "locating your position...",
                                  style: const TextStyle(color: Colors.indigo)),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                  onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => const ShowNav())),
                                  style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.all(20)),
                                  child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('Where do you wanna go today?'),
                                      ])),
                            ]),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
