import 'dart:io';
import 'dart:async';
import 'package:kunjungan/map/customer_map.dart';
import 'package:kunjungan/map/userDevice.dart';
import 'package:kunjungan/map/user_tracking_map.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:kunjungan/map/user.dart';

import '../map/trackingMap.dart';

class localDb {
  static final localDb _instance = new localDb.internal();
  factory localDb() => _instance;

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }

  localDb.internal();

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "kunjungan.db");

    var ourDb = await openDatabase(path, version: 2, onCreate: _onCreate);
    return ourDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE IF NOT EXISTS User(id INTEGER PRIMARY KEY, username TEXT, password TEXT, status TEXT);");
    await db.execute(
        "CREATE TABLE IF NOT EXISTS tab_device(id INTEGER PRIMARY KEY, username TEXT, device TEXT, track_server TEXT);");
    await db.execute(
        "CREATE TABLE IF NOT EXISTS tab_tracking_user(id INTEGER PRIMARY KEY, device TEXT, latitude_track TEXT, longitude_track TEXT, track_date TEXT, track_time TEXT, track_server TEXT);");
    await db.execute(
        "CREATE TABLE IF NOT EXISTS tab_cust(id INTEGER PRIMARY KEY autoincrement, cust_id TEXT, cust_name TEXT, cust_contact TEXT, cust_owner_name TEXT, cust_lat TEXT, cust_long TEXT, cust_address TEXT, cust_pembayaran TEXT);");
    await db.execute(
        "CREATE TABLE IF NOT EXISTS tab_tracking_kunjungan(id INTEGER PRIMARY KEY autoincrement, trackingID TEXT, user_name TEXT, cust_id TEXT, cust_name TEXT, "
            "checkindate TEXT, checkintime TEXT, checkoutdate TEXT, checkouttime TEXT, track_lat TEXT, track_long TEXT, "
            "track_perihal TEXT, track_penawaran TEXT, track_tanggapan TEXT, track_dibayar TEXT, track_tipepembayaran TEXT, track_keterangan TEXT, track_server TEXT);");
  }

  Future<void> removeDatabase(String dbName) async {
    // Get the path to the database
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, dbName);

    // Delete the database
    await deleteDatabase(path);
    print('Database $dbName deleted successfully.');
  }

  Future<bool> tableExists(Database db, String tableName) async {
    var res = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name='$tableName'",
    );
    return res.isNotEmpty;
  }

  Future<void> removeTable(String tableName) async {
    var dbClient = await db;
    await dbClient.execute("DROP TABLE IF EXISTS $tableName");
  }

  Future<int> saveUser(User user) async {
    var dbClient = await db;

    int res = await dbClient.insert("User", user.toMap());
    print(user.password);
    return res;
  }

  Future clearUserTable() async {
    var dbClient = await db;
    return await dbClient.rawDelete("DELETE FROM User");
  }

  Future<User> checkUser(User user) async {
    var dbClient = await db;
    List<Map<String, dynamic>> res = await dbClient.query(
        "User", where: '"username" = ? and "password"=?',
        whereArgs: [user.username, user.password]);
    //print(res);
    for (var row in res) {
      return new Future<User>.value(User.map(row));
    }
    return new Future<User>.error("Unable to find User");
  }

  Future<int> saveUserTracking(trackUserMap trkUser) async {
    var dbClient = await db;
    print(trkUser.device);
    int res = await dbClient.insert("tab_tracking_user", trkUser.toMap());
    print("success");
    return res;
  }

  Future<List<trackUserMap>> getFullUserTrackings(String track_server) async {
    var dbClient = await db;
    List<trackUserMap> trackings = [];
    List<Map<String, dynamic>> res = await dbClient.query(
        "tab_tracking_user", where: '"track_server" = ?', whereArgs: [track_server]);
    for (var row in res) {
      print("getTRK: ${row['device']}");
      trackings.add(trackUserMap.map(row));
    }
    return new Future<List<trackUserMap>>.value(trackings);
  }

  Future<List<trackUserMap>> getUserTrackings() async {
    var dbClient = await db;
    List<trackUserMap> trackings = [];
    List<Map<String, dynamic>> res = await dbClient.query(
        "tab_tracking_user");
    for (var row in res) {
      print("db: ${row['device']}");
      trackings.add(trackUserMap.map(row));
    }
    return new Future<List<trackUserMap>>.value(trackings);
  }

  void UpdateUserTracking(int id) async {
    var dbClient = await db;
    await dbClient.update("tab_tracking_user", {'track_server' : 'done'}, where: '"id" = ?', whereArgs: [id]);
  }

  Future<int> saveCustomer(CustomerMap customers) async {
    var dbClient = await db;
    int res = await dbClient.insert("tab_cust", customers.toMap());
    return res;
  }

  Future<List<CustomerMap>> getAllCust() async {
    var dbClient = await db;
    List<CustomerMap> customers = [];
    List<Map<String, dynamic>> res = await dbClient.query("tab_cust");
    for (var row in res) {
      //print(row['id']);
      customers.add(CustomerMap.map(row));
    }
    return new Future<List<CustomerMap>>.value(customers);
  }

  Future<List<tracking_map>> getFullTrackings(String customer_id) async {
    var dbClient = await db;
    List<tracking_map> trackings = [];
    List<Map<String, dynamic>> res = await dbClient.query(
        "tab_tracking_kunjungan", where: '"cust_id" = ?', whereArgs: [customer_id]);
    for (var row in res) {
      //print("db: ${row['track_perihal']}");
      trackings.add(tracking_map.map(row));
    }
    return new Future<List<tracking_map>>.value(trackings);
  }

  //ADD TRACKING KUNJUNGAN
  Future<int> saveTrackingKunjungan(tracking_map track) async {
    var dbClient = await db;
    int res = await dbClient.insert("tab_tracking_kunjungan", track.toMap());
    //print("success");
    return res;
  }

  //ADD CUSTOMER
  Future<int> addCustomer(CustomerMap cust) async {
    var dbClient = await db;
    int res = await dbClient.insert("tab_cust", cust.toMap());
    //print("success");
    return res;
  }

  //ADD USER DEVICE
  Future<int> addUserDevice(UserDevice ud) async {
    var dbClient = await db;
    int res = await dbClient.insert("tab_device", ud.toMap());
    //print("success");
    return res;
  }

  Future<List<UserDevice>> getFullUserDevice(String track_server) async {
    var dbClient = await db;
    List<UserDevice> ud = [];
    List<Map<String, dynamic>> res = await dbClient.query(
        "tab_device", where: '"track_server" = ?', whereArgs: [track_server]);
    for (var row in res) {
      //print("getTRK: ${row['device']}");
      ud.add(UserDevice.map(row));
    }
    return new Future<List<UserDevice>>.value(ud);
  }

  void UpdateUserDevice(int id) async {
    var dbClient = await db;
    await dbClient.update("tab_device", {'track_server' : 'done'}, where: '"id" = ?', whereArgs: [id]);
  }

}