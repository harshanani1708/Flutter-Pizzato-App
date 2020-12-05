import 'package:flutter/material.dart';
import 'package:pizzato/model/model.dart';
import 'package:provider/provider.dart';
import 'package:snack/snack.dart';

Widget itemImage(String url) {
  return Center(
    child: Container(
      padding: EdgeInsets.only(top: 10.0),
      height: 320.0,
      width: 320.0,
      child: Image.network(url),
    ),
  );
}

class RatingandProduct extends StatefulWidget {
  String category;
  String name;
  String price;
  String rating;

  RatingandProduct({this.category, this.name, this.price, this.rating});
  @override
  _RatingandProductState createState() => _RatingandProductState();
}

class _RatingandProductState extends State<RatingandProduct> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.star, color: Colors.yellow),
              SizedBox(
                width: 8.0,
              ),
              Text(
                widget.rating == null ? "4.5" : '${widget.rating}',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
          SizedBox(
            height: 8.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.category}',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 35.0),
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  Text(
                    '${widget.name}',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 35.0),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Text(
                  "Rs." + "${widget.price}",
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 35.0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ExtraService extends StatefulWidget {
  String category;
  String name;
  String price;
  String imageUrl;

  ExtraService({this.category, this.name, this.imageUrl, this.price});

  @override
  _ExtraServiceState createState() => _ExtraServiceState();
}

class _ExtraServiceState extends State<ExtraService> {
  int cheeseCount;
  int onionCount;
  int beaconCount;
  String selected;

  void initState() {
    cheeseCount = 0;
    onionCount = 0;
    beaconCount = 0;
    // selected = "small";
  }

  @override
  Widget build(BuildContext context) {
    final barFail = SnackBar(
      content: Text("PLEASE SELECT THE SIZE",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          )),
      backgroundColor: Colors.red,
      duration: Duration(
        seconds: 1,
      ),
    );
    final barSuccess = SnackBar(
      content: Text('Item Successfully Added into Cart',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          )),
      duration: Duration(
        seconds: 1,
      ),
      backgroundColor: Colors.green[300],
    );
    var obj = Provider.of<Cart>(context);
    return Stack(
      overflow: Overflow.visible,
      children: [
        Container(
          height: 285.0,
          width: 410.0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 5,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                )
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 25.0, left: 13.0),
                child: Text("ADD MORE STUFF",
                    style: TextStyle(
                      fontSize: 27.0,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 60.0),
                      child: Container(
                        child: Text(
                          "CHEESE",
                          style: TextStyle(fontSize: 22.0),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 122.0,
                    ),
                    Container(
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                cheeseCount = cheeseCount - 1;
                              });
                            },
                            child: Icon(
                              Icons.remove,
                              size: 30.0,
                            ),
                          ),
                          SizedBox(
                            width: 7.0,
                          ),
                          Text(
                            cheeseCount < 0 ? "0" : cheeseCount.toString(),
                            style: TextStyle(
                              fontSize: 22.0,
                            ),
                          ),
                          SizedBox(
                            width: 7.0,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                cheeseCount = cheeseCount + 1;
                              });
                            },
                            child: Icon(
                              Icons.add,
                              size: 30.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 60.0),
                      child: Container(
                        child: Text(
                          "ONION",
                          style: TextStyle(
                            fontSize: 22.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 130.0,
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                onionCount = onionCount - 1;
                              });
                            },
                            child: Icon(
                              Icons.remove,
                              size: 30.0,
                            ),
                          ),
                          SizedBox(
                            width: 7.0,
                          ),
                          Text(
                            onionCount < 0 ? "0" : onionCount.toString(),
                            style: TextStyle(
                              fontSize: 22.0,
                            ),
                          ),
                          SizedBox(
                            width: 7.0,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                onionCount = onionCount + 1;
                              });
                            },
                            child: Icon(
                              Icons.add,
                              size: 30.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 60.0),
                      child: Container(
                        //color: Colors.redAccent,
                        width: 100.0,
                        height: 30.0,
                        child: Text(
                          "BEACON",
                          style: TextStyle(
                            fontSize: 22.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 100.0,
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                beaconCount = beaconCount - 1;
                              });
                            },
                            child: Icon(
                              Icons.remove,
                              size: 30.0,
                            ),
                          ),
                          SizedBox(
                            width: 7.0,
                          ),
                          Text(
                            beaconCount < 0 ? "0" : beaconCount.toString(),
                            style: TextStyle(
                              fontSize: 22.0,
                            ),
                          ),
                          SizedBox(
                            width: 7.0,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                beaconCount = beaconCount + 1;
                              });
                            },
                            child: Icon(
                              Icons.add,
                              size: 30.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 32.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 13.0),
                child: GestureDetector(
                  onTap: () {
                    //Cart obj = new Cart();

                    if (selected == null) {
                      barFail.show(context);
                    } else {
                      obj.addtoCart(CartModel(
                        name: widget.category + " " + widget.name,
                        cheeseCount: cheeseCount.toString(),
                        beaconCount: beaconCount.toString(),
                        onionCount: onionCount.toString(),
                        imageUrl: widget.imageUrl,
                        price: widget.price,
                        size: selected,
                      ));
                      barSuccess.show(context);
                    }
                  },
                  child: Container(
                    width: 250.0,
                    height: 45.0,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Center(
                        child: Text(
                      "ADD TO CART",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                  ),
                ),
              )
            ],
          ),
        ),
        Positioned(
          bottom: 265.0,
          left: 40.0,
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selected = "small";
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: selected == "small"
                          ? Colors.blue[300]
                          : Colors.redAccent,
                      borderRadius: BorderRadius.circular(13.0),
                    ),
                    height: 40.0,
                    width: 40.0,
                    child: Center(child: Text("S")),
                  ),
                ),
                SizedBox(
                  width: 100.0,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selected = "medium";
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: selected == "medium"
                          ? Colors.blue[300]
                          : Colors.redAccent,
                      borderRadius: BorderRadius.circular(13.0),
                    ),
                    height: 40.0,
                    width: 40.0,
                    child: Center(child: Text("M")),
                  ),
                ),
                SizedBox(
                  width: 108.0,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selected = "large";
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: selected == "large"
                          ? Colors.blue[300]
                          : Colors.redAccent,
                      borderRadius: BorderRadius.circular(13.0),
                    ),
                    height: 40.0,
                    width: 40.0,
                    child: Center(child: Text("L")),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
