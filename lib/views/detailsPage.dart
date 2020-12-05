import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:pizzato/model/model.dart';
import 'package:pizzato/views/cartPage.dart';
import 'package:pizzato/widgets/detailsPageWidgets.dart';
import 'package:provider/provider.dart';

class ItemDetailsPage extends StatefulWidget {
  String imageUrl;
  String category;
  String name;
  String price;
  String rating;

  ItemDetailsPage(
      {this.category, this.imageUrl, this.name, this.price, this.rating});
  @override
  _ItemDetailsPageState createState() => _ItemDetailsPageState();
}

class _ItemDetailsPageState extends State<ItemDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          itemImage(widget.imageUrl),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: RatingandProduct(
                category: widget.category,
                name: widget.name,
                price: widget.price,
                rating: widget.rating),
          ),
          SizedBox(
            height: 32.0,
          ),
          ExtraService(
            name: widget.name,
            category: widget.category,
            price: widget.price,
            imageUrl: widget.imageUrl,
          ),
        ],
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
            ),
          ),
        );
      }),
    ));
  }
}
