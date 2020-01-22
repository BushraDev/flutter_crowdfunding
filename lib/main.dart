import 'package:flutter_crowdfunding/Home.dart';
import 'package:flutter_crowdfunding/SignUp.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(new MaterialApp(
      title: "Crowdfunding",
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: Home(),
    ));
