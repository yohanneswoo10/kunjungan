class trackUserMap {
  String _device ="";
  String _latitude_track ="";
  String _longitude_track ="";
  String _track_date ="";
  String _track_time ="";
  String _track_server ="";
  int _id =0;

  trackUserMap(this._device, this._latitude_track, this._longitude_track,
      this._track_date, this._track_time, this._track_server); //Constructor

  trackUserMap.map(dynamic obj) {
    this._device = obj['device'];
    this._latitude_track = obj['latitude_track'];
    this._longitude_track = obj['longitude_track'];
    this._track_date = obj['track_date'];
    this._track_time = obj['track_time'];
    this._track_server = obj['track_server'];
    this._id  = obj['id'];
  }

  String get device => _device;
  String get latitude_track => _latitude_track;
  String get longitude_track => _longitude_track;
  String get track_date => _track_date;
  String get track_time => _track_time;
  String get track_server => _track_server;
  int get id => _id;
  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["device"] = _device;
    map["latitude_track"] = _latitude_track;
    map["longitude_track"] = _longitude_track;
    map["track_date"] = _track_date;
    map["track_time"] = _track_time;
    map["track_server"] = _track_server;
    return map;
  }

  void operator []=(String other, value) {}

  void operator [](String other) {}
}