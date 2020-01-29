import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crowdfunding/AppServer.dart';
import 'package:flutter_crowdfunding/Home.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as dartConverter;
import 'Campaign.dart';
import 'CampainsList.dart';
import 'CreateCampaign.dart';
import 'Details.dart';
import 'EditeCampaign.dart';
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
  CustomPopupMenu(title: 'Edite'),
  CustomPopupMenu(title: 'Delete'),
];

class _ProfileState extends State<Profile>
{
  @override
  String accountName = "Crowdfunding";
  String accountEmail = "";
  String uId;
  CustomPopupMenu _selectedChoices = choices[0];
  int difference;
  Campaign campaign;
  void _select(CustomPopupMenu choice)
  {
      _selectedChoices = choice;
      if(_selectedChoices.title == "Edite")
        {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditeCampaign(campaign: campaign),
            ),
          );
        }
      else if(_selectedChoices.title == "Delete")
        {
          showAlertDialog(context);
        }

  }

  Widget build(BuildContext context) {
    getStringValuesSF().then((res){
      uId=res;
    });
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
                onTap: ()
                {
                  removeValues().then((res)
                  {

                    Navigator.pop(context);
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
        body: TabBarView(
          children: [
            FutureBuilder<http.Response>(
              future: getCampaignsFromApi(),
              builder: (ctx, connection)
              {
                print(uId);
                if (connection.connectionState == ConnectionState.done) {
                  if (connection.hasData) {
                    List<dynamic> data = dartConverter.jsonDecode(connection.data.body);
                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (ctx, index)
                      {
                        campaign=null;
                         campaign=Campaign(
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
                                    Row(children: <Widget>[
                                      PopupMenuButton<CustomPopupMenu>(
                                      elevation: 3.2,
                                      initialValue: choices[0],
                                      onCanceled: () {
                                        print('You have not chossed anything');
                                      },
                                      tooltip: 'This is tooltip',
                                      onSelected: _select,
                                      itemBuilder: (BuildContext context)
                                      {
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
            FutureBuilder<http.Response>(
              future: getCampaignsFromApi(),
              builder: (ctx, connection)
              {
                if (connection.connectionState == ConnectionState.done) {
                  if (connection.hasData) {
                    List<dynamic> data = dartConverter.jsonDecode(connection.data.body);
                    print(connection.data.body);
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
          ],
        ),
        bottomNavigationBar: FancyBottomNavigation(
          tabs: [
            TabData(iconData: Icons.home, title: "Home"),
            TabData(iconData: Icons.person, title: "Profile"),
          ],
          onTabChangedListener: (position)
          {
            setState(() {

              if (position == 0) {
                Navigator.push(context, MaterialPageRoute(builder: (cxt) {
                  return new Home(user: true,type:"0");
                }));
              }
            });
          },
        ),
      ),
    );
  }

  Future<http.Response> getCampaignsFromApi() async
  {
    return await http.post(AppServer.IP+"get_campaigns.php", body: {
          "cId": uId,
        });
  }

  Future<http.Response>deleteCampaign()
  {
    return http.post(AppServer.IP+"delete.php", body: {
      "cId": campaign.c_id,
    });
  }


  showAlertDialog(BuildContext context)
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
        deleteCampaign().then((data) {
          setState(() {

          });
          print(data.body);

        });
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog
      (
      title: Text("Delete Campaign"),
      content: Text(
          "Would you like to continue deleting this campaign?"),
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

  Future<bool>removeValues() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("id");
    prefs.remove("name");
    prefs.remove("pass");
    prefs.remove("type");
    prefs.remove("photo");
    return true;

  }

  Future <String> getStringValuesSF() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String id = prefs.getString('id');
    return id;
  }
}


