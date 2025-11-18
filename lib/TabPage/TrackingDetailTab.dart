import 'package:flutter/material.dart';
import 'package:kunjungan/pages/trackingAddPage.dart';

import '../config/localDb.dart';
import '../map/customer_map.dart';
import '../map/trackingMap.dart';

class trackingListTab extends StatefulWidget {
  final List<tracking_map> tracking;
  final CustomerMap customer;
  const trackingListTab({Key? key, required this.tracking, required this.customer}) : super(key: key);
  @override
  _trackingDetailTab createState() => _trackingDetailTab();
}

class _trackingDetailTab extends State<trackingListTab> {

  List<tracking_map> _trackingList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var db = new localDb();
    db.getFullTrackings(widget.customer.cust_id).then((tracking){
      setState(() {
        _trackingList = tracking;
      });

    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                child: Icon(Icons.add),
                heroTag: 'addTracking',
                onPressed: () {
                  //savedata();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => trackingAddPage(customers: widget.customer)));
                },
              ),
            ],
          ),
          body: ListView.builder(
              itemCount: _trackingList.length,
              itemBuilder: (BuildContext context, int index) {
                return singleRow(_trackingList[index]);
              }
          )
      ),
    );
  }

  Widget singleRow(tracking_map trk)
  {
    return new Container(
        padding: EdgeInsets.all(5),
        child: Row(
            children:[
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                      title: Text(trk.checkindate,
                          style: TextStyle(
                            color:Colors.indigoAccent,
                          )
                      ),
                      subtitle: Text(trk.track_perihal,
                          style: TextStyle(
                            color:Colors.indigoAccent,
                          )
                      ),

                  )
                ],
              )),


            ])
    );
  }
}
