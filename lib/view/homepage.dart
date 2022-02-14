import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:toko_ada/model/config.dart';
import 'package:toko_ada/model/user.dart';
import 'package:toko_ada/model/product.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:toko_ada/view/seller/newproduct.dart';
import 'package:toko_ada/view/detailpage.dart';

class HomePage extends StatefulWidget {
  final User user;
  const HomePage({Key? key, required this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List productlist = [];
  String titlecenter = "Loading data...";
  late double screenHeight, screenWidth, resWidth;
  late ScrollController _scrollController;
  int scrollcount = 10;
  int rowcount = 2;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
      rowcount = 2;
    } else {
      resWidth = screenWidth * 0.75;
      rowcount = 3;
    }

    return Scaffold(
        body: productlist.isEmpty
            ? Center(
                child: Text(titlecenter,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)))
            : Column(
                children: [
                  Expanded(
                    child: GridView.count(
                      padding: const EdgeInsets.only(top: 10),
                      crossAxisCount: rowcount,
                      controller: _scrollController,
                      children: List.generate(scrollcount, (index) {
                        return Card(
                            child: InkWell(
                          onTap: () => {_productDetails(index)},
                          child: Column(
                            children: [
                              Flexible(
                                flex: 6,
                                child: CachedNetworkImage(
                                  width: screenWidth,
                                  fit: BoxFit.cover,
                                  imageUrl: Config.server +
                                      "images/products/" +
                                      productlist[index]['prid'] +
                                      ".png",
                                  placeholder: (context, url) =>
                                      const LinearProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                              Flexible(
                                  flex: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Column(
                                      children: [
                                        Text(
                                            truncateString(productlist[index]
                                                    ['prname']
                                                .toString()),
                                            style: TextStyle(
                                                fontSize: resWidth * 0.045,
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                            "Rp. " +
                                                double.parse(productlist[index]
                                                        ['prprice'])
                                                    .toStringAsFixed(2),
                                            style: TextStyle(
                                              fontSize: resWidth * 0.03,
                                            )),
                                        Text(
                                            "Stock: " +
                                                productlist[index]['prstock'],
                                            style: TextStyle(
                                              fontSize: resWidth * 0.03,
                                            )),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        ));
                      }),
                    ),
                  ),
                ],
              ),
        floatingActionButton: widget.user.level == "1"
            ? SpeedDial(
                animatedIcon: AnimatedIcons.menu_close,
                children: [
                  SpeedDialChild(
                      child: const Icon(Icons.add),
                      label: "New Product",
                      labelStyle: const TextStyle(color: Colors.black),
                      labelBackgroundColor: Colors.white,
                      onTap: _newProduct),
                ],
              )
            : null);
  }

  void _newProduct() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                NewProductPage(user: widget.user)));
  }

  String truncateString(String str) {
    if (str.length > 13) {
      str = str.substring(0, 13);
      return str + "...";
    } else {
      return str;
    }
  }

  void _loadProducts() {
    http.post(Uri.parse(Config.server + "php/load_products.php"),
        body: {}).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        print(response.body);
        var extractdata = data['data'];
        setState(() {
          productlist = extractdata["products"];
          if (scrollcount >= productlist.length) {
            scrollcount = productlist.length;
          }
        });
      } else {
        setState(() {
          titlecenter = "No Data";
        });
      }
    });
  }

  _productDetails(int index) {
    Product product = Product(
        prid: productlist[index]['prid'],
        prname: productlist[index]['prname'],
        prdesc: productlist[index]['prdesc'],
        prprice: productlist[index]['prprice'],
        prstock: productlist[index]['prstock']);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => DetailPage(
                  product: product, user: widget.user
                )));
  }

  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        if (productlist.length > scrollcount) {
          scrollcount = scrollcount + 10;
          if (scrollcount >= productlist.length) {
            scrollcount = productlist.length;
          }
        }
      });
    }
  }
}
