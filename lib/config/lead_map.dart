class Leads {
  String _num ="";
  String _name ="";
  String _phone ="";
  String _lat ="";
  String _long ="";

  int _id =0;

  Leads(this._num, this._name, this._phone, this._lat, this._long);

  Leads.map(dynamic obj) {
    this._num = obj['leadnumber'];
    this._name = obj['leadname'];
    this._phone = obj['leadphone'];
    this._lat = obj['leadlatitude'];
    this._long = obj['leadlongitude'];
    this._id  = obj['id'];
  }

  String get leadnumber => _num;
  String get leadname => _name;
  String get leadphone => _phone;
  String get leadlatitude => _lat;
  String get leadlongitude => _long;
  int get id => _id;
  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["leadnumber"] = _num;
    map["leadname"] = _name;
    map["leadphone"] = _phone;
    map["leadlatitude"] = _lat;
    map["leadlongitude"] = _long;
    return map;
  }
}