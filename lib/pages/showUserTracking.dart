import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kunjungan/config/localDb.dart';

import '../config/latencyAppBar.dart';
import '../map/user_tracking_map.dart';

class UserTrackingPage extends StatefulWidget {
  @override
  _UserTrackingPageState createState() => _UserTrackingPageState();
}

class _UserTrackingPageState extends State<UserTrackingPage> {

  List<trackUserMap> trackUser = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocalUserTracking();
  }

  Future<void> getLocalUserTracking()
  async {
    List<trackUserMap> trkUsers = [];
    var db = new localDb();
    trkUsers = await db.getUserTrackings();

    setState(() {
      trackUser = trkUsers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LatencyAppBar(title: 'WELCOME',),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            child: Icon(Icons.add),
            heroTag: 'addCust',
            onPressed: () {
              /*
              FUTURE PROGRESS
               */
            },
          ),
        ],
      ),
      body:
      Column (
          children: <Widget>[
            Expanded(
                child: new ListView.builder(
                    itemCount: trackUser.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return singleRow(trackUser[index]);
                    })
            )
          ]
        /*Center(
        child: Text(
          getdate(),
        ),*/
      ),
    );
  }
  Widget singleRow(trackUserMap trkUser)
  {
    return new Container(
        padding: EdgeInsets.all(5),
        child: Row(
            children:[
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                      title: Text(trkUser.track_date,
                          style: TextStyle(
                            color:Colors.indigoAccent,
                          )
                      ),
                      subtitle: Text("Lat: ${trkUser.latitude_track}, Long: ${trkUser.longitude_track}",
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