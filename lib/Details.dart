import 'package:flutter/material.dart';
import 'package:flutter_crowdfunding/AppServer.dart';

import 'Campaign.dart';

class Details extends StatefulWidget
{
  final Campaign campaign;
  Details({Key key, @required this.campaign}) : super(key:key);
  @override
  _DetailsState createState() => _DetailsState(campaign);

}

class _DetailsState extends State<Details>
{
   Campaign campaign;
   _DetailsState(this. campaign);
   @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        title: Text("Crowdfunding"),
      ),
      body:  Container(
        margin: EdgeInsets.all(10),
        child:Card(
          child: Container(margin: EdgeInsets.all(10),
            child:ListView(
                children: <Widget>
                [
                  Text(campaign.c_title,style: TextStyle(color: Colors.purple,fontStyle: FontStyle.normal,fontSize: 25),),
                  SizedBox(
                    height: 20,
                  ),
                  Container(margin: EdgeInsets.all(0),
                      child:Image.network (AppServer.IP+campaign.photo)),
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
                            Text(campaign.donors)
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
                            Text("Start Date",style: TextStyle(color: Colors.purple,fontStyle: FontStyle.italic),),
                            Text(campaign.s_date)
                          ],
                          ),
                        ],
                      ),

                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[

                      Row(
                        children: <Widget>[

                          Icon(Icons.monetization_on,color: Colors.purple,),
                          SizedBox(
                            width: 10,
                          ),

                          Column(children: <Widget>[
                            Text("Cost",style: TextStyle(color: Colors.purple,fontStyle: FontStyle.italic),),
                            Text(campaign.c_cost)
                          ],
                          ),
                        ],
                      ),


                      Row(
                        children: <Widget>[
                          Icon(Icons.timer_off,color: Colors.purple,),
                          SizedBox(
                            width: 10,
                          ),

                          Column(children: <Widget>[
                            Text("End Date",style: TextStyle(color: Colors.purple,fontStyle: FontStyle.italic),),
                            Text(campaign.e_date)
                          ],
                          ),
                        ],
                      ),

                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text("Description",style: TextStyle(color: Colors.purple,fontStyle: FontStyle.normal,fontSize: 25),),
                  SizedBox(
                    height: 15,
                  ),
                  Text(campaign.c_disc),
                  SizedBox(
                    height: 15,
                  ),


                ]

            ),

          ),
        ),

      ),
    );
  }
}
