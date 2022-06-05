import 'dart:convert';
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:soultec/Utils/constants.dart';
import '../../Utils/toast.dart';

class FU_Http_services with ChangeNotifier {
  String? _user_id;

  String? get user_id => _user_id;

  Future<String?> receive_login(
    id,
    pw,
  ) async {
    //url 로 post(이메일 컨트롤러 , 패스워드 컨트롤러)
    var res = await http.post(Uri.parse(Http_Url().receive_login_url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'username': id, 'password': pw}));


    if (res.statusCode == 200) {
      if (res.body.toString() == "false") {
        showtoast("아이디와 비밀번호를 확인해주세요");
        return "false";
      }
      if (res.body.toString() == "true") {

        _user_id = id;
        notifyListeners();
        return "success";
      }

    }
    else{
       showtoast("네트워크를 확인해주세요");
    }
  }

  Future post_qr(tankid, id) async {
    var res = await http.post(Uri.parse(Http_Url().receive_tank),
        headers: {
          'Content-Type': 'application/json',
          // 'Accept': 'application/json',
        },
        body: json.encode({'username': id, 'tankId': tankid}));
    print("SEX");
    print(res);

    if (res.statusCode == 200) {
      if (res.body.toString() == "true") {
        showtoast("탱크에 접속 되었습니다.");
        return "success";
      }
      if (res.body.toString() == "false") {
        showtoast("QR코드를 다시 스캔하세요");
        return "false";
      }
    }
  }

  Future post_receive_receipt(int amount, int companyId, int tankId) async {
    var res = await http.post(Uri.parse(Http_Url().receive_post_receipt),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
            {'amount': amount, 'companyId': companyId, "tankId": tankId}));

    if (res.statusCode == 200) {
      return;
    } else {
      return;
    }
  }

  Future remove_account(username) async {
    var res = await http.delete(Uri.parse(Http_Url().receive_post_receipt),
        headers: {
          'Content-Type': 'application/json',
          // 'Accept': 'application/json',
        },
        body: json.encode({'username': username}));

    if (res.statusCode == 200) {
      _user_id = "";
      notifyListeners();
    } else {
      return;
    }
  }
}
