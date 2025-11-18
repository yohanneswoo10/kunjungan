class tracking_map {
  String _custid ="";
  String _checkindate ="";
  String _checkintime ="";
  String _chekoutdate ="";
  String _checkouttime ="";
  String _lat ="";
  String _long ="";
  String _user ="";
  String _keterangan ="";
  String _sync_server = "";
  String _cust_name = "";
  String _perihal = "";
  String _penawaran = "";
  String _tanggapan = "";
  String _dibayar = "";
  String _tipepembayaran = "";
  String _trackingID = "";
  int _id =0;

  tracking_map(this._trackingID, this._custid, this._cust_name, this._checkindate, this._checkintime,
      this._chekoutdate, this._checkouttime, this._lat, this._long, this._user,
      this._perihal, this._penawaran, this._tanggapan, this._dibayar, this._tipepembayaran,
      this._keterangan, this._sync_server);

  tracking_map.map(dynamic obj) {
    this._trackingID = obj['trackingID'];
    this._custid = obj['cust_id'];
    this._cust_name = obj['cust_name'];
    this._checkindate = obj['checkindate'];
    this._checkintime = obj['checkintime'];
    this._chekoutdate = obj['checkoutdate'];
    this._checkouttime = obj['checkouttime'];
    this._lat = obj['track_lat'];
    this._long = obj['track_long'];
    this._user = obj['user_name'];
    this._perihal = obj['track_perihal'];
    this._penawaran = obj['track_penawaran'];
    this._tanggapan = obj['track_tanggapan'];
    this._dibayar = obj['track_dibayar'];
    this._tipepembayaran = obj['track_tipepembayaran'];
    this._keterangan = obj['track_keterangan'];
    this._sync_server = obj['track_server'];
    this._id  = obj['id'];
  }

  String get trackingID => _trackingID;
  String get cust_id => _custid;
  String get cust_name => _cust_name;
  String get checkindate => _checkindate;
  String get checkintime => _checkintime;
  String get checkoutdate => _chekoutdate;
  String get checkouttime => _checkouttime;
  String get track_lat => _lat;
  String get track_long => _long;
  String get user_name => _user;
  String get track_perihal => _perihal;
  String get track_penawaran => _penawaran;
  String get track_tanggapan => _tanggapan;
  String get track_dibayar => _dibayar;
  String get track_tipepembayaran => _tipepembayaran;
  String get track_keterangan => _keterangan;
  String get track_server => _sync_server;
  int get id => _id;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["trackingID"] = _trackingID;
    map["cust_id"] = _custid;
    map["cust_name"] = _cust_name;
    map["checkindate"] = _checkindate;
    map["checkintime"] = _checkintime;
    map["checkoutdate"] = _chekoutdate;
    map["checkouttime"] = _checkouttime;
    map["track_lat"] = _lat;
    map["track_long"] = _long;
    map["user_name"] = _user;
    map["track_perihal"] = _perihal;
    map["track_penawaran"] = _penawaran;
    map["track_tanggapan"] = _tanggapan;
    map["track_dibayar"] = _dibayar;
    map["track_tipepembayaran"] = _tipepembayaran;
    map["track_keterangan"] = _keterangan;
    map["track_server"] = _sync_server;
    return map;
  }
}