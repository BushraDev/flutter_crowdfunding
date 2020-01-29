import 'dart:convert';
import 'dart:io';
import 'package:flutter_crowdfunding/AdminDashboard.dart';
import 'package:flutter_crowdfunding/AppServer.dart';
import 'package:flutter_crowdfunding/Home.dart';
import 'package:flutter_crowdfunding/User.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as dartConverter;
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String accountName ;
  String accountPass,accountType="User";
  GlobalKey<FormState> login = new GlobalKey();
  User u;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Crowdfunding"),
      ),
      body: Container(
        margin: EdgeInsets.all(30),
        child: Form(
          key: login,
          child: ListView(
            children: <Widget>[
              CircularProfileAvatar(
                '',
                child: Image.asset("images/logo.png"),
                borderWidth: 1,
                elevation: 2,
                radius: 50,
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Name",
                  hintText: "Enter Your Name",
                  icon: Icon(Icons.account_circle),
                ),
                validator: (name) => name.isEmpty ? "Name is Required" : null,
                onSaved: (name) => accountName = name,
              ),
              SizedBox(
                height: 30,
              ),

              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  labelText: "Password",
                  hintText: "Enter Your Passowrd",
                  icon: Icon(Icons.lock_outline),
                ),
                validator: (pass) =>
                pass.isEmpty ? "Password is Required" : null,
                onSaved: (pass) => accountPass = pass,
              ),
              SizedBox(
                height: 30,
              ),
              FlatButton(
                child: Text("Log in"),
                color: Colors.purple,
                padding: EdgeInsets.all(20),
                textColor: Colors.white,
                onPressed: () {
                  if (login.currentState.validate()) {
                    login.currentState.save();

                    getUser().then((res) {

                      print(res.body);
                      String jsonsDataString =res.body;// toString of Response's body is assigned to jsonDataString
                      Map<String, dynamic> data = jsonDecode(jsonsDataString); // import 'dart:convert';
                      String result = data['result'];
                      if(result=="failed")
                        {
                          Fluttertoast.showToast(
                              msg: "logging in failed",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIos: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );
                        }
                      else
                        {
                          u = User(data["u_id"],
                              data["u_name"],
                              data["u_email"],
                              data["u_pass"],
                              data["u_photo"],
                              data["u_type"]);
                          addStringToSF().then((res){
                            if(u.u_type=="0")
                            {
                              Navigator.push(context, MaterialPageRoute(builder: (cxt) {
                                return new Home(user: true,type: u.u_type,);
                              })
                              );
                            }
                            else if(u.u_type=="1")
                            {
                              Navigator.push(context, MaterialPageRoute(builder: (cxt) {
                                return new AdminDashboard(user: true,type: u.u_type,);
                              })
                              );
                            }

                          });
                        }


                    });

                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<http.Response> getUser() {

    return http.post(AppServer.LOGIN_IP, body: {
      "user_name": accountName,
      "user_password": accountPass
    });
  }

  Future<bool>addStringToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('id', u.u_id);
    prefs.setString('name', u.u_name);
    prefs.setString('pass', u.u_pass);
    prefs.setString('type', u.u_type);
    prefs.setString('photo', u.u_photo);
    return true;
  }
}
