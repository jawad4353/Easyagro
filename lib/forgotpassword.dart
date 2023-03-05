
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyagro/Company/companylogin.dart';
import 'package:easyagro/Dealer/dealerlogin.dart';
import 'package:easyagro/Farmer/farmerlogin.dart';
import 'package:easyagro/selection.dart';
import 'package:easyagro/sharedpref_validations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:proste_bezier_curve/proste_bezier_curve.dart';

import 'Database/database.dart';
import 'splash.dart';

class forgotpassword extends StatefulWidget{
  var collection_name;
  forgotpassword({required this.collection_name});
  @override
  State<forgotpassword> createState() => _forgotpasswordState();
}

class _forgotpasswordState extends State<forgotpassword> {

  TextEditingController email_controller=new TextEditingController();
  TextEditingController password_controller=new TextEditingController();
  TextEditingController otp_controller=new TextEditingController();
  var Email_Error,Password_Error,hidepassword=true,Password_Error_color=Colors.grey,
      Email_Error_color=Colors.grey,OTP,email_exist,s,OTP_sent=false,saved_email;

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
                  Back_navigation();

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
                      Text('Forgot',style: TextStyle(fontSize: 34,fontWeight: FontWeight.bold,color: Colors.white),)
                      ,
                      Text('Create new password\n',style: TextStyle(fontSize: 17,color: Colors.white),)
                      ,
                      Text('\n \n \n'),
                      if(!OTP_sent)
                      TextField(
                        cursorColor: Colors.green.shade700,

                        inputFormatters: [  FilteringTextInputFormatter.allow(RegExp(r'[0-9a-zA-Z.-.@-@_-_]')),],
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (a){
                          setState(() {
                            var s= Email_Validation(a);
                            Email_Error=s[0];
                            Email_Error_color=s[1];
                          });
                        },
                        controller: email_controller,
                        decoration: InputDecoration(
                            hintText: 'Email',
                            fillColor: Colors.white,
                            errorText: Email_Error,
                            errorStyle: TextStyle(color:Email_Error_color),
                            filled: true,
                            focusedErrorBorder:UnderlineInputBorder(borderSide: BorderSide(color: Email_Error_color))  ,
                            focusedBorder:UnderlineInputBorder(borderSide: BorderSide(color: Email_Error_color)) ,
                            enabledBorder:UnderlineInputBorder(borderSide: BorderSide(color: Email_Error_color)) ,
                            errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Email_Error_color)),
                            prefixIcon: Icon(Icons.mail,color: Colors.green,size: 28,),
                          suffix: ElevatedButton(onPressed: () async {

                            s=Email_Validation(email_controller.text);
                            email_exist=await new database().Duplicate_email(email_controller.text, '${widget.collection_name}');
                            OTP=Generate_OTP();
                            print(OTP);
                                if(email_controller.text.isEmpty){
                                  EasyLoading.showInfo('Email required !');
                                  return;
                                }
                                if(s[1]==Colors.red){
                                  EasyLoading.showInfo('Invalid Email !');
                                  return;
                                }
                                if(!email_exist){
                                  EasyLoading.showError('Not Registered: ${email_controller.text}');
                                  return;
                                }
                                if(email_exist){
                                  try{
                                    Send_mail('user', OTP, email_controller.text);
                                    setState(() {
                                      saved_email=email_controller.text;
                                      OTP_sent=true;
                                    });
                                  }
                                  catch(e){
                                    EasyLoading.showError('Error');
                                    return;
                                  }

                                }


                          },child: Text('Get OTP'),   style:ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.green.shade700),
                          ))

                        ),

                      ),
                      if(OTP_sent)
                      Text(''),
                      if(OTP_sent)
                      TextField(

                        cursorColor: Colors.green.shade700,
                        controller: otp_controller,
                        decoration: InputDecoration(

                            focusedErrorBorder:UnderlineInputBorder(borderSide: BorderSide(color: Colors.green))  ,
                            focusedBorder:UnderlineInputBorder(borderSide: BorderSide(color: Colors.green)) ,
                            hintText: 'OTP',
                            prefixIcon: Icon(Icons.https,color: Colors.green,size: 28,)
                        ),
                      ),
                      if(OTP_sent)
                      Text(''),
                      if(OTP_sent)
                      TextField(
                        cursorColor: Colors.green.shade700,
                        controller: password_controller,
                        obscureText: hidepassword,
                        keyboardType: TextInputType.visiblePassword,
                        onChanged: (a){
                          setState(() {
                            var s=Password_Validation(a);
                            Password_Error=s[0];
                            Password_Error_color=s[1];
                          });
                        },
                        decoration: InputDecoration(
                            hintText: 'New Password',
                            errorText: Password_Error,
                            errorStyle: TextStyle(color: Password_Error_color),
                            prefixIcon: Icon(Icons.https,color: Colors.green,size: 28,),
                          suffixIcon: IconButton(onPressed: (){
                            setState(() {
                              hidepassword=!hidepassword;
                            });
                          },icon: Icon(Icons.remove_red_eye,color: Colors.green.shade700,),)
                         , fillColor: Colors.white,
                          filled: true,
                          focusedErrorBorder:UnderlineInputBorder(borderSide: BorderSide(color: Password_Error_color))  ,
                          focusedBorder:UnderlineInputBorder(borderSide: BorderSide(color: Password_Error_color)) ,
                          enabledBorder:UnderlineInputBorder(borderSide: BorderSide(color: Password_Error_color)) ,
                          errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Password_Error_color)),
                        ),
                      ),
                      if(OTP_sent)
                      Container(
                        width: size.width*0.7,
                        child: ElevatedButton(onPressed: (){
                          var j=Password_Validation(password_controller.text);
                          if(otp_controller.text.isEmpty){
                            EasyLoading.showInfo('Enter OTP ');
                            return;
                          }
                          if(password_controller.text.isEmpty){
                            EasyLoading.showInfo('Enter new password ! ');
                            return;
                          }
                          if(j[1]==Colors.red){
                            EasyLoading.showInfo('Invalid password! ');
                            return;
                          }
                          if(OTP!=otp_controller.text){
                            EasyLoading.showInfo('Inncorect OTP! ');
                            return;
                          }
                          if(OTP==otp_controller.text){
                            try{
                              new database().Update_password(password_controller.text,saved_email,widget.collection_name);
                              EasyLoading.showSuccess('Password updated');
                              Back_navigation();

                            }
                            catch(e){
                              EasyLoading.showError('Not Updated ! ');
                              return;
                            }

                          }



                        }, child: Text('Update')   ,style:ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.green.shade700),
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

  Back_navigation(){
    if(widget.collection_name=='farmers'){
      Navigator.pushReplacement(context, Myroute(farmerlogin()));
      return;
    }
    if(widget.collection_name=='dealer'){
      Navigator.pushReplacement(context, Myroute(dealerlogin()));
      return;
    }
    if(widget.collection_name=='company'){
      Navigator.pushReplacement(context, Myroute(companylogin()));
      return;
    }
  }
}