import 'package:flutter/material.dart';
import 'package:flutter_crowdfunding/AdminDashboard.dart';
import 'package:flutter_crowdfunding/CampainsList.dart';
import 'package:flutter_crowdfunding/Home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash>
{

  bool user=false;
  String type=null;

  @override
  void initState()
  {

    // TODO: implement initState
    super.initState();
    chekUser().then((res)
    {
      user=res;
      print(user);

      if(user)
        {
          getStringValuesSF().then((res)
          {
            type=res;
            print(type);
          });
        }
    });


  }

  @override
  Widget build(BuildContext context)
  {
    return new SplashScreen
      (
      seconds: 5,
      navigateAfterSeconds: AfterSplash(),
      title: new Text('Welcome In Crowdfunding',
        style: new TextStyle(
          color: Colors.purple,
            fontStyle: FontStyle.italic,
            fontSize: 20.0
        ),
      ),
      image: new Image.asset('images/logo.png'),
      backgroundColor: Colors.white,
      styleTextUnderTheLoader: new TextStyle(),
      photoSize: 60.0,
      onClick: ()=>print("Flutter Egypt"),
      loaderColor: Colors.purple,
    );
  }

   Future<bool> chekUser()async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool CheckName = prefs.containsKey('name');

    return CheckName ;

  }

  Future<String> getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String type = prefs.getString('type');
    return type;
  }


  dynamic AfterSplash()
  {
    if(user==true && type=="0")
    return new Home(user: user,type: type);
    else if(user==false && type==null)
        return new CampaignsList();
    else if(user==true && type=="1")
      return new AdminDashboard(user: user,type: type);
  }

}
