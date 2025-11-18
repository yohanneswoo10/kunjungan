import '../config/mysqlConnector.dart';
import '../map/user.dart';

extension checkLogin on String {

  Future<String> getPassword() async {

    String pass1="";
    final mysqldb = Mysql();
    String h = "data.banindo.co.id";
    String sql = "SELECT pass FROM tab_user where user_name='" + this + "'";
    print(sql);
    try {
      final conn = await mysqldb.getConnection(h);
      // Perform database operations here
      var results = await conn.query(sql);
      for (var row in results) {
        pass1 = '${row[0]}';
      }
      await conn.close();
      //print("1: ${pass1}");
      return pass1;
    } catch (e) {
      print('Error connecting to database: $e');
    }
    //print("1: ${pass1}");
    return pass1;
  }
}