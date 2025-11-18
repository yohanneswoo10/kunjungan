
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kunjungan/config/localDb.dart';
import 'package:kunjungan/map/user.dart';
import 'package:kunjungan/map/userDevice.dart';
import 'package:kunjungan/presenter/loginPresenter.dart';
import 'package:flutter_encrypt_plus/flutter_encrypt_plus.dart';
import '../config/latencyAppBar.dart';
import '../config/loader.dart';
import '../util/checkLogin.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/mysqlConnector.dart';
import 'homePage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> implements LoginPageContract{

  List<User> users = [new User("banindo","banindo","0")];
  UserDevice ud = new UserDevice("", "", "");
  TextEditingController _user = TextEditingController();
  TextEditingController _pass = TextEditingController();
  String _status = "0";
  String salt = "banindo";
  LoginPagePresenter? _presenter;
  bool _isLoading = false;

  void _showSnackBar(String text) {
    /*scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(text),
    ));*/
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: new Text(text),));
  }

  void _submit(String username) async
  {
    setState(() {
      _isLoading = true;
    });
    String encodedString = encrypt.encodeString(_pass!.text, salt);

    String pass = await username.getPassword();

    if(encodedString == pass) {
      saveLoginState(true, username, encodedString);
      _showSnackBar("Login Success");
      //Navigate to HOME PAge
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    }
  }

  // To save login state
  Future<void> saveLoginState(bool isLoggedIn, String username, String pass) async {
    final prefs = await SharedPreferences.getInstance();
    final deviceInfo = DeviceInfoPlugin();
    String? device;
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      device = androidInfo.model;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      device = iosInfo.model;
    }
    ud = UserDevice(username, device!, "toServer");
    var db = localDb();
    db.addUserDevice(ud);
    await prefs.setString("device", device!);
    await prefs.setBool('isLoggedIn', isLoggedIn);
    await prefs.setString("user", username);
    await prefs.setString("pass", pass);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: LatencyAppBar(title: 'LOG IN',),
      body:Stack(
          children: <Widget> [
            formScreen(),
            Container(
                alignment: Alignment.center,
                child: _isLoading ? Loader(isCustom: true, loadingTxt: 'Please Wait...') : Container()
            ),
          ]
      )

    );
  }

  Widget formScreen() {
    return
      Positioned(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Center(
                child: Container(
                    width: 200,
                    height: 150,
                    /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                    child: Image.asset('asset/img/bjm.png')),
              ),
            ),
            Container(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left:15.0,right: 15.0,top:25,bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: _user,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Enter valid email id as abc@gmail.com'),
              ),
            ),
            Container(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 35),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: _pass,
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter secure password'),
              ),
            ),
            Container(
              height: 50,
              width: 150,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: TextButton(
                onPressed: () {
                  _submit(_user.text.toString());
                },
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),

          ],
        ),
      )
      );
  }

  @override
  void onLoginError(String error) {
    // TODO: implement onLoginError
    print("Login Error");
    _showSnackBar(error);
  }

  @override
  void onLoginSuccess(User user) async {
    // TODO: implement onLoginSuccess
    print("Login Success");
    _showSnackBar("Login Success");
    //Navigate to login screen
    //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(title: 'CML HOME')));
  }
}



