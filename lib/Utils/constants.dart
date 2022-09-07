import 'package:flutter/material.dart';


const kPrimaryColor = Color(0xffbec8bb);
const kBackgroundColor = Color(0XFFE5E5E5);

//수신 ble uuid
class BLE_UUID {



  final String POST_SERVICE_UUID = "6E400001-B5A3-F393-E0A9-E50E24DCCA9E";

  final String POST_CHARACTERISTIC_UUID_RX = "6E400002-B5A3-F393-E0A9-E50E24DCCA9E";

  final String POST_CHARACTERISTIC_UUID_TX = "6E400003-B5A3-F393-E0A9-E50E24DCCA9E";


}

class Http_Url {
//http 통신 url
  final String login_url =
      "http://ec2-52-78-179-152.ap-northeast-2.compute.amazonaws.com:8080/api/authenticate";
  final String receive_login_url =
      "http://ec2-52-78-179-152.ap-northeast-2.compute.amazonaws.com:8080/api/receive-goods/login";

  final String receive_tank ="http://ec2-52-78-179-152.ap-northeast-2.compute.amazonaws.com:8080/api/receive-goods/is-tank-id";

  final String receive_post_receipt = "http://ec2-52-78-179-152.ap-northeast-2.compute.amazonaws.com:8080/api/receive-goods";


  final String get_user_info_url =
      "http://ec2-52-78-179-152.ap-northeast-2.compute.amazonaws.com:8080/api/users";
  final String car_url_post =
      "http://ec2-52-78-179-152.ap-northeast-2.compute.amazonaws.com:8080/api/cars/numbers/{number} ";
  final String post_receipt_url =
      "http://ec2-52-78-179-152.ap-northeast-2.compute.amazonaws.com:8080/api/fill-logs/users";
  final String receipt_list_url =
      "http://ec2-52-78-179-152.ap-northeast-2.compute.amazonaws.com:8080/api/fill-logs/users";
  final String post_carnumber_url =
      "http://ec2-52-78-179-152.ap-northeast-2.compute.amazonaws.com:8080/api/cars/branchId/carNumbers/";
}
