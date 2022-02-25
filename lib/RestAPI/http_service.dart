import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:soultec/App/Pages/receipt/receipt_list.dart';
import 'package:soultec/Data/Object/user_object.dart';
import 'package:soultec/Data/Object/receipt_object.dart';

class Http_services {
  //로그인후 반환할 user 객체
  User_token? user_token;
  User? user_info;

  //http 통신 url
  String login_url =
      "http://ec2-3-38-104-80.ap-northeast-2.compute.amazonaws.com:8080/api/authenticate";
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

    print(res.body);

    //statusCode 확인해볼것
    if (res.statusCode == 200) {
      //디코딩후 res body 를 user 객체로 대입
      user_token = User_token.fromJson(jsonDecode(res.body));
      print(user_token!.token);
      if (ischeck) {
        //자동로그인 체크를 했을경우 해당 id,pw 를 디스크에 저장한다.
        save_user(id, pw);
        return user_token;
      } else {
        //자동 로그인을 체크하지 않았을때 http 에서 전달받은 user 객체만 return 해준다.
        return user_token;
        //디스크에 해당 user id,pw 저장후 로그인

      }
    } else {
      return null;
    }
  }

  //http userinformation 가져오기
  Future<User?> get_user_info(user_id, token) async {
    var res = await http.get(
        Uri.parse(
            "http://ec2-3-38-104-80.ap-northeast-2.compute.amazonaws.com:8080/api/user"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });
    print(res.body);
    //statusCode 확인해볼것
    if (res.statusCode == 200) {
      user_info = User.fromJson(jsonDecode(res.body));
      return user_info;
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
    print(res.body);
    print(res.statusCode);

    if (res.statusCode == 200) {
      user_token = User_token.fromJson(jsonDecode(res.body));

      return user_token;
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

  //디스크 저장 user information 가져오는 함수
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
  Future<bool?> post_carnumber(number, token) async {
    //url 로 post(이메일 컨트롤러 , 패스워드 컨트롤러)
    var res = await http.get(
      Uri.parse(
          "http://ec2-3-38-104-80.ap-northeast-2.compute.amazonaws.com:8080/api/cars/numbers/$number"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print(res.body);
    print(res.statusCode);
    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  //http post
  Future post_receipt(
      username, pumpId, branchId, amount, carNumber, token) async {
    //url 로 post(이메일 컨트롤러 , 패스워드 컨트롤러)
    var res = await http.post(
        Uri.parse(
            "http://ec2-3-38-104-80.ap-northeast-2.compute.amazonaws.com:8080/api/fill-logs"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        //인코딩
        body: json.encode({
          'username': username,
          'pumpId': pumpId,
          'branchId': branchId,
          'amount': amount,
          'carNumber': carNumber,
        }));

    print(res.body);
    print(res.bodyBytes);

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
