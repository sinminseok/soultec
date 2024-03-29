

import 'dart:convert';
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soultec/Utils/constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../Utils/toast.dart';
import '../Model/Car_Model.dart';
import '../Model/Receipt_Model.dart';
import '../Model/User_Model.dart';

class Http_services with ChangeNotifier {
  //로그인후 반환할 user 객체
  User_token? _user_token;
  User? _user_info;
  String? _user_id;
  String? _carnumber;

  //false 일때 튜토리얼 모드 켜져있는거 true일때 꺼져있는거
  String? _check_tutorial;

  User_token? get user_token => _user_token;

  User? get user_info => _user_info;

  String? get user_id => _user_id;

  String? get carnumber => _carnumber;

  String? get check_tutorial => _check_tutorial;

  //튜토리얼 모드 체크 함수
  void change_tutorial() async {
    final prefs = await SharedPreferences.getInstance();
    _check_tutorial = prefs.getString("check_tutorial");

    if (_check_tutorial != null) {
      prefs.remove("check_tutorial");
      showtoast("튜토리얼 모드가 꺼졌습니다.");
    }
    if (_check_tutorial == null) {
      prefs.setString("check_tutorial", "true");
      showtoast("튜토리얼 모드가 켜졌습니다.");
    }

    notifyListeners();

  }

  //http 로그인
  Future<User_token?> login(id, pw, ischeck) async {
    //url 로 post(이메일 컨트롤러 , 패스워드 컨트롤러)
    var res = await http.post(Uri.parse(Http_Url().login_url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'username': id, 'password': pw}));
    print("ggg");
    print(res.body);

    //정상 로그인 http statuscode 200
    if (res.statusCode == 200) {
      //디코딩후 res body 를 user 객체로 대입
      _user_token = User_token.fromJson(jsonDecode(res.body));
      _user_id = id;
      notifyListeners();
      if (ischeck) {
        //자동로그인 체크를 했을경우 해당 id,pw 를 디스크에 저장한다.
        save_user(id, pw);
        var _usertoken = User_token.fromJson(json.decode(res.body));
        return _usertoken;
      } else {
        var _usertoken = User_token.fromJson(json.decode(res.body));
        //자동 로그인을 체크하지 않았을때 http 에서 전달받은 user 객체만 return 해준다.
        return _usertoken;
        //디스크에 해당 user id,pw 저장후 로그인
      }
    }

    //로그인 실패
    if (res.statusCode == 400 || res.statusCode == 401) {
      User_token _usertoken = new User_token();
      _usertoken.error = "error";
      //자동 로그인을 체크하지 않았을때 http 에서 전달받은 user 객체만 return 해준다.
      return _usertoken;
    } else {
      return null;
    }
  }

  //http userinformation 가져오기
  Future<User?> get_user_info(token) async {
    var res = await http.get(Uri.parse(Http_Url().get_user_info_url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });



    //statusCode 확인해볼것
    if (res.statusCode == 200) {
      _user_info = User.fromJson(jsonDecode(res.body));
      notifyListeners();
      return _user_info;
    } else {
      return null;
    }
  }


  // Future<User?> func_of_delete()async{
  //   var res = await http.get(Uri.parse(Http_Url().get_user_info_url),headers: {
  //     'Content-Typr'
  //   })

 // }

  //http 자동 로그인
  Future<User_token?> auto_login(id, pw) async {

    //url 로 post(이메일 컨트롤러 , 패스워드 컨트롤러)
    var res = await http.post(Uri.parse(Http_Url().login_url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'username': id, 'password': pw}));

    if (res.statusCode == 200) {
      User_token? userr_token = User_token.fromJson(jsonDecode(res.body));
      this._user_token = userr_token;
      this._user_id = id;
      notifyListeners();
      return _user_token;
      //디스크에 해당 user id,pw 저장후 로그인
    } else {
      return null;
    }
  }

  void logout() async {
    final storage = FlutterSecureStorage();
    _user_token = null;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
        'check_login', "true"); //추후 자동 로그인 여부를 확인하는 disk information
    storage.delete(key: 'id');
    storage.delete(key: 'pw');
    prefs.remove("check_login");
    notifyListeners();
    return;
  }

  //user information 저장 함수
  void save_user(user_id, user_pw) async {
    final storage = new FlutterSecureStorage(); //flutter_secure_storage 사용을 위한 초기화 작업
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
        'check_login', "true"); //추후 자동 로그인 여부를 확인하는 disk information
    // prefs.setString('id', user_id);
    // prefs.setString('pw', user_pw);
    await storage.write(
        key: "id",
        value: user_id);
    await storage.write(
        key: "pw",
        value: user_pw);
    return;
  }

  //자동 로그인시 디스크에 저장된 정보 가져오는 함수
  get_userinfo() async {
    final storage = new FlutterSecureStorage();
    var data = [];
// counter 키에 해당하는 데이터 읽기를 시도합니다. 만약 존재하지 않는 다면 0을 반환합니다.
    var user_id_disk = await storage.read(key: "id");
    data.add(user_id_disk);

    var user_pw_disk = await storage.read(key: "pw");
    data.add(user_pw_disk);
    return data;
  }

  //http 차량 번호 post함수
  Future<List<dynamic>?> post_carnumber(number, token) async {
    var data_list = [];
    var res = await http.get(
      Uri.parse(Http_Url().post_carnumber_url + "$number"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    final decodeData = utf8.decode(res.bodyBytes);
    final data = jsonDecode(decodeData);

    if (res.statusCode == 200) {
      _carnumber = number;
      for (int i = 0; i < data.length; i++) {
        Car car;
        car = Car.fromJson(data[i]);
        data_list.add(car);
      }
      notifyListeners();
      return data_list;
    } else {
      return null;
    }
  }

  //http post
  Future post_receipt(pumpId, amount, carNumber, token) async {
    //pumbId 는 노르딕에서 가져오는 것 (메모리 할당)
    //url 로 post(이메일 컨트롤러 , 패스워드 컨트롤러)
    var res = await http.post(Uri.parse(Http_Url().post_receipt_url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        //인코딩
        body: json.encode({
          'pumpId': pumpId.toString(),
          'amount': amount,
          'carNumber': carNumber,
        }));
    if (res.statusCode == 200) {
      return res;
    } else {
      return null;
    }
  }

  //user 이용내역 list http get
  Future<List<dynamic>?> load_receipt_list(token) async {
    var data_list = [];
    final response = await http.get(
      Uri.parse(Http_Url().receipt_list_url),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    //한글 깨지는거 인코딩으로 감싸줌
    final decodeData = utf8.decode(response.bodyBytes);
    final data = jsonDecode(decodeData);

    for (int i = 0; i < data.length; i++) {
      Receipt_object receipt_object;
      receipt_object = Receipt_object.fromJson(data[i]);
      data_list.add(receipt_object);
    }

    if (response.statusCode == 200) {
      return data_list;
    } else {
      return null;
    }
  }
}