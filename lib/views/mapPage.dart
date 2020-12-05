import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/services/base.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pizzato/model/locationmodel.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<Marker> mymarker = [];
  var newLatitude;
  var newLongitude;
  var newAddress;
  bool loading;
  var obj;
  void initState() {
    getCurrentLocation();
    obj = Provider.of<LocationModel>(context, listen: false);
  }

  getCurrentLocation() async {
    setState(() {
      loading = true;
    });
    var position = await Geolocator.getCurrentPosition();

    setState(() {
      newLatitude = position.latitude;
      newLongitude = position.longitude;
      loading = false;
    });

    getAddress(newLatitude, newLongitude);
  }

  handleTap(LatLng tappedposition) {
    setState(() {
      mymarker = [];
      final markerId = MarkerId(tappedposition.toString());
      mymarker.add(Marker(
          markerId: markerId,
          position: tappedposition,
          draggable: true,
          onDragEnd: (dragend) {
            print(dragend);
          }));
    });
    setState(() {
      newLatitude = tappedposition.latitude;
      newLongitude = tappedposition.longitude;
    });

    print(newLatitude);
    print(newLongitude);

    getAddress(newLatitude, newLongitude);
  }

  getAddress(double latitude, double longitude) async {
    var coordinates = new Coordinates(latitude, longitude);
    print(coordinates);
    var locationAddress =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);

    print(locationAddress);
    setState(() {
      mymarker = [];
      mymarker.add(Marker(
          markerId: MarkerId(latitude.toString() + longitude.toString()),
          position: LatLng(latitude, longitude),
          draggable: true,
          onDragEnd: (dragend) {
            print(dragend);
          }));
    });

    setState(() {
      newAddress = locationAddress;
    });

    print(newAddress[0].addressLine);

    obj.setAddress(newAddress[0].addressLine);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationModel>(builder: (context, location, child) {
      return SafeArea(
        child: Scaffold(
          body: loading == true
              ? Center(
                  child: Container(
                    child: CircularProgressIndicator(
                      strokeWidth: 6.0,
                    ),
                  ),
                )
              : Stack(
                  children: [
                    GoogleMap(
                      initialCameraPosition: CameraPosition(
                          target: LatLng(newLatitude, newLongitude),
                          zoom: 14.0),
                      markers: Set.from(mymarker),
                      onTap: handleTap,
                      mapType: MapType.hybrid,
                    ),
                    newAddress == null
                        ? Container()
                        : Positioned(
                            top: 670.0,
                            left: 30.0,
                            child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                width: 300.0,
                                height: 118.0,
                                padding: EdgeInsets.only(left: 20.0),
                                child: Center(
                                  child: Text(
                                    location.getAddress(),
                                    // overflow: TextOverflow.,
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )),
                          ),
                    Positioned(
                      top: 10.0,
                      left: 380.0,
                      child: Container(
                        color: Colors.blueGrey,
                        child: GestureDetector(
                          onTap: () {
                            getCurrentLocation();
                          },
                          child: Icon(
                            Icons.my_location,
                            color: Colors.lightBlue[100],
                            size: 45.0,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
        ),
      );
    });
  }
}
