import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pizzato/model/locationmodel.dart';
import 'package:pizzato/model/model.dart';
import 'package:pizzato/views/cartPage.dart';
import 'package:pizzato/widgets/homepageWidgtes.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var newLatitude;
  var newLongitude;
  var newAddress;
  var position;

  var obj;

  void initState() {
    super.initState();

    getLocation();
    obj = Provider.of<LocationModel>(context, listen: false);
  }

  getLocation() async {
    //var geolocator = Geolocator();
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // print(position.latitude);
    //print(position.longitude);
    setState(() {
      newLatitude = position.latitude;
      newLongitude = position.longitude;
    });
    getAddressFromCoordinates(newLatitude, newLongitude);
  }

  getAddressFromCoordinates(latitude, longitude) async {
    var coordinates = new Coordinates(latitude, longitude);

    var locationAddress =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);

    setState(() {
      newAddress = locationAddress;
    });

    obj.setAddress(newAddress[0].addressLine);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: newAddress == null
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 6.0,
                  ),
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: AppBarHomePage(address: newAddress),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 95.0, top: 30.0),
                      child: heading(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0, left: 15.0),
                      child: Container(
                          //width: 100.0,
                          height: 50.0,
                          child: itemsList()),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25.0, right: 200.0),
                      child: favouriteHeading(),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10.0),
                      height: 310.0,
                      child: foodCards(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25.0, right: 200.0),
                      child: businessHeading(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 0.0, top: 12.0),
                      child: businessCards(),
                    ),
                  ],
                ),
              ),
        floatingActionButton: Consumer<Cart>(builder: (context, cart, child) {
          return Badge(
            badgeColor: Colors.redAccent,
            position: BadgePosition(
              bottom: 32.0,
              start: 31.0,
            ),
            badgeContent: Container(
              height: 40.0,
              width: 18.0,
              child: Center(
                child: Text(
                  "${cart.count}",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            child: FloatingActionButton(
              backgroundColor: Colors.redAccent,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return CartPage();
                }));
              },
              child: Icon(
                Icons.add_shopping_cart,
                color: Colors.white,
                size: 30.0,
              ),
            ),
          );
        }),
      ),
    );
  }
}
