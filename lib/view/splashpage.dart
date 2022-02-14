import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:toko_ada/model/config.dart';
import 'package:toko_ada/model/user.dart';
import 'package:toko_ada/view/loginpage.dart';
import 'package:toko_ada/view/mainpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    checkAndLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 50, bottom: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            Image(image: AssetImage('assets/images/toko_ada_icon.png')),
            CircularProgressIndicator(),
            Text(
              "Version 0.1",
            ),
          ],
        ),
      ),
    );
  }

  checkAndLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    late User user;
    if (email.length > 1 && password.length > 1) {
      http.post(Uri.parse(Config.server + "php/login_user.php"),
          body: {"email": email, "password": password}).then((response) {
        if (response.statusCode == 200 && response.body != "failed") {
          final jsonResponse = json.decode(response.body);
          user = User.fromJson(jsonResponse);
          Timer(
              const Duration(seconds: 3),
              () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (content) => MainPage(user: user, currentIndex: 0))));
        } else {
          user = User(
              id: "na",
              level: "na",
              name: "na",
              email: "na",
              phone: "na",
              address: "na",
              regdate: "na");
          Timer(
              const Duration(seconds: 3),
              () => Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (content) => const LoginPage())));
        }
      }).timeout(const Duration(seconds: 5));
    } else {
      user = User(
        id: "na",
        level: "na",
        name: "na",
        email: "na",
        phone: "na",
        address: "na",
        regdate: "na",
      );
      Timer(
          const Duration(seconds: 3),
          () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (content) => const LoginPage())));
    }
  }
}
