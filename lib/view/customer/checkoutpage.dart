import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:toko_ada/model/config.dart';
import 'package:toko_ada/model/user.dart';
import 'package:http/http.dart' as http;

import '../mainpage.dart';
import 'confirmpayment.dart';

class CheckOutPage extends StatefulWidget {
  final User user;
  const CheckOutPage({Key? key, required this.user}) : super(key: key);

  @override
  _CheckOutPageState createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  double temp = 0.0, total = 0.0;
  List productlist = [];
  int productcount = 0, radio1 = 1, radio2 = 0, radio3 = 0;
  String paymentMethod = "Take Away & Cash";
  String selectBank = "BSI";
  List<String> bankList = ["BSI", "BNI", "BRI", "OVO", "Dana"];

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
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
            "Checkout",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Builder(builder: (context) {
          return Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: <Widget>[
                    addressSection(),
                    paymentOption(),
                    checkoutItem(),
                    priceSection()
                  ],
                ),
                flex: 90,
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: MaterialButton(
                    onPressed: () => {_checkOut()},
                    child: const Text(
                      "Place Order",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                    ),
                    color: Colors.orange,
                    textColor: Colors.white,
                  ),
                ),
                flex: 10,
              )
            ],
          );
        }),
      ),
    );
  }

  addressSection() {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: Card(
        elevation: 0,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4))),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              border: Border.all(color: Colors.grey.shade200)),
          padding: const EdgeInsets.only(left: 12, top: 8, right: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 6,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    widget.user.name.toString(),
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
              createAddressText(widget.user.address.toString(), 10),
              const SizedBox(
                height: 6,
              ),
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: "Mobile : ",
                      style:
                          TextStyle(fontSize: 15, color: Colors.grey.shade800)),
                  TextSpan(
                      text: widget.user.phone,
                      style:
                          const TextStyle(color: Colors.black, fontSize: 15)),
                ]),
              ),
              const SizedBox(
                height: 5,
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          MainPage(user: widget.user, currentIndex: 2)));
                },
                child: const Text(
                  "Edit Profile",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                color: Colors.orange,
                textColor: Colors.white,
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  createAddressText(String strAddress, double topMargin) {
    return Container(
      margin: EdgeInsets.only(top: topMargin),
      child: Text(
        strAddress,
        style: TextStyle(fontSize: 15, color: Colors.grey.shade800),
      ),
    );
  }

  paymentOption() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        border: Border.all(color: Colors.grey.withOpacity(0.4), width: 1),
        // color: Colors.grey.withOpacity(0.2)
      ),
      margin: const EdgeInsets.all(8),
      child: Column(
        children: [
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Radio(
                value: radio1,
                groupValue: 1,
                onChanged: (isChecked) {
                  setState(() {
                    radio1 = 1;
                    radio2 = 0;
                    radio3 = 0;
                    paymentMethod = "Take Away & Cash";
                  });
                },
                activeColor: Colors.grey.shade900,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Text(
                    "Take Away & Cash",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "I'll go to the store",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                    ),
                  )
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Radio(
                value: radio2,
                groupValue: 1,
                onChanged: (isChecked) {
                  setState(() {
                    radio2 = 1;
                    radio1 = 0;
                    radio3 = 0;
                    paymentMethod = "Delivery & Cash";
                  });
                },
                activeColor: Colors.grey.shade900,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Text(
                    "Delivery & Cash",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Deliver my order, I'll pay cash",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                    ),
                  )
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Radio(
                value: radio3,
                groupValue: 1,
                onChanged: (isChecked) {
                  setState(() {
                    radio3 = 1;
                    radio2 = 0;
                    radio1 = 0;
                    paymentMethod = "Delivery & Transfer";
                  });
                },
                activeColor: Colors.grey.shade900,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Text(
                    "Delivery & Transfer",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Deliver my order, I'll transfer the money",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                    ),
                  )
                ],
              ),
            ],
          ),
          Row(children: [
            const SizedBox(width: 20),
            const Text("Select Transfer Media"),
            const SizedBox(width: 5),
            DropdownButton(
              itemHeight: 60,
              value: selectBank,
              onChanged: radio3 == 1
                  ? (newValue) {
                      setState(() {
                        selectBank = newValue.toString();
                      });
                    }
                  : null,
              items: bankList.map((selectCur1) {
                return DropdownMenuItem(
                  child: Text(
                    selectCur1,
                  ),
                  value: selectCur1,
                );
              }).toList(),
            ),
          ])
        ],
      ),
    );
  }

  checkoutItem() {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: Card(
        elevation: 0,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4))),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              border: Border.all(color: Colors.grey.shade200)),
          padding:
              const EdgeInsets.only(left: 12, top: 8, right: 12, bottom: 8),
          child: ListView.builder(
            itemBuilder: (context, position) {
              return checkoutListItem(position);
            },
            itemCount: productcount,
            shrinkWrap: true,
            primary: false,
            scrollDirection: Axis.vertical,
          ),
        ),
      ),
    );
  }

  checkoutListItem(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: <Widget>[
          Container(
            width: 45,
            height: 45,
            decoration:
                BoxDecoration(border: Border.all(color: Colors.grey, width: 1)),
            child: CachedNetworkImage(
              imageUrl: Config.server +
                  "images/products/" +
                  productlist[index]['prid'] +
                  ".png",
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(
                Icons.image_not_supported,
                size: 128,
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          SizedBox(
            width: 270,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      productlist[index]['prqntty'] +
                          " x " +
                          productlist[index]['prprice'],
                      style:
                          const TextStyle(fontSize: 12, color: Colors.black)),
                  // const SizedBox(width: 150),
                  Text(
                      "Rp. " +
                          (double.parse(productlist[index]['prqntty']) *
                                  double.parse(productlist[index]['prprice']))
                              .toStringAsFixed(2),
                      style:
                          const TextStyle(fontSize: 12, color: Colors.black)),
                ]),
          )
        ],
      ),
    );
  }

  priceSection() {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: Card(
        elevation: 0,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4))),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              border: Border.all(color: Colors.grey.shade200)),
          padding:
              const EdgeInsets.only(left: 12, top: 8, right: 12, bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 4,
              ),
              Container(
                width: double.infinity,
                height: 0.5,
                margin: const EdgeInsets.symmetric(vertical: 4),
                color: Colors.grey.shade400,
              ),
              const SizedBox(
                height: 8,
              ),
              Row(children: [
                const SizedBox(width: 75),
                const Text("Total",
                    style: TextStyle(fontSize: 12, color: Colors.black)),
                const SizedBox(width: 150),
                Text("Rp. " + total.toStringAsFixed(2),
                    style: const TextStyle(fontSize: 12, color: Colors.black)),
              ]),
              const SizedBox(
                height: 8,
              ),
              Container(
                width: double.infinity,
                height: 0.5,
                margin: const EdgeInsets.symmetric(vertical: 4),
                color: Colors.grey.shade400,
              ),
              const SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }

  createPriceItem(String key, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            key,
            style: const TextStyle(
                fontSize: 12, color: Colors.black, fontWeight: FontWeight.w600),
          ),
          Text(
            value,
            style: TextStyle(color: color, fontSize: 12),
          )
        ],
      ),
    );
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
          for (int i = 0; i < productcount; i++) {
            temp = double.parse(productlist[i]['prqntty']) *
                double.parse(productlist[i]['prprice']);
            total = total + temp;
          }
        });
      } else {
        print("No Data");
      }
    });
  }

  _checkOut() {
    http.post(Uri.parse(Config.server + "php/update_order.php"), body: {
      "userid": widget.user.id,
      "payment_method": paymentMethod,
      "ordstatus": "order sent"
    }).then((response) {
      var data = jsonDecode(response.body);
      print(data);
      if (response.statusCode == 200 && data['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Order Updated",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            textColor: Colors.green,
            fontSize: 14.0);
        if (radio3 == 1) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (content) => ConfirmPayment(
                      user: widget.user, bankAccount: selectBank)));
        } else {
          http.post(Uri.parse(Config.server + "php/update_order.php"), body: {
            "userid": widget.user.id,
            "payment_method": paymentMethod,
            "ordstatus": "order sent",
            "cash": "cash"
          }).then((response) {
            var data = jsonDecode(response.body);
            print(data);
            if (response.statusCode == 200 && data['status'] == 'success') {
              Fluttertoast.showToast(
                  msg: "Order Sent",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  textColor: Colors.green,
                  fontSize: 14.0);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (content) =>
                          MainPage(user: widget.user, currentIndex: 2)));
            } else {
              Fluttertoast.showToast(
                  msg: "Failed",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  textColor: Colors.red,
                  fontSize: 14.0);
            }
          });
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (content) =>
                      MainPage(user: widget.user, currentIndex: 2)));
        }
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            textColor: Colors.red,
            fontSize: 14.0);
      }
    });
  }
}
