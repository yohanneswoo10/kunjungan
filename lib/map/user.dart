class User {
  String _username ="";
  String _password ="";
  String _status ="";
  int _id =0;

  User(this._username, this._password, this._status); //Constructor

  User.map(dynamic obj) {
    this._username = obj['username'];
    this._password = obj['password'];
    this._status = obj['status'];
    this._id  = obj['id'];
  }

  String get username => _username;
  String get password => _password;
  String get status => _status;
  int get id => _id;
  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["username"] = _username;
    map["password"] = _password;
    map["status"] = _status;
    return map;
  }
}