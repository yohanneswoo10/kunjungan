import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kunjungan/TabPage/TrackingDetailTab.dart';
import 'package:kunjungan/map/trackingMap.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../TabPage/CustomerDetailTab.dart';
import '../config/latencyAppBar.dart';
import '../config/localDb.dart';
import '../map/customer_map.dart';
import '../config/latency_service.dart';

class DetailPage extends StatefulWidget {
  final CustomerMap customer;

  const DetailPage({Key? key, required this.customer}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();

}

class _DetailPageState extends State<DetailPage> {
  final LatencyService  _latencyService = LatencyService ();
  late CustomerMap cust = widget.customer;
  int _selectedIndex = 0; // Tracks the currently selected tab
  String cust_id = "";
  // List of widgets to display for each tab
  /*final List<Widget> _widgetOptions = <Widget>[
    trackingDetailTab(cust_id: cust.cust_id,),
    Customerdetailtab(),
  ];
   */
  late List<Widget> _widgetOptions;
  List<tracking_map> trackings = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _latencyService.start();
    cust_id = widget.customer.cust_id;
    var db = new localDb();
    db.getFullTrackings(cust_id).then((tracking){
      trackings = tracking;
    });

    _widgetOptions = <Widget>[
      trackingListTab(tracking: trackings, customer: cust,),
      Customerdetailtab(customers: cust,),
    ];

  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Color _getLatencyColor(int latency) {
    if (latency < 100) {
      return Colors.green;
    } else if (latency < 300) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar:
          AppBar(
            title: Text(widget.customer.cust_id),
            backgroundColor: Colors.yellow,
            leading: InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
            actions: [
              StreamBuilder<int?>(
                stream: _latencyService.latencyStream,
                builder: (context, snapshot) {
                  final latency = snapshot.data;
                  if (latency == null) {
                    // Show an indicator when there's no connection
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Icon(Icons.signal_wifi_off, color: Colors.red),
                    );
                  }

                  // Customize the display based on latency value
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Tooltip(
                      message: 'Latency: ${latency}ms',
                      child: Text('${latency}ms',
                        style: TextStyle(
                          color: _getLatencyColor(latency),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  // Perform search action
                  print('Refresh button pressed');
                },
              ),
            ],
          ),
          /*
            AppBar(
              title: Text(widget.customer.cust_id),
              centerTitle: false,
              leading: InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
            ),

           */


          body: Center(
            child: _widgetOptions.elementAt(_selectedIndex), // Display content based on selected tab
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Tracking',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.payments),
                label: 'Customer',
              ),
            ],

            currentIndex: _selectedIndex, // Highlight the currently selected tab
            selectedItemColor: Colors.amber[800], // Color for the selected item
            onTap: _onItemTapped, // Callback when a tab is tapped
          ),
        ),
      ),
    );

  }
}