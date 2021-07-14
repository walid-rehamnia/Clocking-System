import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart'; //To save data locally
import 'package:device_information/device_information.dart';
import 'package:test_otp/pages/agent_signup.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

class AgentScan extends StatefulWidget {
  const AgentScan({Key key}) : super(key: key);

  @override
  _AgentScanState createState() => _AgentScanState();
}

class _AgentScanState extends State<AgentScan> {
  String serverAdress = "https://dla-api.com/walid/";
  String qrcodeResult = "";
  String token = "false", agent_imei = "false";
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkThenRoute());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 50.0,
              margin: EdgeInsets.all(10),
              child: RaisedButton(
                color: Colors.grey[900],
                onPressed: () {
                  _scanQrCode();
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0)),
                padding: EdgeInsets.all(0.0),
                child: Ink(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.grey[900], Colors.grey[700]],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(30.0)),
                  child: Container(
                    constraints:
                        BoxConstraints(maxWidth: 300.0, minHeight: 300.0),
                    alignment: Alignment.center,
                    child: Text(
                      "Start Scannig",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.amberAccent[200],
                          fontSize: 28,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
            Text(
              "$qrcodeResult",
              style: TextStyle(
                  color: Colors.amberAccent[200],
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  _scanQrCode() async {
    try {
      final result = await FlutterBarcodeScanner.scanBarcode("#ffbf00",
          'Cancel', true, ScanMode.QR); //color,option,flachlight,mode
      Map data = jsonDecode(result);
      String id, otp, emp_imei, token;
      //from employer device
      print("her1");
      id = data['id'].toString();
      otp = data['otp'].toString();
      emp_imei = data['imei'].toString();
      //from agent deviced
      token = await _getKey('token');
      qrScan(id, otp, emp_imei, token, agent_imei);
      print("her2");
    } catch (ex) {
      print("_scanQrCode : $ex");
    }
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
      token = await _getKey('token'); //search if there is an id
      if (token.compareTo("false") == 0) {
        //mean no id stored in device;we need to brin them again
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AgentSignUp()),
        );
      } else {
        //the employer have already an id (was login before)
        agent_imei = await getImeis(); //get imei
      }
    } catch (ex) {
      print("_checkSecretThenRoute : $ex");
    }
  }

  void _setKey(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  void qrScan(String id, String otp, String emp_imei, String token,
      String agent_imei) async {
    try {
      Response response = await Dio().get(serverAdress +
          'qrScan?id=' +
          id +
          '&otp=' +
          otp +
          '&emp_imei=' +
          emp_imei +
          '&token=' +
          token +
          '&agent_imei=' +
          agent_imei);
      print("responece ...");
      Map data = response.data;
      if (data['error'].toString().compareTo('null') != 0) {
        print("error happened");
        //error happenedP
        setState(() {
          qrcodeResult = data['error'].toString();
        });
      } else {
        setState(() {
          print(data['result'].toString());
          qrcodeResult = data['result'].toString();
        });
      }
    } catch (e) {
      print("QR SCan::" + e);
    }
  }
}
