import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crowdfunding/Home.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as dartConverter;

import 'Campaign.dart';
import 'CreateCampaign.dart';
import 'Details.dart';
import 'SignUp.dart';

class CustomPopupMenu {
  CustomPopupMenu({this.title});

  String title;
}

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

List<CustomPopupMenu> choices = <CustomPopupMenu>
[
  CustomPopupMenu(title: 'Delete'),
  CustomPopupMenu(title: 'Edite'),
];

class _ProfileState extends State<Profile> {
  @override
  int currentPage;
  String accountName = "Crowdfunding";
  String accountEmail = "";
  String ip="http://192.168.137.1/crowdfunding/";
  var id;

  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child:Scaffold(
        appBar: AppBar(
          title: Text("Crowdfunding"),
          bottom: TabBar(
            tabs: [
              Tab(text: "My Campaigns",),
              Tab(text: "My Donations",),
            ],
          ),
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
              Divider(),
              ListTile(
                title: Text("Create Campaign"),
                leading: Icon(Icons.create),
                onTap: ()
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateCampaign(),
                    ),
                  );
                },
              ),
              Divider(),
              ListTile(
                title: Text("Log out"),
                leading: Icon(Icons.settings_power),
              ),

            ],
          ),
        ),
        body: TabBarView(
          children: [
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
                                    Row(children: <Widget>[                                    PopupMenuButton<CustomPopupMenu>(
                                      elevation: 3.2,
                                      initialValue: choices[0],
                                      onCanceled: () {
                                        print('You have not chossed anything');
                                      },
                                      tooltip: 'This is tooltip',
                                      //onSelected: _select,
                                      itemBuilder: (BuildContext context) {
                                        return choices.map((CustomPopupMenu choice) {
                                          return PopupMenuItem<CustomPopupMenu>(
                                            value: choice,
                                            child: Text(choice.title),
                                          );
                                        }).toList();
                                      },
                                    ),
                                    ],mainAxisAlignment: MainAxisAlignment.end,),

                                    Container(
                                        margin: EdgeInsets.all(0),
                                        child:Image.network (ip+data[index]["photo"])),
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
                                            Column(children: <Widget>[
                                              Text("Days To Go",style: TextStyle(color: Colors.purple,fontStyle: FontStyle.italic),),
                                              Text(data[index]["e_date"])
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
                                        child:Image.network (ip+data[index]["photo"])),
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
                                            Column(children: <Widget>[
                                              Text("Days To Go",style: TextStyle(color: Colors.purple,fontStyle: FontStyle.italic),),
                                              Text(data[index]["e_date"])
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
          ],
        ),
        bottomNavigationBar: FancyBottomNavigation(
          tabs: [
            TabData(iconData: Icons.home, title: "Home"),
            TabData(iconData: Icons.person, title: "Profile"),
          ],
          onTabChangedListener: (position) {
            setState(() {
              currentPage = position;

              if (position == 0) {
                Navigator.push(context, MaterialPageRoute(builder: (cxt) {
                  return new Home();
                }));
              }
            });
          },
        ),
      ),
    );
  }

  Future<http.Response> getCampaignsFromApi() async {
    return await http.get(ip+"get_campaigns.php");
  }
}
