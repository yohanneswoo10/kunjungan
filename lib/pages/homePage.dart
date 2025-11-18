import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kunjungan/config/localDb.dart';
import 'package:kunjungan/map/customer_map.dart';
import 'package:kunjungan/pages/showUserTracking.dart';

import '../config/latencyAppBar.dart';
import 'CustAddPage.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _search= TextEditingController();
  List<CustomerMap> customer = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LatencyAppBar(title: 'KUNJUNGAN',),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            child: Icon(Icons.add),
            heroTag: 'addCust',
            onPressed: () {
              //Navigator.push(context, MaterialPageRoute(builder: (context) => custAddPage()));
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
            Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: TextField(
                controller: _search,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Customer Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.white)
                    )
                ),
                onChanged: searchLead,
              ),
            ),
            Expanded(
                child: new ListView.builder(
                    itemCount: customer.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return singleRow(customer[index]);
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

  @override
  void initState(){
    super.initState();
    var db = new localDb();
    db.getAllCust().then((customers){
      customer = customers;
      //print(lead);
      setState(() {});
    });
  }
  Widget singleRow(CustomerMap lead)
  {
    return new Container(
        padding: EdgeInsets.all(5),
        child: Row(
            children:[
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                      title: Text(lead.cust_id,
                          style: TextStyle(
                            color:Colors.indigoAccent,
                          )
                      ),
                      subtitle: Text(lead.cust_name,
                          style: TextStyle(
                            color:Colors.indigoAccent,
                          )
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailPage(customer : lead)
                          )
                        );
                      }
                  )
                  /*Text(lead.leadname,
                      style: TextStyle(
                        color:Colors.indigoAccent[500],
                      )
                  )*/
                ],
              )),


            ])
    );
  }

  void searchLead(String query) {
    final data = customer.where((custs) {
      final leadName = custs.cust_name.toLowerCase();
      final input = query.toLowerCase();
      return leadName.contains(input);
    }).toList();
    setState(() => customer = data);
  }


  String getdate() {
    String cdate = DateFormat("yyyy-MM-dd").format(DateTime.now());
    return cdate;
  }

}