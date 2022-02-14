import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:toko_ada/model/config.dart';

class OrderDetail extends StatefulWidget {
  final String userid;
  const OrderDetail({Key? key, required this.userid}) : super(key: key);

  @override
  _OrderDetailState createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  List productlist = [];
  int productcount = 0, status = 0;
  String titlecenter = "Loading data...", ordate ="";

  @override
  void initState() {
    super.initState();
    _loadOrder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: const Text(
          "Order List",
          style: TextStyle(color: Colors.black),
        ),
      ),
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
                  children: <Widget>[
                    const SizedBox(height: 20),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MaterialButton(
                              onPressed: status != 0 ? null : () => {_updateStatus(1)},
                              child: const Text("Order Received"),
                              color: Colors.orangeAccent),
                          MaterialButton(
                              onPressed: status != 1 ? null : () => {_updateStatus(2)},
                              child: const Text("Products Ready"),
                              color: Colors.orangeAccent),
                          MaterialButton(
                              onPressed: status != 2 ? null : () => {_updateStatus(3)},
                              child: const Text("Finished"),
                              color: Colors.orangeAccent),
                        ]),
                    createOrderList()
                  ],
                );
              },
            ),
    );
  }

  createOrderList() {
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemBuilder: (context, position) {
        return createOrderListItem(position);
      },
      itemCount: productcount,
    );
  }

  createOrderListItem(int index) {
    ordate = productlist[0]["ordate"];
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
                      const SizedBox(height: 10),
                      Text("Payment Method: " +
                          productlist[index]['payment_method']),
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

  footer(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          MaterialButton(
            onPressed: () {},
            color: Colors.orange,
            padding:
                const EdgeInsets.only(top: 12, left: 60, right: 60, bottom: 12),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(24))),
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
      margin: const EdgeInsets.only(top: 16),
    );
  }

  _loadOrder() {
    http.post(Uri.parse(Config.server + "php/load_order.php"), body: {
      "userid": widget.userid,
      "order": "order detail"
    }).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        print(response.body);
        var extractdata = data['data'];
        setState(() {
          productlist = extractdata["products"];
          productcount = productlist.length;
          for(var i = 0; i < productcount; i++) {
            if(productlist[i]["ordstatus"] == "order sent") {
              status = 0; break;
            } else if(productlist[i]["ordstatus"] == "order received") {
              status = 1; break;
            } else if(productlist[i]["ordstatus"] == "products ready") {
              status = 2; break;
            }
          }
        });
      } else {
        print("No Data");
      }
    });
  }

  _updateStatus(int i) {
    String ordstatus="";
    switch (i) {
      case 1: ordstatus = "order received"; break;
      case 2: ordstatus = "products ready"; break;
      case 3: ordstatus = "finished"; break;
    }
    http.post(Uri.parse(Config.server + "php/update_order.php"), body: {
      "userid": widget.userid,
      "ordstatus": ordstatus,
      "ordate": ordate
    }).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        print(response.body);
        setState(() {
          switch (i) {
            case 1: status = 1; break;
            case 2: status = 2; break;
            case 3: status = 3; break;
          }
        });
        _loadOrder();
      } else {
        print("No Data");
      }
    });
  }
}
