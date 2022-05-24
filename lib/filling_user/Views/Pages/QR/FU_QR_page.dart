import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_qr_bar_scanner/qr_bar_scanner_camera.dart';

import 'package:soultec/Utils/constants.dart';
import '../../../../Utils/top_widget.dart';
import 'package:wakelock/wakelock.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

import '../Fill/FU_fill_setting.dart';

class FU_QR_page extends StatefulWidget {
  BluetoothDevice? device;

  FU_QR_page({required this.device});

  @override
  State<FU_QR_page> createState() => _FU_QR_pageState();
}

class _FU_QR_pageState extends State<FU_QR_page> {
  String? _qrInfo;
  bool _canVibrate = true;
  bool _camState = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  /// 초기화 함수
  _init() async {
    bool canVibrate = await Vibrate.canVibrate;
    setState(() {
      // 화면 꺼짐 방지
      Wakelock.enable();

      // QR 코드 스캔 관련
      _camState = true;

      // 진동 관련
      _canVibrate = canVibrate;
      _canVibrate
          ? debugPrint('This device can vibrate')
          : debugPrint('This device cannot vibrate');
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// QR/Bar Code 스캔 성공시 호출
  _qrCallback(String? code) {
    setState(() {
      // 동일한걸 계속 읽을 경우 한번만 소리/진동 실행..
      if (code != _qrInfo) {
        if (_canVibrate) Vibrate.feedback(FeedbackType.heavy); // 진동
      }
      _camState = false;
      _qrInfo = code;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return _qrInfo != null
        ? FU_Fill_Setting(sizee: size, qr_info: _qrInfo)
        : Scaffold(
            backgroundColor: kPrimaryColor,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Top_widget(),
                Text(
                  "QR코드를 맞춰주세요.",
                  style: TextStyle(fontSize: 27),
                ),
                SizedBox(
                  height: size.height * 0.1,
                ),
                Center(
                  child: Container(
                    height: size.height * 0.4,
                    width: size.width * 0.8,
                    child: QRBarScannerCamera(
                      // 에러 발생시..
                      onError: (context, error) => Text(
                        error.toString(),
                        style: TextStyle(color: Colors.red),
                      ),
                      // QR 이 읽혔을 경우
                      qrCodeCallback: (code) {
                        _qrCallback(code);
                      },
                    ),
                  ),
                ),

                /// 사이즈 자동 조절을 위해 FittedBox 사용
                // FittedBox(
                //     fit: BoxFit.fitWidth,
                //     child: Text(_qrInfo!, style: const TextStyle(fontWeight: FontWeight.bold),)
                // ),
                SizedBox(
                  height: size.height * 0.1,
                ),
                Text(
                  "QR코드가 맞춰지면 자동으로 조회 됩니다.",
                  style: TextStyle(fontSize: size.width * 0.05),
                )
              ],
            ));
  }
}
