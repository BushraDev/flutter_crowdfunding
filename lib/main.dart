import 'package:flutter_crowdfunding/CreateCampaign.dart';
import 'package:flutter_crowdfunding/Home.dart';
import 'package:flutter_crowdfunding/SignUp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crowdfunding/SplashScreen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Login.dart';

void main() => runApp(new MaterialApp(
      title: "Crowdfunding",
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: Splash(),
    ));
class test extends StatefulWidget {
  @override
  _testState createState() => _testState();
}

class _testState extends State<test>
{
  @override
  Widget build(BuildContext context)
  {
    getStringValuesSF().then((type){
      print(type);
    });
    return Container();
  }

  Future <String> getStringValuesSF() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String type = prefs.getString('type');
    return type;
  }
}

