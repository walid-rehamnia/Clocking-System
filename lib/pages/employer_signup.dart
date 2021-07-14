import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; //To save data locally
import 'package:dio/dio.dart';
import 'package:test_otp/pages/employer_badge.dart';

class EmployerSignUp extends StatefulWidget {
  const EmployerSignUp({Key key}) : super(key: key);

  @override
  _EmployerSignUpState createState() => _EmployerSignUpState();
}

class _EmployerSignUpState extends State<EmployerSignUp> {
  String serverAdress = "https://dla-api.com/walid/";
  String errorMsg = "";
  String result = "";

  TextEditingController usernameControl = TextEditingController();
  TextEditingController passwordControl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Column(
        children: [
          SizedBox(height: 40),
          TextField(
            decoration: InputDecoration(
              hintText: 'User Name',
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.amber[200]),
              ),
            ),
            cursorColor: Colors.amberAccent[200],
            cursorHeight: 20,
            cursorWidth: 2,
            style: TextStyle(
                color: Colors.amberAccent[200],
                fontSize: 25,
                fontWeight: FontWeight.bold),
            controller: usernameControl,
          ),
          TextField(
            decoration: InputDecoration(
              hintText: 'Password',
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.amber[200]),
              ),
            ),
            cursorColor: Colors.amberAccent[200],
            cursorHeight: 20,
            cursorWidth: 2,
            style: TextStyle(
                color: Colors.amberAccent[200],
                fontSize: 25,
                fontWeight: FontWeight.bold),
            controller: passwordControl,
            obscureText: true,
          ),
          SizedBox(height: 35),
          Container(
            height: 50.0,
            margin: EdgeInsets.all(10),
            child: RaisedButton(
              color: Colors.grey[900],
              onPressed: () {
                print("button");
                employerLogin(usernameControl.text, passwordControl.text);
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
                      BoxConstraints(maxWidth: 100.0, minHeight: 100.0),
                  alignment: Alignment.center,
                  child: Text(
                    "Log In",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.amberAccent[200],
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            "$errorMsg",
            style: TextStyle(
                color: Colors.amber.shade900,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void employerLogin(String user, String password) async {
    try {
      Response response = await Dio().get(serverAdress +
          'employerLogin?username=' +
          user +
          '&password=' +
          password);
      Map data = response.data;
      if (data['token'].toString().compareTo('null') != 0) {
        _setKey('token', data['token'].toString()); //saving the token local
        _setKey('id', data['id'].toString()); //saving the token local
        _setKey('secret', data['secret'].toString()); //saving the token local

        //moving to scan page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Badge()),
        );
      } else {
        setState(() {
          errorMsg = data['error'];
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void _setKey(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }
} //class
