import 'package:kunjungan/config/localDb.dart';

import '../config/mysqlConnector.dart';
import '../map/customer_map.dart';

class LoadNSave {
  List<CustomerMap>? customers;

  Future<bool> getServerData() async {
    final mysqldb = Mysql();
    String h = "data.banindo.co.id";
    String sql = "SELECT * FROM tab_customer";
    print(sql);
    try {
      final conn = await mysqldb.getConnection(h);
      // Perform database operations here
      var results = await conn.query(sql);
      for (var row in results) {
        CustomerMap newCust = new CustomerMap('${row[0]}', '${row[1]}', '${row[2]}', '${row[3]}', '${row[4]}', '${row[5]}', '${row[6]}', '${row[7]}');
        //customers?.add(newCust);
        insertToLocal(newCust);
      }
      await conn.close();
      return Future.value(true);
    } catch (e) {
      print('Error connecting to database: $e');
      return Future.value(false);
    }
  }

  void insertToLocal(CustomerMap customer) {
    var db = new localDb();
    db.saveCustomer(customer);
  }
}