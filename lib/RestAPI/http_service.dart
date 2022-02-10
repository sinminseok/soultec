import 'dart:convert';
import 'dart:core';

import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:soultec/Data/User/user_object.dart';
import 'package:soultec/Data/receip_http.dart';



class Http_services {

  String url = "";
  String car_url_post="";
  String post_url = "";
  User? user;

  //http 로그인
  Future<User?> login(id,pw,ischeck) async {
    //url 로 post(이메일 컨트롤러 , 패스워드 컨트롤러)
    var res = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user-id': id,
          'password': pw
        }));

    //statusCode 확인해볼것
    if (res.statusCode == 200) {
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
    var res = await http.post(Uri.parse(url),
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
    prefs.setString('check_login', "true");
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
        headers: {'Content-Type': 'application/json'},
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
        headers: {'Content-Type': 'application/json'},
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
    final response = await http.get(Uri.parse(url)),
        _text = utf8.decode(response.bodyBytes);
    var dataObjsJson = jsonDecode(_text)['data'] as List;
    final List<Receipt_object> parsedResponse =  dataObjsJson.map((e) => Receipt_object.fromJson(e)).toList();

      _datas.addAll(parsedResponse);

      return _datas;

  }







}