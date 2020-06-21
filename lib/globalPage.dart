import 'package:flutter/material.dart';
import 'dart:async';
import 'package:tag10/authentication.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class globalScreen extends StatelessWidget {
  globalScreen({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  String username = Firestore.instance.collection('users').document(this.userId).

  bool checkIfUsername() async{
  DocumentSnapshot ds = await reference.collection("users").document(this.userId).get("username");
  this.setState(() {
  isLiked = ds.exists;
  });

}

  Widget titleSection = Container(
    padding: const EdgeInsets.all(32),
    child: Row(
      children: [

        Expanded(
          /*1*/
          child: Text('WolframAlpha',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        SizedBox(
          height:  40,
          width: 40,
          child: IconButton(
            padding: EdgeInsets.all(0.0),
            color: Colors.yellow[500],
            icon: Icon(Icons.edit,size:40,color:Colors.yellow[500]),
            onPressed: null,
          ),
        )
      ],
    ),
  );

  signOut() async {
    try {
      await auth.signOut();
      logoutCallback();
    } catch (e) {
      print(e);
    }
  }

  Widget GlobalText = Container(
    padding: const EdgeInsets.all(32),
    child: Text("Global Cooldown",
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: 50,
          fontWeight: FontWeight.bold,
          color: Colors.blue[500]
      ),
    ),
  );

  Widget build (BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Global Tag 10"),
        actions: <Widget>[
          new FlatButton(
              child: new Text('Logout',
                  style: new TextStyle(fontSize: 17.0, color: Colors.white)),
              onPressed: signOut)
        ],
      ),
      body: ListView(
        children: [titleSection,
          GlobalText,
          ReadyWidget()],
      ),
    );
  }
}


class ReadyWidget extends StatefulWidget {
  @override
  _ReadyWidgetState createState() => _ReadyWidgetState();
}

class _ReadyWidgetState extends State<ReadyWidget> {
  bool _isReady = true;
  int _countRef = 120;
  int _countDown = 120;
  Timer _timer;
  String _timeString = "00:00";

  void _startTimer() {
    _changeReady();
    _changeTime();
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) => setState(
            () {
          if (_countDown < 1) {
            timer.cancel();
            setState(() {
              _countDown = 0;
              _isReady = true;
            });
          } else {
            setState(() {
              _countDown = _countDown - 1;
              _timeString = _changeTime();
            }
            );
          }
        },
      ),
    );
  }

  String _changeTime() {
    int totalHolder = _countDown;
    int _minutes = 0;
    int _seconds = 0;

    _seconds = totalHolder % 60;
    totalHolder = totalHolder - _seconds;

    _minutes = (totalHolder / 60).floor();

    if (_minutes > 9){
      if (_seconds > 9){
        return _minutes.toString() + ":" + _seconds.toString();
      } else {
        return _minutes.toString() + ":0" + _seconds.toString();
      }
    } else {
      if (_seconds > 9) {
        return "0" + _minutes.toString() + ":" + _seconds.toString();
      } else{
        return "0" + _minutes.toString() + ":0" + _seconds.toString();
      }
    }

  }

  void _changeReady() {
    setState(() {
      if (_isReady) {
        _isReady = false;
        _countDown = _countRef;
      } else {
        _isReady = true;
      }
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isReady) {
      return Column(
          children: [Container(padding: const EdgeInsets.all(32),
            child: Text("00:00",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 100,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[500]
              ),
            ),),
            Container(
              padding: const EdgeInsets.all(32),
              alignment: Alignment.center,
              child: ButtonTheme(
                height: 80,
                child: OutlineButton(
                  onPressed: _startTimer,
                  child: Text("Tag10", style: TextStyle(color: Colors.yellow[400],
                      fontWeight: FontWeight.bold,
                      fontSize: 60)),
                  borderSide: BorderSide(
                      color: Colors.amber,
                      style: BorderStyle.solid,
                      width: 4
                  ),
                ),
              ),
            ),]
      );
    } else {
      return Column(
          children: [Container(padding: const EdgeInsets.all(32),
            child: Text(_timeString,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 100,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[500]
              ),
            ),),
            Container(
              padding: const EdgeInsets.all(32),
              alignment: Alignment.center,
              child: ButtonTheme(
                height: 80,
                child: OutlineButton(
                  child: Text("Tag10", style: TextStyle(color: Colors.grey[400],
                      fontWeight: FontWeight.bold,
                      fontSize: 60)),
                  borderSide: BorderSide(
                      color: Colors.grey,
                      style: BorderStyle.solid,
                      width: 4
                  ),
                ),
              ),
            ),]
      );
    }
  }
}