

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyagro/Farmer/farmerlogin.dart';
import 'package:easyagro/splash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Database/database.dart';
import '../sharedpref_validations.dart';

class farmerhome extends StatefulWidget{
  @override
  State<farmerhome> createState() => _farmerhomeState();
}

class _farmerhomeState extends State<farmerhome> {

  var user_data=[];

  @override
  void initState() {
    super.initState();
    Get_current_farmer_details();

  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text('Farmer Home'),backgroundColor: Colors.green.shade900,centerTitle: true,actions: [
        IconButton(onPressed:(){
          Clear_Preferences();
          EasyLoading.showSuccess('Logout');
          Navigator.pushReplacement(context, Myroute(farmerlogin()));
        }, icon: Icon(Icons.logout,color: Colors.white,))
      ],),
      drawer: Drawer(
        backgroundColor: Colors.transparent,
        child: Container(
      clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.only(topRight: Radius.elliptical(120, 800),bottomRight:Radius.elliptical(120, 800), ),
        ),
          child: ListView(
            children: [
              UserAccountsDrawerHeader(decoration: BoxDecoration(
                color: Colors.green.shade900
              ),accountName: user_data.isEmpty ?Text('') :Text('${user_data[0]}'), accountEmail:user_data.isEmpty ?Text(''): Text('${user_data[1]}'),
              currentAccountPicture: Icon(Icons.face,color: Colors.white,size: 65,),
              ),

             Row(children: [
               TextButton.icon(style: ButtonStyle(
                 overlayColor: MaterialStateProperty.resolveWith((states) => Colors.transparent)
               ),onPressed: (){
                 Clear_Preferences();
                 EasyLoading.showSuccess('Logout');
                 Navigator.pushReplacement(context, Myroute(farmerlogin()));
               },icon: Icon(Icons.logout,color: Colors.green.shade900,),label: Text('Logout',style: TextStyle(color: Colors.black,fontSize: 17),),),

             ],)

            ],
          ),
      ),

      )
    );
  }
  Get_current_farmer_details() async {
    var email;
    SharedPreferences pref =await SharedPreferences.getInstance();
    email=await pref.getString("email");

    await FirebaseFirestore.instance.collection("farmers").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        if(result.data()['email']==email){
          setState(() {
            user_data.add(result.data()['name']);
            user_data.add(result.data()['email']);
            user_data.add(result.data()['password']);
          });
        }

      });
    });

  }
}
