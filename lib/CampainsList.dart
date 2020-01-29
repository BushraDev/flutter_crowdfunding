import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_crowdfunding/AppServer.dart';
import 'package:flutter_crowdfunding/Campaign.dart';
import 'package:flutter_crowdfunding/Details.dart';
import 'package:flutter_crowdfunding/Login.dart';
import 'package:flutter_crowdfunding/SignUp.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as dartConverter;

import 'package:intl/intl.dart';

class CampaignsList extends StatefulWidget
{
  @override
  _CampaignsListState createState() => _CampaignsListState();
}


class _CampaignsListState extends State<CampaignsList>
{

  _CampaignsListState();
  @override
  String accountName = "Crowdfunding";
  String accountEmail = "";
  int difference;
  var id;
  Widget build(BuildContext context)

  {
    print("non user");
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
    title: Text("Log in"),
    leading: Icon(Icons.person),
    onTap: ()
    {
    Navigator.push(context, MaterialPageRoute(
    builder: (context) => Login()
    ));
    },
    ),
    Divider(),
    ListTile(
    title: Text("Sign Up"),
    leading: Icon(Icons.person_add),
    onTap: ()
    {
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) => SignUp(),
    ),
    );
    },
  ),

  ],
  ),
  ),

  body:
  FutureBuilder<http.Response>(
        future: getCampaignsFromApi(),
        builder: (ctx, connection)
        {
          if (connection.connectionState == ConnectionState.done) {
            if (connection.hasData) {
              List<dynamic> data = dartConverter.jsonDecode(connection.data.body);
              id=null;
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (ctx, index)
                {

                  Campaign campaign=Campaign(
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Details(campaign: campaign,),
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
                                height: 30,
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[

                                  Row(
                                    children: <Widget>[

                                      Icon(Icons.favorite,color: Colors.purple,),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Column(children: <Widget>[
                                        Text("Donors",style: TextStyle(color: Colors.purple,fontStyle: FontStyle.italic),),
                                        Text(data[index]["donors"])
                                      ],
                                      ),
                                    ],
                                  ),


                                  Row(
                                    children: <Widget>[
                                      Icon(Icons.access_time,color: Colors.purple,),
                                      SizedBox(
                                        width: 10,
                                      ),

                                      Column(children: <Widget>[
                                        Text("Days To Go",style: TextStyle(color: Colors.purple,fontStyle: FontStyle.italic),),
                                        Text(difference.toString())
                                      ],
                                      ),
                                    ],
                                  ),

                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),


                            ]

                        ),

                      ),
                    ),

                  ),
                );
                },
              );
            } else {
              return Center(
                child: Text("Internet connection failed"),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Future<http.Response> getCampaignsFromApi() async {
    return await http.get(AppServer.IP+"get_campaigns.php");
  }



}
