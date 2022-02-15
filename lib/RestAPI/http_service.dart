import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:soultec/Data/Object/user_object.dart';
import 'package:soultec/Data/Object/receipt_object.dart';

class Http_services {
  //http 통신 url
  String login_url =
      "http://ec2-3-38-104-80.ap-northeast-2.compute.amazonaws.com:8080/api/authenticate";
  String car_url_post = "";
  String post_url = "";
  String user_info_url = "";

  //로그인후 반환할 user 객체
  User? user;

  Future<void> initConnectivity() async {
    print("start ");
    var connectivityResult = await (Connectivity().checkConnectivity());
    print(connectivityResult.toString());
    if (connectivityResult == ConnectivityResult.mobile) {
      print("mobile");
      // I am connected to a mobile network.
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      print("wifi");
    } else if (connectivityResult.toString() == "ConnectivityResult.none") {
      return null;
    }
  }

  //http 로그인
  Future<User?> login(id, pw, ischeck) async {
    print("start");
    print(id);
    print(pw);
    print(ischeck);

    //url 로 post(이메일 컨트롤러 , 패스워드 컨트롤러)
    var res = await http.post(Uri.parse(login_url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'username': id, 'password': pw}));
    print("seddd");
    print(res.body);

    //statusCode 확인해볼것
    if (res.statusCode == 200) {
      //디코딩후 res body 를 user 객체로 대입
      user = User.fromJson(jsonDecode(res.body));
      print("300");
      print(user!.token);
      if (ischeck) {
        //자동로그인 체크를 했을경우 해당 id,pw 를 디스크에 저장한다.
        save_user(id,pw);
        return user;
      } else {
        //자동 로그인을 체크하지 않았을때 http 에서 전달받은 user 객체만 return 해준다.
        return user;
        //디스크에 해당 user id,pw 저장후 로그인

      }
    } else {
      return null;
    }
  }


  //http 자동 로그인
   Future<User?> auto_login(id, pw) async {
    //url 로 post(이메일 컨트롤러 , 패스워드 컨트롤러)

    var res = await http.post(Uri.parse(login_url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'username': id, 'password': pw}));


    print(res.body);

    if (res.statusCode == 200) {
      //디코딩후 res body 를 user 객체로 대입
      //디코딩후 res body 를 user 객체로 대입
      user = User.fromJson(jsonDecode(res.body));
      print("300");
      print(user!.token);
      return user;
      //디스크에 해당 user id,pw 저장후 로그인

    } else {
      return null;
    }
  }

  //http 로그인
  Future test(token) async {
    print("sed");
    final response =
        await http.get(Uri.parse("http://3.38.104.80:8080/api/user"), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    print(response.body);
    if (response.statusCode == 200) {
      print("200");
      return response;
    } else {
      print("nulll");
      return null;
    }
  }

  //user information 저장 함수
  void save_user(user_id,user_pw) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
        'check_login', "true"); //추후 자동 로그인 여부를 확인하는 disk information
    prefs.setString('id',user_id);
    prefs.setString('pw',user_pw);
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
    print(data[0]);
    print(data[1]);
    print("hh");
    return data;
  }

  //http 차량 번호 post함수
  Future<String?> post_carnumber(car_number, token) async {
    //url 로 post(이메일 컨트롤러 , 패스워드 컨트롤러)
    var res = await http.post(
      Uri.parse(car_url_post),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'car-number': car_number,
      }),
    );

    print(res);

    if (res.statusCode == 200) {
      return car_number;
    } else {
      return null;
    }
  }

  //http post
  Future post_receipt(liter, date, car_number, user_id, token) async {
    //url 로 post(이메일 컨트롤러 , 패스워드 컨트롤러)
    var res = await http.post(Uri.parse(post_url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        //인코딩
        body: json.encode({
          'liter': liter,
          'date': date,
          'car_number': car_number,
          'user_id': user_id,
        }));
    if (res.statusCode == 200) {
      return res;
    } else {
      return null;
    }
  }

  //user 이용내역 list http get
  Future<List<dynamic>?> load_receipt_list() async {
    var _datas = [];
    final response = await http.get(
          Uri.parse(user_info_url),
          headers: {
            HttpHeaders.authorizationHeader: "Basic your_api_token_here"
          },
        ),
        _text = utf8.decode(response.bodyBytes);
    var dataObjsJson = jsonDecode(_text)['data'] as List;
    final List<Receipt_object> parsedResponse =
        dataObjsJson.map((e) => Receipt_object.fromJson(e)).toList();

    _datas.addAll(parsedResponse);

    return _datas;
  }
}
