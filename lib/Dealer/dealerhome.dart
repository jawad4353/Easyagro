

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyagro/Dealer/dealerlogin.dart';
import 'package:easyagro/Dealer/update_dealer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Company/companylogin.dart';
import '../Company/live_chat.dart';
import '../Database/database.dart';
import '../sharedpref_validations.dart';
import '../splash.dart';

class dealerhome extends StatefulWidget{
  @override
  State<dealerhome> createState() => _dealerhomeState();
}

class _dealerhomeState extends State<dealerhome> {
  var user_data=[], index_current=0;


  @override
  void initState() {

    super.initState();
    Get_current_dealer_details();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dealer Home'),backgroundColor: Colors.green.shade700,actions: [
        IconButton(onPressed:(){
          Clear_Preferences();
          EasyLoading.showSuccess('Logout');
          Navigator.pushReplacement(context, Myroute(dealerlogin()));
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
                  color: Colors.green.shade700
              ),accountName: user_data.isEmpty ?Text(''):Text('${user_data[0]}'), accountEmail: user_data.isEmpty ?Text(''):Text('${user_data[1]}'),
                currentAccountPicture: Icon(Icons.face,color: Colors.white,size: 65,),
              ),


              Row(children: [
                TextButton.icon(style: ButtonStyle(
                    overlayColor: MaterialStateProperty.resolveWith((states) => Colors.transparent)
                ),onPressed: (){

                },icon: Icon(Icons.supervised_user_circle,color: Colors.green.shade700,),label: Text('About Us',style: TextStyle(color: Colors.black,fontSize: 16),),),

              ],),

              Row(children: [
                TextButton.icon(style: ButtonStyle(
                    overlayColor: MaterialStateProperty.resolveWith((states) => Colors.transparent)
                ),onPressed: (){

                },icon: Icon(Icons.contact_page,color: Colors.green.shade700,),label: Text('Contact Us',style: TextStyle(color: Colors.black,fontSize: 16),),),

              ],),


              Row(children: [
                TextButton.icon(style: ButtonStyle(
                    overlayColor: MaterialStateProperty.resolveWith((states) => Colors.transparent)
                ),onPressed: (){
                  Clear_Preferences();
                  EasyLoading.showSuccess('Logout');
                  Navigator.pushReplacement(context, Myroute(dealerlogin()));
                },icon: Icon(Icons.logout,color: Colors.green.shade900,),label: Text('Logout',style: TextStyle(color: Colors.black,fontSize: 17),),),

              ],)

            ],
          ),
        ),

      ),



      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: index_current,
        onTap: (a){
          setState(() {
            index_current=a;
          });
          if(a==1){
            Navigator.push(context, Myroute(update_dealer_account(user_data: user_data,)));
          }
          if(a==2){
            Navigator.push(context, Myroute(LiveChatPage()));
          }

        },
        selectedItemColor: Colors.green.shade700,
        items: [
          BottomNavigationBarItem(icon:Icon(Icons.home) ,label: 'Home'),
          BottomNavigationBarItem(icon:Icon(Icons.supervised_user_circle),label: 'Account' ),
          BottomNavigationBarItem(icon:Icon(Icons.sms),label: 'Chat' ),
        ],
      ),
    );
  }

  Get_current_dealer_details() async {
    var license,a;
    SharedPreferences pref =await SharedPreferences.getInstance();
    license=await pref.getString("email");

    await FirebaseFirestore.instance.collection("dealer").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        if(result.data()['license']==license){
          setState(() {
            user_data.add(result.data()['name']);
            user_data.add(result.data()['email']);
            user_data.add(result.data()['password']);
            user_data.add(result.data()['phone']);
            user_data.add(result.data()['license']);
            user_data.add(result.data()['address']);
          });
        }

      });
    });
    a=await new database().GetImage_Firebase('dealer_licenses',user_data[1]);
    user_data.add(a);

  }
}