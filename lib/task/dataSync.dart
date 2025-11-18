import 'package:kunjungan/config/localDb.dart';

import '../config/lead_map.dart';
import '../config/mysqlConnector.dart';
import '../map/userDevice.dart';
import '../map/user_tracking_map.dart';

class dataSync {

  Future<bool> doWork() async {
    bool _isSucess = await UploadUserTracking();
    return _isSucess;
  }

  Future<void> UpdateUserTrackingLocal() async {
    var db = localDb();
    List<trackUserMap> userTrk = [];
    userTrk = await getLocalDataUserTracking();
    for(var i = 0; i < userTrk.length; i++){
      int ids = userTrk[i].id;
      print("id = ${ids}");
      db.UpdateUserTracking(ids);
    }

  }

  Future<bool> UploadUserTracking() async {
    List<trackUserMap> userTrk = [];
    userTrk = await getLocalDataUserTracking();
    String h = "data.banindo.co.id";
    var mysqldb = new Mysql();
    var conn = await mysqldb.getConnection(h);
    try{
      for(var row in userTrk){
        String sql = "INSERT INTO user_tracking (device, track_latitude, track_longitude, track_date, track_time) VALUES (?,?,?,?,?)";
        await conn.query(sql,[row.device, row.latitude_track, row.longitude_track, row.track_date, row.track_time] );
      }
      await UpdateUserTrackingLocal();
    }catch(e) {
      print("Unexpected Error");
      return false;
    }finally {
        await conn.close();
        print("Databases closed");
        return true;
    }
  }

  Future<List<trackUserMap>> getLocalDataUserTracking() async {
    List<trackUserMap> userTrk = [];
    var db = localDb();
    userTrk = await db.getFullUserTrackings("toServer");
    return userTrk;
  }

  Future<List<UserDevice>> getLocalDataUserDevice() async {
    List<UserDevice> ud = [];
    var db =new localDb();
    ud = await db.getFullUserDevice("toServer");
    return ud;
  }

  Future<bool> UploadUserDevice() async {
    List<UserDevice> userDevice = [];
    userDevice = await getLocalDataUserDevice();
    String h = "data.banindo.co.id";
    var mysqldb = new Mysql();
    var conn = await mysqldb.getConnection(h);
    try{
      for(var row in userDevice){
        String sql = "INSERT INTO user_device (username, device) VALUES (?,?,?,?,?)";
        await conn.query(sql,[row.username, row.device] );
      }
    }catch(e) {
      print("Unexpected Error");
      return false;
    }finally {
      await conn.close();
      print("Databases closed");
      UpdateUserTrackingLocal();
      return true;
    }
  }
}