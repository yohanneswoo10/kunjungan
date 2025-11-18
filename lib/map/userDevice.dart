class UserDevice {
  String _username ="";
  String _device ="";
  String _track_server = "";
  int _id =0;

  UserDevice(this._username, this._device, this._track_server); //Constructor

  UserDevice.map(dynamic obj) {
    this._username = obj['username'];
    this._device = obj['device'];
    this._track_server = obj['track_server'];
    this._id  = obj['id'];
  }

  String get username => _username;
  String get device => _device;
  String get track_server => _track_server;

  int get id => _id;
  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["username"] = _username;
    map["device"] = _device;
    map["track_server"] = _track_server;
    return map;
  }
}