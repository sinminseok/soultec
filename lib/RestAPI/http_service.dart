import 'dart:convert';
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soultec/Data/Object/car_object.dart';
import 'package:soultec/Data/Object/user_object.dart';
import 'package:soultec/Data/Object/receipt_object.dart';

class Http_services with ChangeNotifier {
  //로그인후 반환할 user 객체
  User_token? _user_token;
  User? _user_info;
  String? _user_id;
  String? _carnumber;

  User_token? get user_token => _user_token;

  User? get user_info => _user_info;

  String? get user_id => _user_id;

  String? get carnumber => _carnumber;

  //http 통신 url
  String login_url =
      "http://ec2-3-38-104-80.ap-northeast-2.compute.amazonaws.com:8080/api/authenticate";
  String get_user_info_url =
      "http://ec2-3-38-104-80.ap-northeast-2.compute.amazonaws.com:8080/api/users";
  String car_url_post =
      "http://ec2-3-38-104-80.ap-northeast-2.compute.amazonaws.com:8080/api/cars/numbers/{number} ";
  String post_url =
      "http://ec2-3-38-104-80.ap-northeast-2.compute.amazonaws.com:8080/api/fill-logs ";

  //http 로그인
  Future<User_token?> login(id, pw, ischeck) async {
    //url 로 post(이메일 컨트롤러 , 패스워드 컨트롤러)
    var res = await http.post(Uri.parse(login_url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'username': id, 'password': pw}));

    print("Dddd");
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
    var res = await http.get(Uri.parse(get_user_info_url), headers: {
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

  //http 자동 로그인
  Future<User_token?> auto_login(id, pw) async {
    //url 로 post(이메일 컨트롤러 , 패스워드 컨트롤러)
    var res = await http.post(Uri.parse(login_url),
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

  //user information 저장 함수
  void save_user(user_id, user_pw) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
        'check_login', "true"); //추후 자동 로그인 여부를 확인하는 disk information

    prefs.setString('id', user_id);
    prefs.setString('pw', user_pw);
    return;
  }

  get_userinfo() async {
    final prefs = await SharedPreferences.getInstance();
    var data = [];
// counter 키에 해당하는 데이터 읽기를 시도합니다. 만약 존재하지 않는 다면 0을 반환합니다.
    var user_id_disk = prefs.getString('id');
    data.add(user_id_disk);

    var user_pw_disk = prefs.getString('pw');
    data.add(user_pw_disk);
    return data;
  }

  //http 차량 번호 post함수
  Future<List<dynamic>?> post_carnumber(number, token) async {
    var data_list = [];
    // /cars/branchId/carNumbers/{number}
    //url 로 post(이메일 컨트롤러 , 패스워드 컨트롤러)
    var res = await http.get(
      Uri.parse(
          "http://ec2-3-38-104-80.ap-northeast-2.compute.amazonaws.com:8080/api/cars/branchId/carNumbers/$number"),
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

      print(data_list);
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
    var res = await http.post(
        Uri.parse(
            "http://ec2-3-38-104-80.ap-northeast-2.compute.amazonaws.com:8080/api/fill-logs/users"),
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
      Uri.parse(
          "http://ec2-3-38-104-80.ap-northeast-2.compute.amazonaws.com:8080/api/fill-logs/users"),
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
