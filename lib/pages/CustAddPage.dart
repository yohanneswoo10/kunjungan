import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:kunjungan/config/localDb.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/loader.dart';
import '../map/customer_map.dart';
import '../map/trackingMap.dart';
import 'homePage.dart';

class custAddPage extends StatefulWidget {

  const custAddPage({Key? key}) : super(key: key);
  @override
  _CustAddPageState createState() => _CustAddPageState();
}

class _CustAddPageState extends State<custAddPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _CustomerIDController = TextEditingController();
  TextEditingController _CustomerNameController = TextEditingController();
  TextEditingController _CustContactController = TextEditingController();
  TextEditingController _CustOwnerController = TextEditingController();
  TextEditingController _CustLatitudeController = TextEditingController();
  TextEditingController _CustLongitudeController = TextEditingController();
  TextEditingController _CustAddressController = TextEditingController();
  TextEditingController _CustPayController = TextEditingController();
  String _selectedItem = ""; // For a nullable string, adjust type as needed
  String _selectedPenawaran = "";
  String _selectedTanggapan ="";
  String _selectedDiBayar="";
  String _selectedTipePembayaran="";
  String username = "";
  bool _isVisibleKunjungan = false;
  bool _isVisibleTagihan = false;
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  // To retrieve login state
  Future<void> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    if(prefs.getString("user") != null) {
      setState(() {
        username = prefs.getString('user')!;
      });
    }
  }

  // Function to get screen size without context
  Size getScreenSizeWithoutContext() {
    final Size physicalSize = PlatformDispatcher.instance.views.first.physicalSize;
    final double devicePixelRatio = PlatformDispatcher.instance.views.first.devicePixelRatio;

    // Calculate the logical pixel size
    return Size(physicalSize.width / devicePixelRatio, physicalSize.height / devicePixelRatio);
  }


  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("WARNING"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  Future<void> GetPosition() async {
    Position? pos = await getCurrentAccurateLocation();
    if(pos != null){
      _CustLatitudeController.text = pos.latitude.toString();
      _CustLongitudeController.text = pos.longitude.toString();
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<Position?> getCurrentAccurateLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    setState(() {
      _isLoading = true;
    });
    final LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high
    );
    // Check if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, handle this case (e.g., prompt user).
      return Future.error('Location services are disabled.');
    }
    // Check location permissions.
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, handle this case.
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are permanently denied, handle this case (e.g., direct user to app settings).
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    // Get the current position with high accuracy.
    try {
      Position position = await Geolocator.getCurrentPosition(locationSettings: locationSettings);
      return position;
    } catch (e) {
      // Handle any errors during position retrieval.
      print('Error getting location: $e');
      return null;
    }
  }

  bool validateTracking(BuildContext context) {
    //validate date and time
    if(_CustomerIDController.text.isEmpty || _CustomerNameController.text.isEmpty){
      _showErrorDialog(context, "Isikan Customer ID dan Customer Name nya");
      return false;
    }
    //validate customer contact and owner name
    if(_CustContactController.text.isEmpty || _CustOwnerController.text.isEmpty) {
      _showErrorDialog(context, "Isikan No Contact dan Nama Owner");
      return false;
    }
    //validate customer address and customer payment
    if(_CustAddressController.text.isEmpty || _CustPayController.text.isEmpty){
      _showErrorDialog(context, "Isikan Alamat");
      return false;
    }
    //validate latitude and longitude
    if(_CustLatitudeController.text.isEmpty || _CustLongitudeController.text.isEmpty) {
      _showErrorDialog(context, "Pastikan GPS anda hidup");
      return false;
    }


    return true;
  }

  void trackingKunjunganSave(){
    var date = DateTime.now();
    CustomerMap cust_map = new CustomerMap(_CustomerIDController.text, _CustomerNameController.text,
      _CustContactController.text, _CustOwnerController.text, _CustLatitudeController.text,
        _CustLongitudeController.text,
      _CustAddressController.text, _CustPayController.text);
    var db = new localDb();
    db.addCustomer(cust_map);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("ADD CUSTOMER"),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          centerTitle: false,

        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              child: Icon(Icons.save),
              heroTag: 'saveCustomer',
              onPressed: () {
                //savedata();
                if(validateTracking(context)){
                  trackingKunjunganSave();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
                }
              },
              backgroundColor: Colors.lightBlueAccent,
            ),
            SizedBox(
              height: 10,
            ),
            FloatingActionButton(
              child: Icon(Icons.cancel),
              heroTag: 'cancelAdd',
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
                //savedata();
              },
              backgroundColor: Colors.redAccent,
            ),
          ],
        ),
        body: Form(
            key: _formKey,
            child: PageStorage(bucket: PageStorageBucket(),
              child: Stack(
                children: <Widget> [
                  mainScreen(),
                  Container(
                      alignment: Alignment.center,
                      child: _isLoading ? Loader(isCustom: true, loadingTxt: 'Getting Current Position...') : Container()
                  ),
                ],
              ),
            )
        )

    );
  }

  Widget mainScreen() {
    return
      Positioned(
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:15.0,right: 15.0,top:25,bottom: 0),
                    //padding: EdgeInsets.symmetric(horizontal: 15),
                    child: TextField(
                      controller: _CustomerIDController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Customer ID',
                          hintText: 'Isikan Customer ID'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:15.0,right: 15.0,top:5,bottom: 0),
                    //padding: EdgeInsets.symmetric(horizontal: 15),
                    child: TextField(
                      controller: _CustomerNameController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Customer Name',
                          hintText: 'Isikan Customer Name'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:15.0,right: 15.0,top:5,bottom: 0),
                    //padding: EdgeInsets.symmetric(horizontal: 15),
                    child: TextField(
                      controller: _CustContactController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Customer Contact',
                          hintText: 'Isikan Customer Contact Number'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:15.0,right: 15.0,top:5,bottom: 0),
                    //padding: EdgeInsets.symmetric(horizontal: 15),
                    child: TextField(
                      controller: _CustOwnerController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Customer Owner Name',
                          hintText: 'Isikan Nama Owner'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:15.0,right: 15.0,top:5,bottom: 0),
                    //padding: EdgeInsets.symmetric(horizontal: 15),
                    child: TextField(
                      controller: _CustLatitudeController,
                      readOnly: true,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Customer Latitude',
                          hintText: 'Tekan Get Current Location'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:15.0,right: 15.0,top:5,bottom: 0),
                    //padding: EdgeInsets.symmetric(horizontal: 15),
                    child: TextField(
                      controller: _CustLongitudeController,
                      readOnly: true,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Customer Longitude',
                          hintText: 'Tekan Get Current Location'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:15.0,right: 15.0,top:5,bottom: 0),
                    //padding: EdgeInsets.symmetric(horizontal: 15),
                    child: TextField(
                      controller: _CustPayController,
                      readOnly: true,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Customer Payment in Days',
                          hintText: 'Isikan Customer Payment In days'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:15.0,right: 15.0,top:5,bottom: 10),
                    
                    //padding: EdgeInsets.symmetric(horizontal: 15),
                    child: TextField(
                      controller: _CustAddressController,
                      readOnly: true,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Customer Address',
                          hintText: 'Isikan Customer Address'),
                    ),
                  ),

                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 50,
                          width: 200,
                          decoration: BoxDecoration(
                              color: Colors.blue, borderRadius: BorderRadius.circular(20)),
                          child: TextButton(
                            onPressed: () {
                              //checkin();
                            },
                            child: Text(
                              'Get Current Location',
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                     ]
                  ),
                ]
            ),
          )
      );
  }
}
