import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:toko_ada/model/config.dart';
import 'package:toko_ada/model/user.dart';
import 'package:http/http.dart' as http;

import '../mainpage.dart';

class ConfirmPayment extends StatefulWidget {
  final User user;
  final String bankAccount;
  const ConfirmPayment(
      {Key? key, required this.user, required this.bankAccount})
      : super(key: key);

  @override
  _ConfirmPaymentState createState() => _ConfirmPaymentState();
}

class _ConfirmPaymentState extends State<ConfirmPayment> {
  String paymentMethod = "";
  @override
  Widget build(BuildContext context) {
    paymentMethod = "Delivery & Transfer (" + widget.bankAccount + ")";
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.orange,
        ),
      ),
      title: 'Confirm Payment',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Confirm Payment'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  widget.bankAccount +
                      " Number: " +
                      _bankAccountNum(widget.bankAccount),
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
              MaterialButton(
                height: 50,
                onPressed: () => {_paymentConfirmed()},
                child: const Text(
                  "I've Transfered The Money",
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                color: Colors.orange,
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _bankAccountNum(String bankAccount) {
    String num;
    switch (bankAccount) {
      case "BSI":
        num = "06543935";
        break;
      case "BNI":
        num = "07539639";
        break;
      case "BRI":
        num = "01358693";
        break;
      case "OVO":
        num = "02516748";
        break;
      case "Dana":
        num = "08832547";
        break;
      default:
        num = "";
    }
    return num;
  }

  _paymentConfirmed() {
    http.post(Uri.parse(Config.server + "php/update_order.php"), body: {
      "userid": widget.user.id,
      "payment_method": paymentMethod,
      "ordstatus": "order sent"
    }).then((response) {
      var data = jsonDecode(response.body);
      print(data);
      if (response.statusCode == 200 && data['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Success",
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
  }
}
