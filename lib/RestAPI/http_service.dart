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
  String login_url = "";
  String car_url_post="";
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
    }
    else if( connectivityResult.toString() == "ConnectivityResult.none"){
      return null;
    }
  }

  //http 로그인
  Future<User?> login(id,pw,ischeck) async {
    //url 로 post(이메일 컨트롤러 , 패스워드 컨트롤러)
    var res = await http.post(Uri.parse(login_url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user-id': id,
          'password': pw
        }));

    //statusCode 확인해볼것
    if (res.statusCode == 200) {
      //디코딩후 res body 를 user 객체로 대입
      user =User.fromJson(jsonDecode(res.body));
      if (ischeck) {
        save_user(id,pw);
        return user;
      } else {
        return user;
        //디스크에 해당 user id,pw 저장후 로그인

      }
    } else {
      return user;
    }
  }

  //http 자동 로그인
  Future<User?> auto_login(user_id,user_pw) async {
    //url 로 post(이메일 컨트롤러 , 패스워드 컨트롤러)
    var res = await http.post(Uri.parse(login_url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user-id': user_id,
          'password': user_pw
        }));

    print(res.body);

    user = res as User?;

    if (user != null) {
      {
        return user;
        //디스크에 해당 user id,pw 저장후 로그인

      }
    } else {
      return null;
    }
  }

  //user information 저장 함수
  void save_user(user_id ,user_pw) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('check_login', "true"); //추후 자동 로그인 여부를 확인하는 disk information
    prefs.setString('id', user_id);
    prefs.setString('pw', user_pw);
    return;
  }

  //디스크 저장 user information 가져오는 함수
  Future<List<dynamic>?> get_userinfo() async {
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
  Future<String?> post_carnumber(car_number) async {
    //url 로 post(이메일 컨트롤러 , 패스워드 컨트롤러)
    var res = await http.post(Uri.parse(car_url_post),
        //해당 유저의 토큰을 헤더에 담아 넘겨줘야한다.
        headers: {HttpHeaders.authorizationHeader: "Basic your_api_token_here",'Content-Type': 'application/json'},
        body: json.encode({
          'car-number': car_number,
        }));

    if(res.statusCode == 200){
      return car_number;

    }else {
      return null;
    }
  }

  //http post
  Future post_receipt(liter,date,car_number,user_id,) async {
    //url 로 post(이메일 컨트롤러 , 패스워드 컨트롤러)
    var res = await http.post(Uri.parse(post_url),
        headers: {HttpHeaders.authorizationHeader: "Basic your_api_token_here",'Content-Type': 'application/json'},


        //인코딩
        body: json.encode({
          'liter': liter,
          'date': date,
          'car_number':car_number,
          'user_id':user_id,
        }));
    print(res.body);
  }


  //user 이용내역 list http get
  Future<List<dynamic>?> load_receipt_list() async{
    var _datas = [];
    final response = await http.get(
      Uri.parse(user_info_url),
      headers: {HttpHeaders.authorizationHeader: "Basic your_api_token_here"},),
        _text = utf8.decode(response.bodyBytes);
    var dataObjsJson = jsonDecode(_text)['data'] as List;
    final List<Receipt_object> parsedResponse =  dataObjsJson.map((e) => Receipt_object.fromJson(e)).toList();

      _datas.addAll(parsedResponse);

      return _datas;

  }







}