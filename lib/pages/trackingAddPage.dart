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

class trackingAddPage extends StatefulWidget {
  final CustomerMap customers;

  const trackingAddPage({Key? key, required this.customers}) : super(key: key);
  @override
  _trackingAddPageState createState() => _trackingAddPageState();
}

class _trackingAddPageState extends State<trackingAddPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _CheckinDateController = TextEditingController();
  TextEditingController _CheckoutDateController = TextEditingController();
  TextEditingController _CheckinTimeController = TextEditingController();
  TextEditingController _CheckoutTimeController = TextEditingController();
  TextEditingController _LatitudeController = TextEditingController();
  TextEditingController _LongitudeController = TextEditingController();
  TextEditingController _UserController = TextEditingController();
  TextEditingController _keterangancontroller = TextEditingController();
  String _selectedItem = ""; // For a nullable string, adjust type as needed
  String _selectedPenawaran = "";
  String _selectedTanggapan ="";
  String _selectedDiBayar="";
  String _selectedTipePembayaran="";
  String username = "";
  bool _isVisibleKunjungan = false;
  bool _isVisibleTagihan = false;
  bool _isLoading = false;
  final List<DropdownMenuEntry<String>> dropdownPerihal = <DropdownMenuEntry<String>>[
    DropdownMenuEntry(value: 'kunjungan', label: 'Kunjungan'),
    DropdownMenuEntry(value: 'tagihan', label: 'Tagihan'),
  ];
  final List<DropdownMenuEntry<String>> dropdownPenawaran = <DropdownMenuEntry<String>>[
    DropdownMenuEntry(value: 'ascendo', label: 'Ban Ascendo'),
    DropdownMenuEntry(value: 'petronas', label: 'Oli Petronas'),
    DropdownMenuEntry(value: 'fedhq', label: 'Oli FedHQ'),
    DropdownMenuEntry(value: 'adnoc', label: 'Oli ADNOC'),
    DropdownMenuEntry(value: 'sparepart', label: 'Sparepart'),
  ];
  final List<DropdownMenuEntry<String>> dropdownTanggapan = <DropdownMenuEntry<String>>[
    DropdownMenuEntry(value: 'baik', label: 'Baik'),
    DropdownMenuEntry(value: 'tidak', label: 'Tidak'),
  ];
  final List<DropdownMenuEntry<String>> dropdownDiBayar = <DropdownMenuEntry<String>>[
    DropdownMenuEntry(value: 'ya', label: 'Ya'),
    DropdownMenuEntry(value: 'tidak', label: 'Tidak'),
  ];
  final List<DropdownMenuEntry<String>> dropdownTipePembayaran = <DropdownMenuEntry<String>>[
    DropdownMenuEntry(value: 'angsur', label: 'Anggsuran'),
    DropdownMenuEntry(value: 'lunas', label: 'Lunas'),
  ];

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

  void checkin() async
  {
    var date = DateTime.now();
    var day = date.day.toInt();
    var month = date.month.toInt();
    var year = date.year.toInt();
    var hour = date.hour.toInt();
    var minute = date.minute.toInt();
    var second = date.minute.toInt();
    _CheckinDateController.text = "$day/$month/$year";
    _CheckinTimeController.text = "$hour:$minute:$second";
    _UserController.text = username;
    Position? currentLocation =  await getCurrentAccurateLocation();
    if(currentLocation != null) {
      _LatitudeController.text = currentLocation.latitude.toString();
      _LongitudeController.text = currentLocation.longitude.toString();
    }
    setState(() {
      _isLoading = false;
    });
    //verythingdone = true;
  }

  void checkout() async
  {
    var date = DateTime.now();
    var day = date.day.toInt();
    var month = date.month.toInt();
    var year = date.year.toInt();
    var hour = date.hour.toInt();
    var minute = date.minute.toInt();
    var second = date.minute.toInt();
    _CheckoutDateController.text = "$day/$month/$year";
    _CheckoutTimeController.text = "$hour:$minute:$second";
    //Position? currentLocation =  await getCurrentAccurateLocation();
    //_usercontroller.value.text = uname;
    //verythingdone = true;
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

  bool validateTracking(BuildContext context) {
    //validate date and time
    if(_CheckinDateController.text.isEmpty || _CheckoutDateController.text.isEmpty){
      _showErrorDialog(context, "Check In terlebih dahulu dan jangan lupa Check Out");
      return false;
    }
    if(_CheckinTimeController.text.isEmpty || _CheckoutTimeController.text.isEmpty) {
      _showErrorDialog(context, "Check In terlebih dahulu dan jangan lupa Check Out");
      return false;
    }
    //validate user
    if(_UserController.text.isEmpty){
      _showErrorDialog(context, "Check In terlebih dahulu dan jangan lupa Check Out");
      return false;
    }
    //validate latitude and longitude
    if(_LatitudeController.text.isEmpty || _LongitudeController.text.isEmpty) {
      _showErrorDialog(context, "Pastikan GPS anda hidup");
      return false;
    }
    //validate perihal
    if(_selectedItem == null){
      _showErrorDialog(context, "Jangan Lupa Pilih Perihal");
      return false;
    }
    //validate perihal kunjungan
    if(_selectedItem == "kunjungan"){
      if(_selectedPenawaran == null || _selectedTanggapan ==null){
        _showErrorDialog(context, "Jangan Lupa Pilih Penawaran dan Tanggapan");
        return false;
      }
    }
    //validate perihal tagihan
    if(_selectedItem == "tagihan") {
      if (_selectedDiBayar == null || _selectedTipePembayaran == null) {
        _showErrorDialog(context, "Jangan Lupa Pilih Apakah dibayar dan Tipe Pembayaran");
        return false;
      }
    }
    //validate keterangan
    if(_keterangancontroller.text.isEmpty) {
      _showErrorDialog(context, "Jangan Lupa Isi Keterangan");
      return false;
    }

    return true;
  }

  void trackingKunjunganSave(){
    var date = DateTime.now();
    tracking_map trk = new tracking_map(date.toString(), widget.customers.cust_id, widget.customers.cust_name, _CheckinDateController.text, _CheckinTimeController.text,
        _CheckoutDateController.text, _CheckoutTimeController.text, _LatitudeController.text, _LongitudeController.text,
        _UserController.text, _selectedItem, _selectedPenawaran, _selectedTanggapan,
        _selectedDiBayar, _selectedTipePembayaran, _keterangancontroller.text, "toServer");
    var db = new localDb();
    db.saveTrackingKunjungan(trk);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.customers.cust_id),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          centerTitle: false,

        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              child: Icon(Icons.save),
              heroTag: 'savetracking',
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
              heroTag: 'canceltracking',
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 5,
                      ),
                      Container(
                        width: getScreenSizeWithoutContext().width / 2,
                        height: 40,
                        child: TextField(
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Tanggal Masuk',
                            border: OutlineInputBorder(),
                          ),
                          controller: _CheckinDateController,
                        ),
                      ),
                      Container(
                        width: getScreenSizeWithoutContext().width / 2,
                        height: 40,
                        child: TextField(
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Tanggal Keluar',
                            border: OutlineInputBorder(),
                          ),
                          controller: _CheckoutDateController,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 10,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: getScreenSizeWithoutContext().width / 2,
                          height: 40,
                          child: TextField(
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Jam Masuk',
                              border: OutlineInputBorder(),
                            ),
                            controller: _CheckinTimeController,
                          ),
                        ),
                        Container(
                          width: getScreenSizeWithoutContext().width / 2,
                          height: 40,
                          child: TextField(
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Jam Keluar',
                              border: OutlineInputBorder(),
                            ),
                            controller: _CheckoutTimeController,
                          ),
                        ),
                      ]
                  ),
                  Container(
                    height: 10,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: getScreenSizeWithoutContext().width / 2,
                          height: 40,
                          child: TextField(
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Latitude',
                              border: OutlineInputBorder(),
                            ),
                            controller: _LatitudeController,
                          ),
                        ),
                        Container(
                          width: getScreenSizeWithoutContext().width / 2,
                          height: 40,
                          child: TextField(
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Longitude',
                              border: OutlineInputBorder(),
                            ),
                            controller: _LongitudeController,
                          ),
                        ),
                      ]
                  ),
                  Container(
                    height: 10,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: getScreenSizeWithoutContext().width / 2,
                          height: 70,
                          child: TextField(
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'User',
                              border: OutlineInputBorder(),
                            ),
                            controller: _UserController,
                          ),
                        ),
                        Container(
                            width: getScreenSizeWithoutContext().width / 2,
                            height: 70,
                            child: DropdownMenu<String>(
                              initialSelection: "", // Optional: set a default
                              onSelected: (String? value) {
                                // Handle the selected value
                                setState(() {
                                  if(value != null) {
                                    _selectedItem = value!;
                                  }
                                  if(value == "kunjungan") {
                                    _isVisibleKunjungan = true;
                                    _isVisibleTagihan = false;
                                  }else {
                                    _isVisibleKunjungan = false;
                                    _isVisibleTagihan = true;
                                  }
                                });
                              },
                              dropdownMenuEntries: dropdownPerihal,
                              label: const Text('Perihal Kunjungan'), // Optional: add a label
                              enableSearch: true, // Optional: enable search functionality
                              // ... other properties for styling and behavior
                            )
                        )
                      ]
                  ),
                  Visibility(
                    visible: _isVisibleKunjungan,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              width: getScreenSizeWithoutContext().width / 2,
                              height: 70,
                              child: DropdownMenu<String>(
                                initialSelection: "", // Optional: set a default
                                onSelected: (String? value) {
                                  // Handle the selected value
                                  setState(() {
                                    if(value != null) {
                                      _selectedPenawaran = value;
                                    }
                                  });
                                },
                                dropdownMenuEntries: dropdownPenawaran,
                                label: const Text('Penawaran Barang'), // Optional: add a label
                                enableSearch: true, // Optional: enable search functionality
                                // ... other properties for styling and behavior
                              )
                          ),
                          Container(
                              width: getScreenSizeWithoutContext().width / 2,
                              height: 70,
                              child: DropdownMenu<String>(
                                initialSelection: "", // Optional: set a default
                                onSelected: (String? value) {
                                  // Handle the selected value
                                  setState(() {
                                    if(value != null) {
                                      _selectedTanggapan = value;
                                    }
                                  });
                                },
                                dropdownMenuEntries: dropdownTanggapan,
                                label: const Text('Tanggapan Customer'), // Optional: add a label
                                enableSearch: true, // Optional: enable search functionality
                                // ... other properties for styling and behavior
                              )
                          ),
                        ]
                    ),
                  ),
                  Visibility(
                    visible: _isVisibleTagihan,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              width: getScreenSizeWithoutContext().width / 2,
                              height: 70,
                              child: DropdownMenu<String>(
                                initialSelection: "", // Optional: set a default
                                onSelected: (String? value) {
                                  // Handle the selected value
                                  setState(() {
                                    if(value != null) {
                                      _selectedDiBayar = value;
                                    }
                                  });
                                },
                                dropdownMenuEntries: dropdownDiBayar,
                                label: const Text('Apakah dibayar?'), // Optional: add a label
                                enableSearch: true, // Optional: enable search functionality
                                // ... other properties for styling and behavior
                              )
                          ),
                          Container(
                              width: getScreenSizeWithoutContext().width / 2,
                              height: 70,
                              child: DropdownMenu<String>(
                                initialSelection: "", // Optional: set a default
                                onSelected: (String? value) {
                                  // Handle the selected value
                                  setState(() {
                                    if(value != null) {
                                      _selectedTipePembayaran = value;
                                    }
                                  });
                                },
                                dropdownMenuEntries: dropdownTipePembayaran,
                                label: const Text('Tipe Pembayaran'), // Optional: add a label
                                enableSearch: true, // Optional: enable search functionality
                                // ... other properties for styling and behavior
                              )
                          ),
                        ]
                    ),
                  ),

                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: getScreenSizeWithoutContext().width,
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Keterangan',
                              border: OutlineInputBorder(),
                              labelStyle: TextStyle(fontSize: 10),
                            ),
                            keyboardType: TextInputType.multiline,
                            minLines: 1,
                            maxLines: null,
                            controller: _keterangancontroller,
                          ),
                        ),
                      ]
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 50,
                          width: 150,
                          decoration: BoxDecoration(
                              color: Colors.blue, borderRadius: BorderRadius.circular(20)),
                          child: TextButton(
                            onPressed: () {
                              checkin();
                            },
                            child: Text(
                              'Check In',
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          width: 150,
                          decoration: BoxDecoration(
                              color: Colors.blue, borderRadius: BorderRadius.circular(20)),
                          child: TextButton(
                            onPressed: () {
                              checkout();
                            },
                            child: Text(
                              'Check Out',
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
