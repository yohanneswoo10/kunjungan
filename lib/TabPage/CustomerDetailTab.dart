import 'package:flutter/material.dart';
import 'package:kunjungan/map/customer_map.dart';

class Customerdetailtab extends StatefulWidget {
  final CustomerMap customers;

  const Customerdetailtab({Key? key, required this.customers}) : super(key: key);
  @override
  _Customerdetailtab createState() => _Customerdetailtab();
}

class _Customerdetailtab extends State<Customerdetailtab> {
  bool edited = true;

  void onActionPress() {
    setState(() {
      if(edited){
        edited = false;
      }else {
        edited = true;
      }

    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          floatingActionButton: edited ?
          FloatingActionButton(
            child: Icon(Icons.edit),
            heroTag: 'edit',
            onPressed: () {
              onActionPress();
              //savedata();
            },
          )
              :
          FloatingActionButton(
            child: Icon(Icons.save),
            heroTag: 'save',
            onPressed: () {
              onActionPress();
              //savedata();
            },
          ),
          body: SingleChildScrollView(
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
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.blue, // Border color
                            width: 2.0,        // Border width
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0), //horizontal: left & right, vertical: top & bottom
                        width: 160,
                        height: 40,
                        child: Text("Customer ID:"),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.blue, // Border color
                            width: 2.0,        // Border width
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0), //horizontal: left & right, vertical: top & bottom
                          width: 200,
                          height: 40,
                          child: Text(widget.customers.cust_id),
                      ),
                    ],
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.blue, // Border color
                              width: 2.0,        // Border width
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0), //horizontal: left & right, vertical: top & bottom
                          width: 160,
                          height: 40,
                          child: Text("Customer Name:"),
                        ),
                        Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.blue, // Border color
                                width: 2.0,        // Border width
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0), //horizontal: left & right, vertical: top & bottom
                            width: 200,
                            height: 40,
                            child: Text(widget.customers.cust_name)
                        )
                      ]
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.blue, // Border color
                              width: 2.0,        // Border width
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0), //horizontal: left & right, vertical: top & bottom
                          width: 160,
                          height: 40,
                          child: Text("Customer Contact:"),
                        ),
                        Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.blue, // Border color
                                width: 2.0,        // Border width
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0), //horizontal: left & right, vertical: top & bottom
                            width: 200,
                            height: 40,
                            child: Text(widget.customers.cust_contact,)
                        )
                      ]
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.blue, // Border color
                              width: 2.0,        // Border width
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0), //horizontal: left & right, vertical: top & bottom
                          width: 160,
                          height: 40,
                          child: Text("Customer Owner:"),
                        ),
                        Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.blue, // Border color
                                width: 2.0,        // Border width
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0), //horizontal: left & right, vertical: top & bottom
                            width: 200,
                            height: 40,
                            child: Text(widget.customers.cust_owner_name,)
                        )
                      ]
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.blue, // Border color
                              width: 2.0,        // Border width
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0), //horizontal: left & right, vertical: top & bottom
                          width: 160,
                          height: 40,
                          child: Text("Customer Latitude:"),
                        ),
                        Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.blue, // Border color
                                width: 2.0,        // Border width
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0), //horizontal: left & right, vertical: top & bottom
                            width: 200,
                            height: 40,
                            child: Text(widget.customers.cust_lat,)
                        )
                      ]
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.blue, // Border color
                              width: 2.0,        // Border width
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0), //horizontal: left & right, vertical: top & bottom
                          width: 160,
                          height: 40,
                          child: Text("Customer Longitude:"),
                        ),
                        Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.blue, // Border color
                                width: 2.0,        // Border width
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0), //horizontal: left & right, vertical: top & bottom
                            width: 200,
                            height: 40,
                            child: Text(widget.customers.cust_long,)
                        )
                      ]
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.blue, // Border color
                              width: 2.0,        // Border width
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0), //horizontal: left & right, vertical: top & bottom
                          width: 160,
                          height: 150,
                          child: Text("Customer Address:"),
                        ),
                        Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.blue, // Border color
                                width: 2.0,        // Border width
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0), //horizontal: left & right, vertical: top & bottom
                            width: 200,
                            height: 150,
                            child: Text(widget.customers.cust_address,)
                        )
                      ]
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.blue, // Border color
                              width: 2.0,        // Border width
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0), //horizontal: left & right, vertical: top & bottom
                          width: 160,
                          height: 40,
                          child: Text("Customer Pay(days):"),
                        ),
                        Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.blue, // Border color
                                width: 2.0,        // Border width
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0), //horizontal: left & right, vertical: top & bottom
                            width: 200,
                            height: 40,
                            child: Text(widget.customers.cust_pembayaran,)
                        )
                      ]
                  ),
                ]
            ),
          )
      ),
    );
  }
}
