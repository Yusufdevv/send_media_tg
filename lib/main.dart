import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:send_media_to_tg/camera_bottomsheet.dart';
import 'package:send_media_to_tg/map_page.dart';
import 'package:send_media_to_tg/service.dart';
import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
  final ImagePicker imagePicker = ImagePicker();

  late TeleDart teleDart;

  @override
  void initState() {
    tgstart();
    super.initState();
  }

  Future tgstart() async {
    var botToken = '6108612646:AAEd5_Gb2C_z-SLg-DfqUReuwDztgm37ntg';
    final username = (await Telegram(botToken).getMe()).username;
    teleDart = TeleDart(botToken, Event(username!));
    teleDart.start();
  }

  List<String> imagePath = [];
  List<String> videPath = [];
  LatLng latlng = const LatLng(0, 0);
  String manzil = '';
  int val = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 50,
            ),
            Wrap(
              children: [
                ...List.generate(
                  imagePath.length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(right: 10, bottom: 10),
                    child: Stack(children: [
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: Image.file(File(imagePath[index])),
                      ),
                      Positioned(
                          top: 0,
                          right: 4,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                                color: Colors.yellow,
                                borderRadius: BorderRadius.circular(30)),
                            child: IconButton(
                              constraints: const BoxConstraints(
                                  maxHeight: 24, maxWidth: 24),
                              padding: const EdgeInsets.all(0),
                              onPressed: () {
                                imagePath.removeAt(index);
                                setState(() {});
                              },
                              icon: const Icon(Icons.delete, color: Colors.red),
                            ),
                          ))
                    ]),
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            if (videPath.isNotEmpty)
              const Divider(
                thickness: 1,
                color: Colors.black,
              ),
            Wrap(
              children: [
                ...List.generate(
                  videPath.length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(right: 10, bottom: 10),
                    child: Stack(children: [
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: Image.file(File(videPath[index])),
                      ),
                      Positioned(
                          top: 0,
                          right: 4,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                                color: Colors.yellow,
                                borderRadius: BorderRadius.circular(30)),
                            child: IconButton(
                              constraints: const BoxConstraints(
                                  maxHeight: 24, maxWidth: 24),
                              padding: const EdgeInsets.all(0),
                              onPressed: () {
                                videPath.removeAt(index);
                                setState(() {});
                              },
                              icon: const Icon(Icons.delete, color: Colors.red),
                            ),
                          ))
                    ]),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              height: 130,
              width: double.maxFinite,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.purple)),
              child: Column(
                children: [
                  Text(
                    manzil.isEmpty ? 'Manzil tanlanmagan' : manzil,
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () async {
                      List<LatLng?> address = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MapPage(),
                          ));
                      if (address.isNotEmpty) {
                        latlng = address.first ?? const LatLng(0, 0);
                        final adrs = await Serivece.getAddress(latlng);
                        manzil = adrs;
                        setState(() {});
                      }
                    },
                    child: Container(
                      height: 44,
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.red),
                      child: const Center(
                          child: Text(
                        'Kartadan manzilni tanlash',
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'hero1',
            onPressed: () {
              if (imagePath.isEmpty && videPath.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  duration: Duration(seconds: 2),
                  content: Text("Rasm yoki video tanlanmagan"),
                ));
                return;
              }
              //! user id ni bervorirish kk
              // teleDart.sendMessage(607778212,  '==========user_id=========');
              if (imagePath.isNotEmpty) {
                for (var element in imagePath) {
                  teleDart.sendPhoto(607778212, File(element));
                }
              }
              if (videPath.isNotEmpty) {
                for (var element in videPath) {
                  teleDart.sendVideo(607778212, File(element));
                }
              }
              //! user id ni bervorirish kk
              // teleDart.sendMessage(607778212,  '==========user_id=========');
            },
            child: const Icon(Icons.send, color: Colors.black),
          ),
          const SizedBox(height: 20),
          FloatingActionButton(
            heroTag: 'hero2',
            onPressed: () async {
              await showModalBottomSheet<int>(
                      backgroundColor: Colors.transparent,
                      context: context,
                      useRootNavigator: true,
                      builder: (context) => const CameraBottomSheet())
                  .then((value) async {
                if (value != null) {
                  val = value;
                  // ignore: unrelated_type_equality_checks
                  final permission = value != 2
                      ? await getCameraPermission(Platform.isAndroid)
                      : await getPhotosPermission(Platform.isAndroid);

                  if (permission.isGranted) {
                    final imagess = await pickImageFunc(value);
                    if (val != 1) {
                      imagePath.addAll(imagess);
                    } else {
                      videPath.addAll(imagess);
                    }
                    setState(() {});
                  }
                }
              });
            },
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  Future<List<String>> pickImageFunc(int value) async {
    final imageSource = value < 2 ? ImageSource.camera : ImageSource.gallery;
    List<String> image = [];
    if (value == 0) {
      final img = await imagePicker.pickImage(source: imageSource);
      if (img != null) {
        image.add(img.path);
      }
    } else if (value == 1) {
      final img = await imagePicker.pickVideo(source: imageSource);
      if (img != null) {
        image.add(img.path);
      }
    } else {
      final img = await imagePicker.pickMultiImage();
      if (img.isNotEmpty) {
        for (var element in img) {
          image.add(element.path);
        }
      }
    }
    return image;
  }

  //!
  static Future<PermissionStatus> getCameraPermission(
      bool platformIsAndroid) async {
    if (platformIsAndroid) {
      var permission = await Permission.camera.status;
      if (!permission.isGranted) {
        permission = await Permission.camera.request();
      }
      return permission;
    }
    return PermissionStatus.granted;
  }

  static Future<PermissionStatus> getPhotosPermission(
      bool platformIsAndroid) async {
    if (platformIsAndroid) {
      Permission permissionType;

      permissionType = Permission.storage;

      var permission = await permissionType.status;
      if (!permission.isGranted) {
        permission = await permissionType.request();
      }
      return permission;
    }
    return PermissionStatus.granted;
  }
}
