import 'package:mysql1/mysql1.dart';

class Mysql {
  static String host = 'data.banindo.co.id';
  static String user = 'android',
      password = 'banindo',
      db = 'kunjungan';
  static int port = 3306;

  Mysql();

  Future<MySqlConnection> getConnection(String h) async {
    var settings = new ConnectionSettings(
        host: host,
        port: port,
        user: user,
        password: password,
        db: db
    );
    return await MySqlConnection.connect(settings);
  }

}