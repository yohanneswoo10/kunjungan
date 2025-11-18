import 'dart:async';
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:is_first_run/is_first_run.dart';
import 'package:kunjungan/pages/homePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kunjungan/config/latencyAppBar.dart';
import 'package:kunjungan/map/customer_map.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:kunjungan/config/check_internet_speed.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
//import 'package:kunjungan/config/check_mock_location.dart';
import 'package:kunjungan/config/check_gps.dart';
import 'package:quickalert/quickalert.dart';
import '../config/localDb.dart';
import '../config/location_helper.dart';
import '../config/location_track.dart';
import 'loginPage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';
import '../util/loadNsave.dart';


class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool? _isFirstRun;
  bool? _isFirstCall;
  bool isLoading = true;
  var _InetSpeed = new InternetSpeed();
  String _host = "https://banindo.co.id";
  String _loading="Loading....";

  /*Future<void> StartTrackLocation() async {
    var lokasi = new locationTrack();
    String lok = await lokasi.getLocation();
    Timer.periodic(const Duration(seconds: 5), (timer) async {
      lok = await lokasi.getLocation();
    });
    setState(() {
      _loading = lok;
    });

  }*/

  Future<void> _checkGpsActive() async {
    var _GpsActive = new checkGpsActive();
    if(!await _GpsActive.canGetLocation()){
      QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        text: "Hidupkan Lokasi Anda untuk mendapatkan Titik Lokasi yang tepat",
        title: "Warning!",
      );
    }
  }

  Future<void> _checkFirstRun() async {
    bool ifr = await IsFirstRun.isFirstRun();
    if(ifr !=null) {
      if(ifr) {
        // THIS IS FIRST TIME RUN
        //  INIT DATABASE
        var db = new localDb();
        loadnsave();
        setState(() {
          _loading="First Time Loading is " + ifr.toString();
        });
      }
      else {
        //NOT FIRST TIME RUN
        setState(() {
          _loading="First Time Loading is " + ifr.toString();
        });
      }
      //Navigate to login screen
      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage(title: 'CML Login')));
    }
  }

  void _checkFirstCall() async {
    bool ifc = await IsFirstRun.isFirstCall();
    setState(() {
      _isFirstCall = ifc;
    });
  }

  Future<void> _checkCurrentSpeed() async{

    bool _speed = await _InetSpeed.checkServerStatus(_host);
    if(_speed) {
      setState(() {
        _loading = "Server Connected";
      });
    }
    else{
      setState(() {
        _loading = "Error pinging server";
      });
      _NotConnectAlert(context, "asset/warning.png");
    }
  }

  _NotConnectAlert(context, img) {
    Alert(
      context: context,
      title: "Connection Status",
      desc: "Not Connected",
      image: Image.asset(img),
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            SystemNavigator.pop(); // Exit the application
          },
          width: 120,
        )
      ],
    ).show();
  }

  Future<void> checkMockLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    if(position.isMocked) {
      setState(() {
        _loading = "Location is Fake";
      });
      errorMockLocation();
    }else {
      setState(() {
        _loading = "Location is True";
        isLoading = false;
      });
      if(await getLoginSharePreference() == true){
        if (kDebugMode) {
          print("already login");
        }
        navigateToHome();
      }else {
        navigateToLogin();
      }

    }
    /*
    var detectMock = new detectFakeGps();
    bool isFake = await detectMock.hasFakeLocation();
    if(isFake)
    {
      setState(() {
        _loading = "Location is Fake";
      });
      errorMockLocation();
    } else {
      setState(() {
        _loading = "Location is True";
        isLoading = false;
      });
      navigateToLogin();
    }*/
  }

  void errorMockLocation() {
    AlertDialog(
      title: const Text("Exit Application"),
      content: const Text("Please make sure your GPS location is no Mock Location"),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            FlutterExitApp.exitApp(iosForceExit: true);
          },
          child: const Text("Ok"),
        ),
      ],
    );
  }
  //get customer initital data from server
  Future<void> loadnsave() async {
      var ls = new LoadNSave();
      bool isLoaded = await ls.getServerData();
      if(isLoaded){
        print("load and Save is Successfully");
      }
  }

  Future<bool?> getLoginSharePreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    int? userId = prefs.getInt('user_id');
    bool? isLoggedIn = prefs.getBool('is_logged_in');
    return isLoggedIn;
  }

  void checkRunPoint() async{
    await _checkFirstRun();
    //await Future.delayed(const Duration(seconds: 2));
    await _checkGpsActive();
    //await Future.delayed(const Duration(seconds: 2));
    await _checkCurrentSpeed();
    //await Future.delayed(const Duration(seconds: 2));
    await checkMockLocation();
  }

  void navigateToLogin() {
    //Navigate to login screen
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage(title: 'KUNJUNGAN')));
  }
  void navigateToHome() {
    //Navigate to login screen
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
  }


  @override
  void initState () {
    super.initState();
    //_checkFirstRun();
    WidgetsBinding.instance.addPostFrameCallback((_) => checkRunPoint());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LatencyAppBar(title: 'WELCOME',),
      body: Center (
        child:Row(
            mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children:<Widget> [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  /*Expanded(child: LoadingAnimationWidget.discreteCircle(
                  color: Colors.purpleAccent,
                  secondRingColor: Colors.lightBlueAccent,
                  thirdRingColor: const Color(0xFF76FF03),
                  size: 100,
                )),
                Expanded(child:Text("Please Wait")),*/
                  if(isLoading)
                    Container(
                      child: LoadingAnimationWidget.discreteCircle(
                        color: Colors.purpleAccent,
                        secondRingColor: Colors.lightBlueAccent,
                        thirdRingColor: const Color(0xFF76FF03),
                        size: 100,
                      ),
                    ),
                    Container(
                      height: 20,
                    ),
                    Container(
                      child: Text("Please Wait"),
                    )
                ],
              ),
            ]

        ),
      ),

      bottomNavigationBar: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_loading)
              ],
            ),
          )
      ),
    );
  }
}


