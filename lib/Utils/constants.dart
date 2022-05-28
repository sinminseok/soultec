import 'package:flutter/material.dart';


const kPrimaryColor = Color(0xffbec8bb);
const kBackgroundColor = Color(0XFFE5E5E5);

//수신 ble uuid
class BLE_UUID {



  String POST_SERVICE_UUID = "6E400001-B5A3-F393-E0A9-E50E24DCCA9E";

  String POST_CHARACTERISTIC_UUID_RX = "6E400002-B5A3-F393-E0A9-E50E24DCCA9E";

  String POST_CHARACTERISTIC_UUID_TX = "6E400003-B5A3-F393-E0A9-E50E24DCCA9E";


}

class Http_Url {
//http 통신 url
  String login_url =
      "http://ec2-52-78-179-152.ap-northeast-2.compute.amazonaws.com:8080/api/authenticate";
  String receive_login_url =
      "http://ec2-52-78-179-152.ap-northeast-2.compute.amazonaws.com:8080/api/receive-goods/login";

  String receive_tank ="http://ec2-52-78-179-152.ap-northeast-2.compute.amazonaws.com:8080/api/receive-goods/is-tank-id";

  String receive_post_receipt = "http://ec2-52-78-179-152.ap-northeast-2.compute.amazonaws.com:8080/api/receive-goods";


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
