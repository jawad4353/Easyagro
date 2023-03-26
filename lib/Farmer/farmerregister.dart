import 'package:easyagro/Farmer/farmerlogin.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:proste_bezier_curve/proste_bezier_curve.dart';
import '../Database/database.dart';
import '../splash.dart';
import '../sharedpref_validations.dart';
import '../OTP.dart';

class registerfarmer extends StatefulWidget {
  @override
  State<registerfarmer> createState() => _registerfarmerState();
}

class _registerfarmerState extends State<registerfarmer> {
  var hidepassword=true, Email_Error,Password_Error,Password_Error_color=Colors.grey,
      Email_Error_color=Colors.grey,is_valid_email,Name_Error,Name_error_color=Colors.grey,data=[],
  s,s1,s3,OTP;

  TextEditingController name=new TextEditingController();
  TextEditingController email=new TextEditingController();
  TextEditingController password=new TextEditingController();

  @override
  Widget build(BuildContext context) {
      var size=MediaQuery.of(context).size;
      return WillPopScope(
        onWillPop: ()=>onClick(context),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: ListView(
            children: [
              Stack(
                children: [
                  Container(height: size.height,),
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
                      child: Opacity(opacity: 0.3,child: Image.asset('images/back.jpg',fit: BoxFit.cover,),),
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
                      Navigator.pushReplacement(context, Myroute(farmerlogin()));
                    },icon: Icon(Icons.arrow_back_ios,color: Colors.green.shade700,size: 30,),)),
                  ),

                  Positioned(
                    top: size.height*0.08,
                    left: size.width*0.1,
                    right:size.width*0.1 ,
                    child: Container(
                      width: size.width*0.8,
                      child: Column(
                        children: [
                          Text('Register',style: TextStyle(fontSize: 34,fontWeight: FontWeight.bold,color: Colors.white),)
                          ,
                          Text('Farmer  account\n',style: TextStyle(fontSize: 17,color: Colors.white),)

                         ,Text('\n \n \n \n')
                          ,  TextField(
                            cursorColor: Colors.green.shade700,
                            controller: name,
                            onChanged: (a){
                              setState(() {
                                var s=Name_Validation(a.replaceAll(' ', ''));
                                Name_Error=s[0];
                                Name_error_color=s[1];

                              });
                            },
                            inputFormatters: [  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z.-. - ]')),],
                        keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                                hintText: 'Name',
                                errorText: Name_Error,
                                errorStyle:TextStyle(color:Name_error_color) ,
                                prefixIcon: Icon(Icons.supervised_user_circle_sharp,color: Colors.green,size: 28,)
                               ,
                                 filled: true,
                                fillColor: Colors.white
                                 ,focusedErrorBorder:UnderlineInputBorder(borderSide: BorderSide(color: Name_error_color))  ,
                                 focusedBorder:UnderlineInputBorder(borderSide: BorderSide(color: Name_error_color)) ,
                                 enabledBorder:UnderlineInputBorder(borderSide: BorderSide(color: Name_error_color)) ,
                                 errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Name_error_color)),
                            ),

                          ),
                          TextField(
                            cursorColor: Colors.green.shade700,
                            controller: email,
                            onChanged: (a){
                              setState(() {
                               var s=Email_Validation(a);
                               Email_Error=s[0];
                               Email_Error_color=s[1];
                              });
                            },
                            inputFormatters: [  FilteringTextInputFormatter.allow(RegExp(r'[0-9a-zA-Z.-.@-@_-_]')),],
                            decoration: InputDecoration(
                                hintText: 'Email',
                                prefixIcon: Icon(Icons.mail,color: Colors.green,size: 28,),
                              fillColor: Colors.white,
                              filled: true,
                              errorText: Email_Error,
                              errorStyle: TextStyle(color:Email_Error_color),
                              hoverColor:Email_Error_color ,
                              focusColor:Email_Error_color ,
                              focusedErrorBorder:UnderlineInputBorder(borderSide: BorderSide(color: Email_Error_color))  ,
                              focusedBorder:UnderlineInputBorder(borderSide: BorderSide(color: Email_Error_color)) ,
                              enabledBorder:UnderlineInputBorder(borderSide: BorderSide(color: Email_Error_color)) ,
                              errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Email_Error_color)),
                            ),

                          ),

                          TextField(
                            cursorColor: Colors.green.shade700,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: hidepassword,
                            controller: password,
                            onChanged: (a){
                              setState(() {
                               var s=Password_Validation(a);
                               Password_Error=s[0];
                               Password_Error_color=s[1];

                              });
                            },
                            decoration: InputDecoration(
                                hintText: 'Password',
                                suffixIcon: IconButton(icon: Icon(Icons.remove_red_eye,color: Colors.green.shade700,),onPressed: (){
                                  setState(() {
                                    hidepassword=!hidepassword;
                                  });
                                },),
                                prefixIcon: Icon(Icons.https,color: Colors.green,size: 28,),
                              fillColor: Colors.white,
                              filled: true,
                              errorText: Password_Error,
                              errorStyle: TextStyle(color: Password_Error_color),
                              focusedErrorBorder:UnderlineInputBorder(borderSide: BorderSide(color: Password_Error_color))  ,
                              focusedBorder:UnderlineInputBorder(borderSide: BorderSide(color: Password_Error_color)) ,
                              enabledBorder:UnderlineInputBorder(borderSide: BorderSide(color: Password_Error_color)) ,
                              errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Password_Error_color)),
                            ),
                          ),

                          Container(
                              clipBehavior: Clip.antiAlias,
                              width:size.width*0.73,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30)
                              ),
                              child: ElevatedButton(onPressed: () async {

                               data.add(name.text);
                               data.add(email.text);
                               data.add(password.text);
                               s=Email_Validation(email.text);
                               s1=Password_Validation(password.text);
                               s3=Name_Validation(name.text);
                               OTP=Generate_OTP();
                               print(OTP);
                               EasyLoading.show(status: 'Processing');
                               var s4=await new database().Duplicate_email(email.text,'farmers');
                               if(name.text.isEmpty){
                                 EasyLoading.showInfo('Name Required !');
                                 return;
                               }
                               if(s3[1]==Colors.red){
                                 EasyLoading.showInfo('Invalid Name');
                                 return;
                               }
                               if(email.text.isEmpty){
                                 EasyLoading.showInfo('Email Required !');
                                 return;
                               }
                               if(s[1]==Colors.red){
                                 EasyLoading.showInfo('Invalid Email');
                                 return;
                               }
                               if(s4){
                                 EasyLoading.showError('Email Already Registered .\nEmail : ${email.text}');
                                  return;
                               }
                               if(password.text.isEmpty){
                                 EasyLoading.showInfo('Password Required !');
                                 return;
                               }

                               if(s1[1]==Colors.red){
                                 EasyLoading.showInfo('Invalid Password');
                                 return;
                               }

                               try{
                                 Send_mail(name.text,OTP,email.text);
                                 EasyLoading.showSuccess(' OTP  sent successfully');
                               }
                               catch(e){
                                 EasyLoading.showInfo('Error ! OTP not sent');
                                 return;
                               }
                               EasyLoading.dismiss();
                               print(OTP);
                                Navigator.push(context, Myroute(OTP_screen(Data: data,type: 'farmer',OTP: OTP,)));
                              }, child: Text('Register'),
                                  style:ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.green.shade700),
                                  ))),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Already have account ?",style: TextStyle(color: Colors.grey,fontSize: 17),),
                              TextButton(onPressed: (){
                                Navigator.pushReplacement(context, Myroute(farmerlogin()));
                              }, child: Text('Login',style: TextStyle(color: Colors.green,fontSize: 16,fontWeight: FontWeight.bold),)),
                            ],),
                        ],
                      ),
                    ),
                  ),




                ],)


            ],
          ),
        ),
      );
    }


}



