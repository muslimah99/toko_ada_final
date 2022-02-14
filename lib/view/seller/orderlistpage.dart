import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:toko_ada/view/seller/orderdetail.dart';
import 'package:toko_ada/model/config.dart';
import 'package:toko_ada/model/user.dart';
import 'package:http/http.dart' as http;

class OrderListPage extends StatefulWidget {
  final User user;
  const OrderListPage({Key? key, required this.user}) : super(key: key);

  @override
  _OrderListPageState createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  List orderlist = [];
  int ordercount = 0;
  String titlecenter = "Loading data...";

  @override
  void initState() {
    super.initState();
    _loadOrder();
  }
  
  @override
  Widget build(BuildContext context) {
    if(orderlist.isEmpty) {
      return Center(
              child: Text(titlecenter,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)));
    } else {
      return ListView(
            children: <Widget>[createOrderList()],
          );
    } 
  }

  createOrderList() {
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemBuilder: (context, position) {
        return createOrderListItem(position);
      },
      itemCount: ordercount,
    );
  }

  createOrderListItem(int index) {
    return Container(
      padding: EdgeInsets.all(5),
      height: 100,
      width: double.maxFinite,
      child: Card(
        elevation: 5,
        child: InkWell(
          onTap: () => {_orderDetails(index)},
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Text("Name: " + orderlist[index]["uname"]),
                  Text("Address: " + orderlist[index]["address"])
                ],
              ),
            )
          ),
        )
      ),
    );
  }

  _loadOrder() {
    http.post(Uri.parse(Config.server + "php/load_order.php"),
        body: {
          "order": "user order"
          }).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        print(response.body);
        var extractdata = data['data'];
        setState(() {
          orderlist = extractdata["users"];
          ordercount = orderlist.length;
        });
      } else {
          print("No Data");
      }
    });
  }

  _orderDetails(int index) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => OrderDetail(
                  userid: orderlist[index]["userid"]
                )));
  }
}
