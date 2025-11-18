import 'dart:async';

import 'package:kunjungan/map/user.dart';
import 'package:kunjungan/util/network_util.dart';

class RestData{
  NetworkUtil _netUtil = new NetworkUtil();
  static final BASE_URL = "";
  static final LOGIN_URL = BASE_URL + "/";
  //You can use this to login into a web service We are still working on it

  Future<User> login(String username, String password, String status) {
    //expected success from web service
    return new Future.value(new User(username, password, status));
  }
  Future<User> register(String username, String password, String status) {
    //expected success from web service
    return new Future.value(new User(username, password, status));
  }
  Future<User> transfer(String username, String password, String status) {
    //expected success from web service
    return new Future.value(new User(username, password, status));
  }

}