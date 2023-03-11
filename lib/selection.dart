
import 'dart:math';
import 'package:easyagro/splash.dart';
import 'package:easyagro/sharedpref_validations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Company/companylogin.dart';
import 'Dealer/dealerlogin.dart';
import 'Farmer/farmerlogin.dart';



class Selection  extends StatefulWidget {
  @override
  State<Selection> createState() => _SelectionState();
}

class _SelectionState extends State<Selection> {
  TextEditingController liscense_no=new TextEditingController();
  TextEditingController password=new TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.green.shade900,
         body:ListView(
           children: [
             Stack(children: [
               Opacity(
                 opacity: 0.5,
                 child: Container(
                   height:size.height,
                   width: size.width,
                   decoration: const BoxDecoration(
                     image: DecorationImage(
                         image: AssetImage("images/back.jpg"),
                         fit: BoxFit.cover),
                   ),

                 ),
               )
               ,
               Positioned(
                   top: size.height*0.12,
                   left: size.width*0.03,
                   child: Text('The best \n place to\n trade ',style: TextStyle(fontSize: 47,color: Colors.white,fontWeight: FontWeight.bold,fontFamily: 'jd1'),))

            ,
               Positioned(
                 top: size.height*0.52,
                 left: size.width*0.08,
                 right:size.width*0.08 ,
                 child:   Container(
                   height: 44,
                   child: ElevatedButton(style: ButtonStyle(
                       backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.green.shade900)
                   ),onPressed: ()  {

                     Navigator.pushReplacement(context, Myroute(farmerlogin()));
                   },child: Text('Continue as Farmer',style: TextStyle(fontSize: 21,color: Colors.white,fontWeight: FontWeight.bold,fontFamily: 'jd1')),),
                 ),

                 ),


               Positioned(
                 top: size.height*0.58,
                 left: size.width*0.1,
                 right:size.width*0.1,
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                      OutlinedButton(style: ButtonStyle(
                        side: MaterialStateProperty.resolveWith((states) => BorderSide(color: Colors.white)),
                        overlayColor: MaterialStateProperty.resolveWith((states) => Colors.grey),
                           backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.white)
                       ),onPressed: () {


                        Navigator.pushReplacement(context,  Myroute(companylogin()));

                        },child: Text('Company',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'jd1',fontSize: 17,color: Colors.green.shade900)),),

                      Text(' or ',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 17,fontFamily: 'jd1'),),

                      OutlinedButton(style: ButtonStyle(
                          overlayColor: MaterialStateProperty.resolveWith((states) => Colors.grey),
                          side: MaterialStateProperty.resolveWith((states) => BorderSide(color: Colors.transparent)),
                           backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.white)
                       ),onPressed: ()  {

                       Navigator.pushReplacement(context, Myroute(dealerlogin()));
                      },child: Text('  Dealer  ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: Colors.green.shade900,fontFamily: 'jd1')),),

                   ],
                 ),
               )

              ],) ,

             ],

         ) ,
      ),
    );
  }
}

