import 'package:flutter/cupertino.dart';

class ChangeSign with ChangeNotifier{

  bool _StandardSign = true;
  bool _current = true;
  var _SelectedValue = int.parse('1');
  var _index = 0;

  //login or sign up 상태관리 함수(bool 값울 알려주는 함수이다.)
  bool getStandardSign() => _StandardSign;
  bool getCurrent() => _current;
  dynamic getSelectedVale() => _SelectedValue;
  dynamic getIndex() => _index;

  //login or sign up 상태 변경함수
  void Change_Sign(){
    _StandardSign = !_StandardSign;
    notifyListeners();
  }

  //로그인 노로그인 상태 변수 변경함
  void Change_Current(){
    _current =!_current;
    notifyListeners();
  }

  void ChangSelectedVale(int selectnum){
    _SelectedValue = selectnum;
    notifyListeners();
  }
}