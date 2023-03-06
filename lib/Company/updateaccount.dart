

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:proste_bezier_curve/proste_bezier_curve.dart';

import '../sharedpref_validations.dart';

class update_company_account extends StatefulWidget{
  @override
  State<update_company_account> createState() => _update_company_accountState();
}

class _update_company_accountState extends State<update_company_account> {
  var hidepassword=true,Address_error,phone_error,phone_error_color=Colors.grey,Address_error_color=Colors.grey,Name_Error,Name_error_color=Colors.grey,Email_Error,Email_Error_color=Colors.grey,Password_Error,Password_Error_color=Colors.grey,Liscense_error,Liscence_Error_color=Colors.grey;
  var countrycode='+92';
  TextEditingController company_controller=new TextEditingController();
  TextEditingController license_controller=new TextEditingController();
  TextEditingController address_controller=new TextEditingController();
  TextEditingController email_controller=new TextEditingController();
  TextEditingController phone_controller=new TextEditingController();
  TextEditingController password_controller=new TextEditingController();
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
   return WillPopScope(
     onWillPop: ()=>onClick(context),
     child: Scaffold(
       body: ListView(children: [
        Stack(
        children: [  ClipPath(
          clipper: ProsteBezierCurve(
            position: ClipPosition.bottom,
            list: [
              BezierCurveSection(
                start: Offset(0, 166),
                top: Offset(size.width / 4, 170),
                end: Offset(size.width / 2, 125),
              ),
              BezierCurveSection(
                start: Offset(size.width / 2, 25),
                top: Offset(size.width / 4 * 3, 80),
                end: Offset(size.width, 150),
              ),
            ],
          ),child: Container(color: Colors.green.shade700,height: 220,),
          // child: Container(
          //   height: size.height*0.72,
          //   width: size.width,
          //   color: Colors.green.shade900,
          //   child: Opacity(opacity: 0.3,child: Image.asset('images/back.jpg',fit: BoxFit.cover,),),
          // ),
        ),
          Text('Update',style: TextStyle(fontSize: 22,color: Colors.white,fontWeight: FontWeight.bold),)
        ],

        )
       ],),
     ),
   );
  }
}