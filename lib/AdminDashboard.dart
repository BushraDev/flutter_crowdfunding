import 'dart:io';
import 'dart:math';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crowdfunding/AppServer.dart';
import 'package:flutter_crowdfunding/Campaign.dart';
import 'package:flutter_crowdfunding/CreateCampaign.dart';
import 'package:flutter_crowdfunding/Details.dart';
import 'package:flutter_crowdfunding/Login.dart';
import 'package:flutter_crowdfunding/ProfilePage.dart';
import 'package:flutter_crowdfunding/SignUp.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert' as dartConverter;

import 'package:shared_preferences/shared_preferences.dart';

import 'CampainsList.dart';

class AdminDashboard extends StatefulWidget {
  final bool user;
  final String type;
  AdminDashboard({Key key, @required this.user, @required this.type}) : super(key:key);
  @override
  _AdminDashboardState createState() => _AdminDashboardState(user,type);
}


class _AdminDashboardState extends State<AdminDashboard> {
  bool user;
  String type;
  _AdminDashboardState(this.user,this.type);
  @override
  String accountName = "Crowdfunding";
  String accountEmail = "";
  int currentPage;
  File pickedimage;
  int c_id;
  var id;
  int difference;
  int position;

  Widget build(BuildContext context)


  {
    print(user);
    print(type);
    print("admin");
    print(AppServer.IP+"get_campaigns.php");
    return Scaffold(
      appBar: AppBar(
        title: Text("Crowdfunding"),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              currentAccountPicture: Image.asset("images/logo.png"),
              accountName: Text(accountName),
              accountEmail: Text(accountEmail),
            ),
            ListTile(
              title: Text("Log out"),
              leading: Icon(Icons.settings_power),
              onTap: ()
              {
                removeValues().then((res)
                {

                    Navigator.pop(context);

                    Navigator.push(context, MaterialPageRoute(builder: (cxt) {
                      return new CampaignsList();
                    }));



                });


              },
            ),

          ],
        ),
      ),
      body: FutureBuilder<http.Response>(
        future: getCampaignsFromApi(),
        builder: (ctx, connection)
        {
          if (connection.connectionState == ConnectionState.done)
          {
            if (connection.hasData)
            {
              String jsonsDataString =connection.data.body;// toString of Response's body is assigned to jsonDataString
              List<dynamic> res = dartConverter.jsonDecode(jsonsDataString); // import 'dart:convert';
              String result = res[0]['result'];
              if(result=="failed")
              {
                return Center(child: Text("There are no requested campaigns"),);
              }
              else
                {

                  List<dynamic> data = dartConverter.jsonDecode(connection.data.body);
                  id=null;
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (ctx, index)
                    {  Campaign campaign=Campaign(
                        data[index]["c_id"],
                        data[index]["u_id"],
                        data[index]["c_cost"],
                        data[index]["approved"],
                        data[index]["state"],
                        data[index]["donors"],
                        data[index]["c_title"],
                        data[index]["c_disc"],
                        data[index]["s_date"],
                        data[index]["e_date"],
                        data[index]["photo"]);
                    DateTime now = DateTime.now();
                    var newDateTimeObj2 = new DateFormat("dd-MM-yyyy").parse(data[index]["e_date"]);
                    difference = newDateTimeObj2.difference(now).inDays;
                    print(difference);
                    int funds=int.parse(data[index]["funds"]);
                    int costs=int.parse(data[index]["c_cost"]);
                    double fund=funds.toDouble();
                    double cost=funds.toDouble();
                    double ratio=((fund*100)/cost).toDouble();
                    return InkWell(
                      onTap: ()
                      {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Details(campaign: campaign,),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child:Card(
                          child: Container(margin: EdgeInsets.all(10),
                            child:Column(
                                children: <Widget>
                                [
                                  Container(margin: EdgeInsets.all(0),
                                      child:Image.network (AppServer.IP+data[index]["photo"])),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(data[index]["c_title"],style: TextStyle(fontStyle: FontStyle.normal,fontSize: 25),),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(data[index]["c_disc"],maxLines: 3,),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      FlatButton(onPressed: ()
                                      {
                                        approveCampaign(campaign);
                                      },
                                        color: Colors.green,
                                        child: Text("Approve"),
                                        textColor: Colors.white,
                                        padding: EdgeInsets.all(20),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      FlatButton(
                                        onPressed: ()
                                        {
                                          showAlertDialog(context,campaign.c_id).then((data)
                                          {
                                            setState(() {

                                            });
                                          });

                                        },
                                        color: Colors.red,
                                        child: Text("Reject"),textColor: Colors.white,
                                        padding: EdgeInsets.all(20),
                                      ),
                                    ],
                                  ),


                                ]

                            ),

                          ),
                        ),

                      ),
                    );
                    },
                  );
                }
            }
            else
              {
                return Center(child: Text("Internet connection failed"),);
              }
          }
          else
            {
              return Center(child: CircularProgressIndicator(),);
            }
        },
      ),
    );
  }

  Future<http.Response> getCampaignsFromApi() async {
    return await http.get(AppServer.IP+"get_requested_campaign.php");
  }

  Future<bool>removeValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("id");
    prefs.remove("name");
    prefs.remove("pass");
    prefs.remove("type");
    prefs.remove("photo");
    return true;

  }

  Future<http.Response>deleteCampaign(String id)
  {
    return http.post(AppServer.IP+"delete.php", body: {
      "cId": id,
    });}

  showAlertDialog(BuildContext context,String id)
  {
    // set up the buttons
    Widget cancelButton = FlatButton
      (
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();

      },
    );
    Widget continueButton = FlatButton
      (
      child: Text("Continue"),
      onPressed: () {
        deleteCampaign(id).then((data) {
          setState(() {
            Navigator.of(context).pop();

          });
        });
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog
      (
      title: Text("Reject Campaign"),
      content: Text(
          "Would you like to continue Rejecting this campaign?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog
      (
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<http.Response>approveCampaign(Campaign campaign)
  {

    return http.post(AppServer.IP+"approve_campaign.php", body: {
      "cId" : campaign.c_id,
      "cApproved": "1",

    });}

}
