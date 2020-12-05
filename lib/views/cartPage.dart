import 'dart:ui';
import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:pizzato/model/locationmodel.dart';
import 'package:pizzato/model/model.dart';
import 'package:pizzato/views/homescreen.dart';
import 'package:pizzato/views/mapPage.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Razorpay _razorpay = Razorpay();
  void initState() {
    paymentInitialize();
  }

  paymentInitialize() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, paySuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
    super.initState();
  }

  void openCheckout(int amount) async {
    var options = {
      'key': 'rzp_test_zV1C08HT0GzY6A',
      'amount': amount * 100,
      'name': 'Pizzato Comp.',
      // 'description': 'Fine T-Shirt',
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print(e);
    }
  }

  void paySuccess(PaymentSuccessResponse response) {
    var obj = Provider.of<Cart>(context, listen: false);
    obj.clearList();

    showDialog(
        context: context,
        builder: (context) => NetworkGiffyDialog(
              entryAnimation: EntryAnimation.TOP_RIGHT,
              image: Image.network(
                  "https://www.legalraasta.com/wp-content/uploads/2017/06/legalraasta.gif"),
              title: Text(
                "Order Success",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onlyOkButton: true,
              description: Text(
                "Thank you for using Pizzato, Your order is on the way !!",
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              onOkButtonPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return HomePage();
                }));
              },
            ));
  }

  void handlePaymentError(PaymentFailureResponse response) {
    print("Failure");
    showDialog(
        context: context,
        builder: (context) => NetworkGiffyDialog(
              entryAnimation: EntryAnimation.TOP_RIGHT,
              image: Image.network(
                  "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fcdn.dribbble.com%2Fusers%2F107759%2Fscreenshots%2F4594246%2F15_payment-error.gif&f=1&nofb=1"),
              title: Text(
                "Payment Error",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onlyOkButton: true,
              description: Text(
                "Looks like there is a problem with your payment, Please try again after sometime.",
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              onOkButtonPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return HomePage();
                }));
              },
            ));
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    print("External Payment");
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName, timeInSecForIosWeb: 4);
  }

  @override
  Widget build(BuildContext context) {
    //var obj = Provider.of<Cart>(context, listen: false);

    return Consumer2<Cart, LocationModel>(
        builder: (context, cart, location, child) {
      String price;
      int p = cart.totalAmount;
      p = p + 20;
      price = p.toString();
      return SafeArea(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "YOUR",
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
                Text(
                  "CART",
                  style: TextStyle(
                    fontSize: 35.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                cart.cartItems.length == 0
                    ? Center(
                        child: Container(
                          padding: EdgeInsets.only(top: 90.0),
                          child: Image.network(
                            "https://vastravila.com/uploads/shopping-cart.png",
                          ),
                        ),
                      )
                    : Stack(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height - 130.0,
                            child: ListView.builder(
                                primary: false,
                                shrinkWrap: true,
                                //: ScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemCount: cart.cartItems.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    padding: EdgeInsets.only(
                                        left: 5.0, right: 5.0, top: 10),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 410.0,
                                          height: 215.0,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.3),
                                                  spreadRadius: 5,
                                                  blurRadius: 5,
                                                  offset: Offset(0, 3),
                                                )
                                              ]),
                                          child: Row(
                                            children: [
                                              Container(
                                                height: 170.0,
                                                width: 150.0,
                                                child: Image.network(cart
                                                    .cartItems[index].imageUrl),
                                              ),
                                              SizedBox(
                                                width: 18.0,
                                              ),
                                              Container(
                                                padding:
                                                    EdgeInsets.only(top: 8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 180.0),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          cart.removeItem(
                                                              index);
                                                        },
                                                        child: Icon(
                                                          Icons.delete,
                                                          color: Colors.red,
                                                          size: 30.0,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      //color: Colors.white,
                                                      //width: 290.0,
                                                      //height: 50.0,
                                                      child: Center(
                                                        child: Text(
                                                          cart.cartItems[index]
                                                              .name,
                                                          style: TextStyle(
                                                            fontSize: 20.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 5.0,
                                                    ),
                                                    Text(
                                                      "SIZE : " +
                                                          "${cart.cartItems[index].size.toUpperCase()}",
                                                      style: TextStyle(
                                                        fontSize: 15.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                        "X" +
                                                            " " +
                                                            "${cart.cartItems[index].cheeseCount}" +
                                                            " " +
                                                            "CHESSE",
                                                        style: TextStyle(
                                                          fontSize: 15.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        )),
                                                    Text(
                                                        "X" +
                                                            " " +
                                                            "${cart.cartItems[index].beaconCount}" +
                                                            " " +
                                                            "ONION",
                                                        style: TextStyle(
                                                          fontSize: 15.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        )),
                                                    Text(
                                                        "X" +
                                                            " " +
                                                            "${cart.cartItems[index].onionCount}" +
                                                            " " +
                                                            "BEACON",
                                                        style: TextStyle(
                                                          fontSize: 15.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        )),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 12.0),
                                                      child: Text(
                                                        "Rs." +
                                                            "${cart.cartItems[index].price}",
                                                        style: TextStyle(
                                                            fontSize: 22.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20.0,
                                        )
                                      ],
                                    ),
                                  );
                                }),
                          ),
                          Positioned(
                            top: 480.0,
                            left: 40.0,
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: 5,
                                        spreadRadius: 5,
                                        offset: Offset(0, 3),
                                      )
                                    ]),
                                height: 150.0,
                                width: 350.0,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Column(
                                    children: [
                                      Text(
                                          "SUBTOTAL :  " +
                                              "" +
                                              " ${cart.totalAmount}/-",
                                          style: TextStyle(fontSize: 20.0)),
                                      Text(
                                          "DELIVERY CHARGES : " + " " + " 20/-",
                                          style: TextStyle(fontSize: 20.0)),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(
                                        "TOTAL :" + " " + "${price}/-",
                                        style: TextStyle(
                                            fontSize: 30.0,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                )),
                          ),
                          Positioned(
                            top: 310.0,
                            left: 40.0,
                            child: Container(
                              width: 350.0,
                              height: 150.0,
                              decoration: BoxDecoration(
                                  // color: Colors.redAccent,

                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 5,
                                      spreadRadius: 5,
                                      offset: Offset(0, 3),
                                    )
                                  ]),
                              child: Center(
                                  child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(
                                    Icons.navigation,
                                    size: 30.0,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) =>
                                              NetworkGiffyDialog(
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
                                                description:
                                                    Text(location.getAddress(),
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15.0,
                                                        )),
                                                onlyOkButton: true,
                                                onOkButtonPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ));
                                    },
                                    child: Container(
                                      width: 190.0,
                                      color: Colors.white,
                                      child: Text(
                                        location.getAddress(),
                                        //overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return MapScreen();
                                      }));
                                    },
                                    child: Icon(
                                      Icons.edit,
                                      size: 30.0,
                                    ),
                                  )
                                ],
                              )),
                            ),
                          ),
                          Positioned(
                            top: 620.0,
                            left: 100.0,
                            child: GestureDetector(
                              onTap: () {
                                openCheckout(int.parse(price));
                              },
                              child: Container(
                                width: 240.0,
                                height: 50.0,
                                decoration: BoxDecoration(
                                  color: Colors.redAccent,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Center(
                                    child: Text(
                                  "Place order",
                                  style: TextStyle(
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                              ),
                            ),
                          )
                        ],
                      ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
