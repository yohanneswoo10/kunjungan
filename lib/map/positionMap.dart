class PositionMap {
  String _latitude ="";
  String _longitude ="";
  String _speed = "";
  String _trackServer = "";
  int _id =0;

  PositionMap(this._latitude, this._longitude, this._speed, this._trackServer); //Constructor

  PositionMap.map(dynamic obj) {
    this._latitude = obj['latitude'];
    this._longitude = obj['longitude'];
    this._speed = obj['speed'];
    this._trackServer = obj['track_server'];
    this._id  = obj['id'];
  }

  String get latitude => _latitude;
  String get longitude => _longitude;
  String get speed => _speed;
  String get trackServer => _trackServer;
  int get id => _id;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["latitude"] = _latitude;
    map["longitude"] = _longitude;
    map["speed"] = _speed;
    map["trackServer"] = _trackServer;
    return map;
  }
}