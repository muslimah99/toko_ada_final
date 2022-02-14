import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:toko_ada/model/config.dart';
import 'package:toko_ada/model/user.dart';
import 'package:http/http.dart' as http;

import '../mainpage.dart';

class MyOrderPage extends StatefulWidget {
  final User user;
  const MyOrderPage({Key? key, required this.user}) : super(key: key);

  @override
  _MyOrderPageState createState() => _MyOrderPageState();
}

class _MyOrderPageState extends State<MyOrderPage> {
  List productlist = [];
  int productcount = 0;
  String titlecenter = "Loading data...";

  @override
  void initState() {
    super.initState();
    _loadOrder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (content) =>
                          MainPage(user: widget.user, currentIndex: 2)));
            }),
        title: const Text(
          "My Order",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: productlist.isEmpty
          ? Center(
              child: Text(titlecenter,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)))
          : Builder(
              builder: (context) {
                return ListView(
                  children: <Widget>[createCartList()],
                );
              },
            ),
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
                      const SizedBox(height: 10),
                      Text(
                        productlist[index]['prqntty'] +
                            " x Rp. " +
                            double.parse(productlist[index]['prprice'])
                                .toStringAsFixed(2),
                        style: const TextStyle(color: Colors.orange),
                      ),
                      const SizedBox(height: 10),
                      Text("Order Date: " + productlist[index]['ordate']),
                      const SizedBox(height: 10),
                      Text("Order Status: " + productlist[index]['ordstatus'], 
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                flex: 100,
              )
            ],
          ),
        ),
      ],
    );
  }

  void _loadOrder() {
    http.post(Uri.parse(Config.server + "php/load_order.php"), body: {
      "userid": widget.user.id,
      "order": "order detail"
    }).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        print(response.body);
        var extractdata = data['data'];
        setState(() {
          productlist = extractdata["products"];
          productcount = productlist.length;
        });
      } else {
        print("No Data");
      }
    });
  }
}
