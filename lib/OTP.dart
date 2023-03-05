
import 'dart:async';

import 'package:easyagro/Company/companyhome.dart';
import 'package:easyagro/Dealer/dealerhome.dart';
import 'package:easyagro/Farmer/farmerhome.dart';
import 'package:easyagro/selection.dart';
import 'package:easyagro/sharedpref_validations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:proste_bezier_curve/proste_bezier_curve.dart';
import 'Database/database.dart';
import 'splash.dart';

class OTP_screen extends StatefulWidget{

  var Data=[],type,OTP;
  OTP_screen({required this.Data,required this.type,required this.OTP});
  @override
  State<OTP_screen> createState() => _OTP_screenState();
}

class _OTP_screenState extends State<OTP_screen> {
  var OTP_button_disabled=true;
  TextEditingController otp_controller=new TextEditingController();
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 30),(){
      setState(() {
        OTP_button_disabled=true;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Stack(
            children: [

              ClipPath(
                clipper: ProsteBezierCurve(
                  position: ClipPosition.bottom,
                  list: [
                    BezierCurveSection(
                      start: Offset(0, 166),
                      top: Offset(size.width / 4, 190),
                      end: Offset(size.width / 2, 155),
                    ),
                    BezierCurveSection(
                      start: Offset(size.width / 2, 25),
                      top: Offset(size.width / 4 * 3, 100),
                      end: Offset(size.width, 150),
                    ),
                  ],
                ),
                child: Container(
                  height: size.height*0.72,
                  width: size.width,
                  color: Colors.green.shade900,
                  child: Opacity(opacity: 0.4,child: Image.asset('images/back.jpg',fit: BoxFit.cover,),),
                ),
              ),


              Positioned(
                top: size.height*0.05,
                left: size.width*0.04,
                child: Container(
                    height: 48,
                    width: 40,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle
                    ),child:  IconButton(onPressed: (){
                  Navigator.pushReplacement(context, Myroute(Selection()));
                },icon: Icon(Icons.arrow_back_ios,color: Colors.green,size: 30,),)),
              ),

              Positioned(
                top: size.height*0.07,
                left: size.width*0.1,
                right:size.width*0.1 ,
                child: Container(
                  width: size.width*0.8,
                  child: Column(
                    children: [
                      Text('Verify',style: TextStyle(fontSize: 34,fontWeight: FontWeight.bold,color: Colors.white),)
                      ,
                      Text('Verify OTP\n',style: TextStyle(fontSize: 17,color: Colors.white),)
                      ,
                      Text('\n \n \n'),
                      TextField(
                        cursorColor: Colors.green.shade700,
                        keyboardType: TextInputType.visiblePassword,
                        controller: otp_controller,
                        decoration: InputDecoration(
                            hintText: 'Enter OTP',
                            focusedErrorBorder:UnderlineInputBorder(borderSide: BorderSide(color: Colors.green))  ,
                            focusedBorder:UnderlineInputBorder(borderSide: BorderSide(color: Colors.green)) ,
                            prefixIcon: Icon(Icons.sms,color: Colors.green,size: 28,),
                            // suffix: ElevatedButton(onPressed:(){
                            //   // OTP_button_disabled ? null:GenerateOTP_again();
                            // } ,child: Text('Get OTP'),   style:ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.green.shade700),
                            // ))
                        ),
                      ),
                      Text(''),
                      Container(
                        width: size.width*0.7,
                        child: ElevatedButton(onPressed: () async {




                          if(widget.type=='farmer'){
                            if(otp_controller.text.isEmpty){
                              EasyLoading.showInfo('Enter OTP send to ${widget.Data[1]}');
                              return;
                            }
                            if(widget.OTP==otp_controller.text){
                            bool isregistered= await new database().Register_Farmer(widget.Data[1],widget.Data[2] , widget.Data[0]);
                            if(isregistered){
                              Set_Shared_Preference('farmer',widget.Data[1],widget.Data[2]);
                              Navigator.pushReplacement(context, Myroute(farmerhome()));
                            }
                            return;
                            }
                            else{
                              EasyLoading.showInfo('Incorrect OTP !');
                              return;
                            }
                          }





                          if(widget.type=='company'){
                            if(otp_controller.text.isEmpty){
                              EasyLoading.showInfo('Enter OTP send to ${widget.Data[3]}');
                              return;
                            }
                            if(widget.OTP==otp_controller.text){
                              bool isregistered= await new database().Register_company(widget.Data[0],widget.Data[1],widget.Data[2], widget.Data[3], widget.Data[4], widget.Data[5]);
                              if(isregistered){
                                Set_Shared_Preference('company',widget.Data[3],widget.Data[5]);
                                Navigator.pushReplacement(context, Myroute(companyhome()));
                              }
                              return;
                            }
                            else{
                              EasyLoading.showInfo('Incorrect OTP !');
                              return;
                            }
                          }



                          if(widget.type=='dealer'){
                            if(otp_controller.text.isEmpty){
                              EasyLoading.showInfo('Enter OTP send to ${widget.Data[3]}');
                              return;
                            }
                            if(widget.OTP==otp_controller.text){
                              bool isregistered= await new database().Register_dealer(widget.Data[0],widget.Data[1],widget.Data[2], widget.Data[3], widget.Data[4], widget.Data[5]);
                              if(isregistered){
                                Set_Shared_Preference('dealer',widget.Data[3],widget.Data[5]);
                                Navigator.pushReplacement(context, Myroute(dealerhome()));
                              }
                              return;
                            }
                            else{
                              EasyLoading.showInfo('Incorrect OTP !');
                              return;
                            }
                          }




                        }, child: Text('Verify')   ,style:ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.green.shade700),
                        )),
                      )
                    ],
                  ),
                ),
              ),

            ],)
        ],
      ),
    );
  }

  // GenerateOTP_again(){
  //   widget.OTP=Generate_OTP();
  //   if(widget.type=='farmer'){
  //     Send_mail(widget.Data[0], widget.OTP, widget.Data[1]);
  //     return;
  //   }
  //   if(widget.type=='company' || widget.type=='dealer' ){
  //     Send_mail(widget.Data[0], widget.OTP, widget.Data[3]);
  //     return;
  //   }
  //
  // }

}