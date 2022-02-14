import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:toko_ada/model/config.dart';
import 'package:toko_ada/model/user.dart';
import 'package:http/http.dart' as http;

import 'checkoutpage.dart';

class CartPage extends StatefulWidget {
  final User user;
  const CartPage({Key? key, required this.user}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double temp = 0.0, total = 0.0;
  List productlist = [];
  int productcount = 0;
  String titlecenter = "Loading data...";

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.shade100,
      body: productlist.isEmpty
            ? Center(
                child: Text(titlecenter,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)))
            : Builder(
        builder: (context) {
          return ListView(
            children: <Widget>[createCartList(), footer(context)],
          );
        },
      ),
    );
  }

  footer(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(left: 30),
                child: const Text(
                  "Total",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 30),
                child: Text("Rp. " + 
                  total.toStringAsFixed(2),
                  style: TextStyle(
                      color: Colors.orangeAccent.shade700, fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          MaterialButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CheckOutPage(user: widget.user)));
            },
            color: Colors.orange,
            padding:
                const EdgeInsets.only(top: 12, left: 60, right: 60, bottom: 12),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(24))),
            child: const Text(
              "Checkout",
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
      margin: const EdgeInsets.only(top: 16),
    );
  }

  createCartList() {
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemBuilder: (context, position) {
        return createCartListItem(position);
      },
      itemCount: productcount,
    );
  }

  createCartListItem(int index) {
    return Stack(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(16))),
          child: Row(
            children: <Widget>[
              Container(
                margin:
                    const EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 8),
                width: 80,
                height: 80,
                child: CachedNetworkImage(
                  imageUrl: Config.server +
                      "images/products/" +
                      productlist[index]['prid'] +
                      ".png",
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.image_not_supported,
                    size: 128,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(right: 8, top: 4),
                        child: Text(
                          productlist[index]['prname'],
                          maxLines: 2,
                          softWrap: true,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Rp. " + 
                            double.parse(productlist[index]['prprice']).toStringAsFixed(2),
                            style: const TextStyle(color: Colors.orange),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  iconSize: 20,
                                  color: Colors.grey.shade700,
                                  onPressed: () => {_updateOrder(index,'-')},
                                ),
                                Container(
                                  color: Colors.grey.shade200,
                                  padding: const EdgeInsets.only(
                                      top: 2, bottom: 2, right: 8, left: 8),
                                  child: Text(
                                    productlist[index]['prqntty'],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  iconSize: 20,
                                  color: Colors.grey.shade700,
                                  onPressed: () => {_updateOrder(index,'+')},
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                flex: 100,
              )
            ],
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            margin: const EdgeInsets.only(right: 10, top: 8),
            child: IconButton(
              icon: const Icon(Icons.close),
              color: Colors.white,
              iconSize: 20,
              onPressed: () => {_deleteItem(index)},
              padding: const EdgeInsets.all(1.0)
            ),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                color: Colors.orange),
          ),
        )
      ],
    );
  }

  void _deleteItem(int index) {print(productlist[index]['orid']);
    http.post(Uri.parse(Config.server + "php/update_order.php"),
        body: {"orid": productlist[index]['orid']}).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        print(response.body);
        _loadCart();
      } else {
          print(response.body);
      }
    });
  }

  void _updateOrder(int index, String symbol) {
    int prqntty;
    switch(symbol) {
      case '+': prqntty = int.parse(productlist[index]['prqntty']) + 1; break;
      case '-': prqntty = int.parse(productlist[index]['prqntty']) - 1; break;
      default: prqntty = int.parse(productlist[index]['prqntty']);
    }
    if(prqntty > 0 && prqntty <= int.parse(productlist[index]['prstock'])) {
        setState(() {
          productlist[index]['prqntty'] = prqntty.toString();
          total = 0.0;
          for (int i = 0; i < productcount; i++) {
            temp = double.parse(productlist[i]['prqntty']) *
                double.parse(productlist[i]['prprice']);
            total = total + temp;
          }
        });
        http.post(Uri.parse(Config.server + "php/update_order.php"),
        body: {
          "orid": productlist[index]['orid'],
          "prqntty": prqntty.toString()
          }).then((response) {
        var data = jsonDecode(response.body);
        if (response.statusCode == 200 && data['status'] == 'success') {
          print(response.body);
        } else {
            print("Failed");
        }
      });
    }
  }

  void _loadCart() {
    http.post(Uri.parse(Config.server + "php/load_cart.php"),
        body: {"userid": widget.user.id}).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        print(response.body);
        var extractdata = data['data'];
        setState(() {
          productlist = extractdata["products"];
          productcount = productlist.length;
          total = 0.0;
          for (int i = 0; i < productcount; i++) {
            temp = double.parse(productlist[i]['prqntty']) *
                double.parse(productlist[i]['prprice']);
            total = total + temp;
          }
        });
      } else {
        setState(() {
          titlecenter = "No Data";
        });
      }
    });
  }

  String truncateString(String str) {
    if (str.length > 10) {
      str = str.substring(0, 10);
      return str + "...";
    } else {
      return str;
    }
  }
}
