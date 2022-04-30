import 'package:flutter/material.dart';


const kPrimaryColor = Color(0xffbec8bb);
const kBackgroundColor = Color(0XFFE5E5E5);

//수신 ble uuid
class BLE_UUID {

  String GET_SERVICE_UUID = "";
  String GET_CHARACTERISTIC_UUID = "";

//송신 ble uuid
  String POST_SERVICE_UUID = "";
  String POST_CHARACTERISTIC_UUID = "";
}

class Http_Url {
//http 통신 url
  String login_url =
      "http://ec2-52-78-179-152.ap-northeast-2.compute.amazonaws.com:8080/api/authenticate";
  String get_user_info_url =
      "http://ec2-52-78-179-152.ap-northeast-2.compute.amazonaws.com:8080/api/users";
  String car_url_post =
      "http://ec2-52-78-179-152.ap-northeast-2.compute.amazonaws.com:8080/api/cars/numbers/{number} ";
  String post_receipt_url =
      "http://ec2-52-78-179-152.ap-northeast-2.compute.amazonaws.com:8080/api/fill-logs/users";
  String receipt_list_url =
      "http://ec2-52-78-179-152.ap-northeast-2.compute.amazonaws.com:8080/api/fill-logs/users";
  String post_carnumber_url =
      "http://ec2-52-78-179-152.ap-northeast-2.compute.amazonaws.com:8080/api/cars/branchId/carNumbers/";
}
