
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'fingerprint_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? profile;
  Position? position;
  String location = 'Null, Press Button';
  String Address = 'Address';

  void getingPosition() async {
    position = await _determinePosition();
    location = 'Lat: ${position!.latitude} , Long:${position!.longitude}';
    GetAdreessFromLatLong(position!);

    print(position!.latitude);
  }

  Future<void> GetAdreessFromLatLong(Position postion) async {
    List<Placemark> placemark =
        await placemarkFromCoordinates(postion.latitude, postion.longitude);
    print(placemark);
    Placemark place = placemark[0];
    setState(() {
      Address = '${place.locality} , ${place.postalCode} ,${place.country}';
    });
  }

  final picker = ImagePicker();

  @override
  void initState() {
    // TODO: implement initState

    pickProfile(ImageSource.camera);
    getingPosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xFFAD3436),
          centerTitle: true,
          title: Text('Conform Details'),
        ),
        body: Padding(
          padding: EdgeInsets.all(32),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    pickProfile(ImageSource.camera);
                  },
                  child: Row(
                    children: [
                      Text(
                        'Selfie :   ',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w700),
                      ),
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (builder) => profileBottomSheet());
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          child: profile != null
                              ? Image.file(profile!)
                              : Icon(Icons.camera),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                if (Address != null)
                  Row(
                    children: [
                      Text(
                        'Address',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w700),
                      ),
                      Text("    ${Address}")
                    ],
                  ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(
                      'Login Time',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w700),
                    ),
                    Text("    ${DateTime.now().toString().split('.')[0]}")
                  ],
                ),
                SizedBox(height: 48),
                buildLogoutButton(context)
              ],
            ),
          ),
        ),
      );

  Widget buildLogoutButton(BuildContext context) => ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Color(0xFFAD3436),
        minimumSize: Size.fromHeight(50),
      ),
      child: Text(
        'Conform Details',
        style: TextStyle(fontSize: 20),
      ),
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => FingerprintPage()));
      });

  void pickProfile(ImageSource source) async {
    final XFile? pickerFile = await ImagePicker().pickImage(source: source);
    setState(() {
      profile = File(pickerFile!.path);
    });
  }

  Widget profileBottomSheet() {
    return Container(
      padding: const EdgeInsets.only(
        top: 30,
      ),
      height: 150,
      width: double.infinity,
      //color: Colors.grey,
      child: Column(
        children: [
          Text(
            "Upload Selfie",
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                onPressed: () {
                  pickProfile(ImageSource.camera);
                },
                icon: Icon(
                  Icons.camera,
                ),
                label: Text(
                  "Camera",
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
