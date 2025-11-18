import 'package:kunjungan/config/localDb.dart';
import 'package:kunjungan/map/user.dart';
import 'package:kunjungan/presenter/rest_data.dart';

abstract class LoginPageContract {
  void onLoginSuccess(User user);
  void onLoginError(String error);
}

class LoginPagePresenter {
  LoginPageContract _view;
  RestData api = new RestData();
  LoginPagePresenter(this._view);

  doLogin(String username, String password, String status) {
    //print(username);
    var db = new localDb();
    db.checkUser(User(username,password, status)).
    then((user) => _view.onLoginSuccess(user))
        .catchError((onError) {
      //print("Trying to Catch"+onError.toString());
      return _view.onLoginError(onError.toString());
    });

  }

}