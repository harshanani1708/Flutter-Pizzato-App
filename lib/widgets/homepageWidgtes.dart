import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoder/geocoder.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:pizzato/model/locationmodel.dart';
import 'package:pizzato/views/detailsPage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pizzato/views/mapPage.dart';
import 'package:provider/provider.dart';

class AppBarHomePage extends StatefulWidget {
  var address;
  AppBarHomePage({this.address});
  @override
  _AppBarHomePageState createState() => _AppBarHomePageState();
}

class _AppBarHomePageState extends State<AppBarHomePage> {
  bool loading;
  var newLatitude;
  var newLongitude;
  var obj;

  void getCurrentAddress() {
    obj = Provider.of<LocationModel>(context, listen: false);
    setState(() {
      loading = true;
    });

    getLocation();
  }

  getLocation() async {
    //var geolocator = Geolocator();
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    //print(position.latitude);
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
      widget.address = locationAddress;
      loading = false;
    });

    obj.setAddress(widget.address[0].addressLine);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationModel>(builder: (context, location, child) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(
            Icons.person,
            size: 35.0,
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  getCurrentAddress();
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Icon(
                    Icons.navigation_sharp,
                    size: 35.0,
                  ),
                ),
              ),
              loading == true
                  ? Container(
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 6.0,
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) => NetworkGiffyDialog(
                                  image: Container(
                                    child: Image.network(
                                        "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fmaxaddress.files.wordpress.com%2F2019%2F06%2Flocation_animation.gif&f=1&nofb=1",
                                        fit: BoxFit.fill),
                                  ),
                                  title: Text(
                                    "Delivery Address",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22.0,
                                    ),
                                  ),
                                  description: Text(location.getAddress(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.0,
                                      )),
                                  onlyOkButton: true,
                                  onOkButtonPressed: () {
                                    Navigator.pop(context);
                                  },
                                ));
                      },
                      child: Container(
                        //color: Colors.redAccent,
                        padding: EdgeInsets.only(top: 5.0),
                        width: 180.0,
                        //height: 40.0,
                        child: Text(
                          location.getAddress(),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
            ],
          ),
          Icon(
            Icons.search,
            size: 35.0,
          ),
        ],
      );
    });
  }
}

Widget heading() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "What would you like ",
        style: TextStyle(fontSize: 31.0, color: Colors.black),
      ),
      Text(
        "to eat ?",
        style: TextStyle(
          fontSize: 31.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}

Widget itemsList() {
  List items = ["All", "Pizza", "Pasta"];
  return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Row(
          children: [
            Container(
              width: 120,
              height: 120.0,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: index == 1
                          ? Colors.red.withOpacity(0.5)
                          : index == 2
                              ? Colors.green.withOpacity(0.5)
                              : Colors.blue.withOpacity(0.5),

                      spreadRadius: 5,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ]),
              child: Center(
                child: Text(
                  items[index],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 19.0,
            )
          ],
        );
      });
}

Widget favouriteHeading() {
  return RichText(
    text: TextSpan(
        text: "Favourite  ",
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.black, fontSize: 28.0),
        children: [
          TextSpan(
              text: "dishes",
              style: TextStyle(color: Colors.grey, fontSize: 18.0))
        ]),
  );
}

Widget foodCards() {
  Stream data;
  Stream getFavouriteData() {
    data = FirebaseFirestore.instance.collection("favourite").snapshots();
    return data;
  }

  return StreamBuilder(
      stream: getFavouriteData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        return ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(
                    right: 20.0, top: 10.0, bottom: 10.0, left: 14.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ItemDetailsPage(
                        category: snapshot.data.docs[index]["category"],
                        name: snapshot.data.docs[index]["name"],
                        price: snapshot.data.docs[index]["price"],
                        rating: snapshot.data.docs[index]["ratings"],
                        imageUrl: snapshot.data.docs[index]["image"],
                      );
                    }));
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                      left: 10.0,
                    ),
                    width: 220.0,
                    height: 280.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 5,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          )
                        ]),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 180.0,
                              height: 180.0,
                              child: Image.network(
                                  snapshot.data.docs[index]["image"]),
                            ),
                            Text(
                              snapshot.data.docs[index]["category"],
                              style: TextStyle(
                                fontSize: 28.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(snapshot.data.docs[index]["name"],
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                )),
                            SizedBox(
                              height: 5.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 100.0),
                                  child: Text(
                                    snapshot.data.docs[index]["ratings"],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Text(
                                    "Rs." +
                                        ' ' +
                                        snapshot.data.docs[index]["price"],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                        Positioned(
                          top: 7.0,
                          left: 170.0,
                          child: Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            });
      });
}

Widget businessHeading() {
  return RichText(
    text: TextSpan(
        text: "Business  ",
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.black, fontSize: 28.0),
        children: [
          TextSpan(
              text: "Lunch",
              style: TextStyle(color: Colors.grey, fontSize: 18.0))
        ]),
  );
}

Widget businessCards() {
  Stream data;
  Stream getBusinessData() {
    data = FirebaseFirestore.instance.collection("business").snapshots();
    return data;
  }

  return StreamBuilder(
      stream: getBusinessData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Container(
                    child: Align(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ItemDetailsPage(
                              category: snapshot.data.docs[index]["category"],
                              name: snapshot.data.docs[index]["name"],
                              price: snapshot.data.docs[index]["price"],
                              imageUrl: snapshot.data.docs[index]["image"],
                            );
                          }));
                        },
                        child: Container(
                          height: 200.0,
                          width: 410.0,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  spreadRadius: 5,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ]),
                          child: Center(
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 30.0, top: 40.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot.data.docs[index]["category"],
                                        style: TextStyle(
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        snapshot.data.docs[index]["name"],
                                        style: TextStyle(
                                          fontSize: 22.0,
                                        ),
                                      ),
                                      Text(
                                        snapshot.data.docs[index]["price"],
                                        style: TextStyle(
                                          fontSize: 22.0,
                                          color: Colors.blueAccent,
                                        ),
                                      ),
                                      Text(
                                        "Rs." +
                                            " " +
                                            snapshot.data.docs[index]
                                                ["notPrice"],
                                        style: TextStyle(
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 20.0,
                                ),
                                Image.network(
                                    snapshot.data.docs[index]["image"])
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 28.0,
                  )
                ],
              );
            });
      });
}
