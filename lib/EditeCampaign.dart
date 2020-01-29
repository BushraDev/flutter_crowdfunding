import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_crowdfunding/AppServer.dart';
import 'package:flutter_crowdfunding/ProfilePage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'Campaign.dart';
import 'Details.dart';

class EditeCampaign extends StatefulWidget {

  final Campaign campaign;
  EditeCampaign({Key key, @required this.campaign}) : super(key:key);

  @override
  _EditeCampaignState createState() => _EditeCampaignState(campaign);
}

class _EditeCampaignState extends State<EditeCampaign> {

  Campaign campaign;
  TextEditingController titleController=TextEditingController();
  TextEditingController costController=TextEditingController();
  TextEditingController discController=TextEditingController();
  _EditeCampaignState(this. campaign);


  GlobalKey<FormState> editeCampaign = new GlobalKey();
  File pickedimage;
  String cTitle,cCost,cDisc;
  DateTime startDate=new DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titleController.text=campaign.c_title;
    costController.text=campaign.c_cost;
    discController.text=campaign.c_disc;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Crowdfunding"),
      ),
      body: Container(
        margin: EdgeInsets.all(30),
        child: Form(
          key: editeCampaign,
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: titleController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Title",
                  hintText: "Enter Project Title",
                  icon: Icon(Icons.title),
                ),
                validator: (title) => title.isEmpty ? "Title is Required" : null,
                onSaved: (title) => cTitle = title,
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: costController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Cost",
                  hintText: "Enter Project Cost",
                  icon: Icon(Icons.monetization_on),
                ),
                validator: (cost) =>
                cost.isEmpty ? "Cost is Required" : null,
                onSaved: (cost) => cCost = cost,
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: discController,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  labelText: "Discription",
                  hintText: "Enter Project Description",
                  icon: Icon(Icons.text_fields),
                ),
                validator: (disc) =>
                disc.isEmpty ? "Description is Required" : null,
                onSaved: (disc) => cDisc = disc,
              ),
              SizedBox(
                height: 30,
              ),
              FlatButton(
                child: Text("Done"),
                color: Colors.purple,
                padding: EdgeInsets.all(20),
                textColor: Colors.white,
                onPressed: ()
                {
                  if (editeCampaign.currentState.validate() )
                  {
                    editeCampaign.currentState.save();
                    editeCurrentCampaign().then((data) {
                      print(data.body);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Profile(),
                        ),
                      );
                    });

                  }
                  else if(pickedimage==null)
                  {
                    Fluttertoast.showToast(
                        msg: "Please pick Project photo",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIos: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<http.Response>editeCurrentCampaign()
  {
    return http.post(AppServer.IP+"update_campaign.php", body:
    {
      "cId" : campaign.c_id,
      "cTitle": cTitle,
      "cCost": cCost,
      "cDisc": cDisc,
    });}

}
