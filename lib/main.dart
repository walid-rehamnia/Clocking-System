import 'package:flutter/material.dart';
import 'package:test_otp/pages/agent_scan.dart';
import 'package:test_otp/pages/employer_badge.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Clocking App',
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text('Clocking System'),
        centerTitle: true,
        backgroundColor: Colors.grey[850],
      ),
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 50),
            Container(
              height: 50.0,
              margin: EdgeInsets.all(10),
              child: RaisedButton(
                color: Colors.grey[900],
                onPressed: () {
                  setState(() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AgentScan()),
                    );
                  });
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
                      "Agent",
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
            SizedBox(height: 50),
            Container(
              height: 50.0,
              margin: EdgeInsets.all(10),
              child: RaisedButton(
                color: Colors.grey[900],
                onPressed: () {
                  setState(() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Badge()),
                    );
                  });
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
                      "Employer",
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
          ],
        ),
      ),
    );
  }
}
