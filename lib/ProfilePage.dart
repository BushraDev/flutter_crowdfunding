import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crowdfunding/Home.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  int currentPage;
  String accountName = "Crowdfunding";
  String accountEmail = "";

  Widget build(BuildContext context) {
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
            ),
            Divider(),
            ListTile(
              title: Text("Sign Up"),
              leading: Icon(Icons.person_add),
            ),
            Divider(),
            ListTile(
              title: Text("Log out"),
              leading: Icon(Icons.settings_power),
            ),
          ],
        ),
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
    );
  }
}
