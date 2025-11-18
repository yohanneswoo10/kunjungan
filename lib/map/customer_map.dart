class CustomerMap {
  String _cust_id ="";
  String _cust_name ="";
  String _cust_contact ="";
  String _cust_owner_name ="";
  String _cust_lat ="";
  String _cust_long ="";
  String _cust_address ="";
  String _cust_pembayaran ="";
  int _id =0;

  CustomerMap(this._cust_id, this._cust_name, this._cust_contact, this._cust_owner_name, this._cust_lat, this._cust_long, this._cust_address, this._cust_pembayaran); //Constructor

  CustomerMap.map(dynamic obj) {
    this._cust_id = obj['cust_id'];
    this._cust_name = obj['cust_name'];
    this._cust_contact = obj['cust_contact'];
    this._cust_owner_name = obj['cust_owner_name'];
    this._cust_lat = obj['cust_lat'];
    this._cust_long = obj['cust_long'];
    this._cust_address = obj['cust_address'];
    this._cust_pembayaran = obj['cust_pembayaran'];
    this._id  = obj['id'];
  }

  String get cust_id => _cust_id;
  String get cust_name => _cust_name;
  String get cust_contact => _cust_contact;
  String get cust_owner_name => _cust_owner_name;
  String get cust_lat => _cust_lat;
  String get cust_long => _cust_long;
  String get cust_address => _cust_address;
  String get cust_pembayaran => _cust_pembayaran;
  int get id => _id;
  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["cust_id"] = _cust_id;
    map["cust_name"] = _cust_name;
    map["cust_contact"] = _cust_contact;
    map["cust_owner_name"] = _cust_owner_name;
    map["cust_lat"] = _cust_lat;
    map["cust_long"] = _cust_long;
    map["cust_address"] = _cust_address;
    map["cust_pembayaran"] = _cust_pembayaran;
    return map;
  }
}