import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dart_otp/dart_otp.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';
import 'package:shared_preferences/shared_preferences.dart'; //To save data locally
import 'package:test_otp/pages/employer_signup.dart';
import 'package:device_information/device_information.dart';

class Badge extends StatefulWidget {
  const Badge({Key key}) : super(key: key);

  @override
  _BadgeState createState() => _BadgeState();
}

class _BadgeState extends State<Badge> {
  String id = "false", secret = "false", imei = "false";
  TOTP totp;

  String currentOtp = "";
  String qrValue1 = "";
  String qrValue2 = "";
  Timer timer;

  void up() {
    setState(() {
      currentOtp = '{"otp":${totp.now()}';
      qrValue2 = currentOtp + qrValue1;
    });
  }

  @override
  void initState() {
    TOTP totp = TOTP(secret: secret); //surely the local secret exist
    timer = Timer.periodic(Duration(seconds: 0), (Timer t) => up());
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkThenRoute());
    Timer t = Timer.periodic(Duration(seconds: 1), (result) {
      setState(() {});
    });
    super.initState();
  }

//Design

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text('Employer Badge'),
        centerTitle: true,
        backgroundColor: Colors.grey[850],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Peresent your code to the Agent",
              style: TextStyle(
                  color: Colors.amberAccent[200],
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            Container(
              height: 300.0,
              width: 300.0,
              padding: EdgeInsets.all(20.0),
              child: SfBarcodeGenerator(
                backgroundColor: Colors.grey[800],
                barColor: Colors.amber,
                value: "$qrValue2",
                symbology: QRCode(),
                showValue: false,
                textStyle: TextStyle(
                  color: Colors.grey[100],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> getImeis() async {
    return await DeviceInformation.deviceIMEINumber;
  }

  Future<String> _getKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getString(key) ?? "false");
  }

  _checkThenRoute() async {
    try {
      id = await _getKey('id'); //search if there is an id
      if (id.compareTo("false") == 0) {
        //mean no id stored in device;we need to brin them again
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => EmployerSignUp()),
        );
      } else {
        //the employer have already an id (was login before)
        imei = await getImeis(); //get imei
        secret = await _getKey('secret');
        totp = TOTP(secret: secret); //initialize the secret
        qrValue1 = ',"id":$id,"imei":$imei}';
      }
    } catch (ex) {
      print("_checkSecretThenRoute : $ex");
    }
  }
}
