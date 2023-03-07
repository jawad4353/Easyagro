

import 'dart:async';
import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easyagro/Company/companyhome.dart';
import 'package:easyagro/Dealer/dealerhome.dart';
import 'package:easyagro/Farmer/farmerhome.dart';
import 'package:easyagro/sharedpref_validations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'selection.dart';



class Splashscreen extends StatefulWidget{
  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  var internet=false, usertype;


  Check_person() async {
    SharedPreferences pref =await SharedPreferences.getInstance();
    usertype=await pref.getString('usertype');
    print(usertype);
    if(usertype=='farmer'){
      Timer(Duration(seconds: 1),()=>Navigator.pushReplacement(context, Myroute(farmerhome())));
      return;
    }
    if(usertype=='company'){
      Timer(Duration(seconds: 1),()=>Navigator.pushReplacement(context, Myroute(companyhome())));
      return;
    }
    if(usertype=='dealer'){
      Timer(Duration(seconds: 1),()=>Navigator.pushReplacement(context, Myroute(dealerhome())));
      return;
    }
    if(usertype==null){
      Timer(Duration(seconds: 2),()=>Navigator.pushReplacement(context,Myroute(Selection())));
    }
  }

  @override
  void initState() {
    Customize_Easyloading();
    var subscription = Connectivity().onConnectivityChanged.listen(( my_result) {
      if (my_result == ConnectivityResult.none){
          setState(() {
            ScaffoldMessenger.of(context).showSnackBar(Internetsnackbar(context, '! No Internet '));
            Set_Mode_Sharedpref('offline');
          });
      }
      else if(my_result==ConnectivityResult.mobile || my_result==ConnectivityResult.wifi || my_result==ConnectivityResult.ethernet ){
            // ScaffoldMessenger.of(context).showSnackBar(Internetsnackbar(context, 'Connected to Internet '));
         setState(() {
           Set_Mode_Sharedpref('online');
         });
      }
    });
    Check_person();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body:Center(child: Container(height: size.height*0.24,child: Image.asset('images/icon.png',),),)
    );
  }

  Internetsnackbar(context,message){
    var my= SnackBar(
      backgroundColor:  Colors.green.shade700,
      content:Text('${message}',style: TextStyle(color: Colors.white),),
      duration: Duration(seconds: 3),
      dismissDirection: DismissDirection.down,
      margin:EdgeInsets.only(left:5,right: 5) ,
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(label: 'Quit',textColor: Colors.white,onPressed: (){
        ScaffoldMessenger.of(context).clearSnackBars();
      },),
    );
    return my;
  }
  Set_Mode_Sharedpref(mode) async {
    SharedPreferences pref =await SharedPreferences.getInstance();
    pref.setString("mode", "${mode}");
  }
}




class Myroute extends PageRouteBuilder{
  final Widget child;
  Random ob=new Random();
  var o,Random_element ,
      Directions=[AxisDirection.up,AxisDirection.down,AxisDirection.left,AxisDirection.right];

  Myroute(this.child):super(pageBuilder:(BuildContext, Animation , Animatio )=>child ){
    Random_element=ob.nextInt(4);
  }

  Duration get transitionDuration => Duration(milliseconds: 400);

  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    var T=Tween<Offset>(begin: Getoffset(Random_element),end: Offset.zero);
    var T1=Tween<double>(begin: 3.0,end: 1.0);
    return SlideTransition(
        child: child,
        position: animation.drive(T.chain(CurveTween(curve: Curves.bounceInOut))));
  }

  Offset Getoffset(Random_element){
    switch(Random_element) {
      case 0:
        o = Offset(0, -1);
        break;
      case 1:
        o = Offset(0, 1);
        break;
      case 2 :
        o = Offset(1, 0);
        break;
      case 3:
        o = Offset(-1, 0);
        break;
    }
    return o;
  }
}



