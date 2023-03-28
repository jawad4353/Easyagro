

import 'package:easyagro/Database/database.dart';
import 'package:easyagro/Farmer/farmerhome.dart';
import 'package:easyagro/forgotpassword.dart';
import 'package:easyagro/splash.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:proste_bezier_curve/proste_bezier_curve.dart';
import 'package:proste_bezier_curve/utils/type/index.dart';
import '../selection.dart';
import '../sharedpref_validations.dart';
import 'farmerregister.dart';

class farmerlogin extends StatefulWidget{
  @override
  State<farmerlogin> createState() => _farmerloginState();
}

class _farmerloginState extends State<farmerlogin> {
  TextEditingController email=new TextEditingController();
  TextEditingController password=new TextEditingController();
  GoogleSignInHelper _googleSignInHelper = GoogleSignInHelper();
  var  hidepassword=true,s,s1,Email_Error,Password_Error,Password_Error_color=Colors.grey,Email_Error_color=Colors.grey,is_valid_email;
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return Scaffold(
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
                      Text('Welcome Back',style: TextStyle(fontSize: 34,fontWeight: FontWeight.bold,color: Colors.white),)
                      ,
                      Text('Login to farmer account\n',style: TextStyle(fontSize: 17,color: Colors.white),)
                    ,
                      Text('\n \n \n'),
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
                        controller: email,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          errorText: Email_Error,
                          errorStyle: TextStyle(color:Email_Error_color),
                          hoverColor:Email_Error_color ,
                          focusColor:Email_Error_color ,
                        fillColor: Colors.white,
                        filled: true,
                        focusedErrorBorder:UnderlineInputBorder(borderSide: BorderSide(color: Email_Error_color))  ,
                        focusedBorder:UnderlineInputBorder(borderSide: BorderSide(color: Email_Error_color)) ,
                        enabledBorder:UnderlineInputBorder(borderSide: BorderSide(color: Email_Error_color)) ,
                        errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Email_Error_color)),
                          prefixIcon: Icon(Icons.mail,color: Colors.green,size: 28,)

                        ),

                      ),

                      TextField(
                        cursorColor: Colors.green.shade700,
                        controller: password,
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
                            hintText: 'Password',
                            errorText: Password_Error,
                            errorStyle: TextStyle(color: Password_Error_color),
                            suffixIcon: IconButton(icon: Icon(Icons.remove_red_eye,color: Colors.green.shade700,),onPressed: (){
                              setState(() {
                                hidepassword=!hidepassword;
                              });
                            },),
                            prefixIcon: Icon(Icons.https,color: Colors.green,size: 28,),
                           fillColor: Colors.white,
                           filled: true,
                           focusedErrorBorder:UnderlineInputBorder(borderSide: BorderSide(color: Password_Error_color))  ,
                           focusedBorder:UnderlineInputBorder(borderSide: BorderSide(color: Password_Error_color)) ,
                           enabledBorder:UnderlineInputBorder(borderSide: BorderSide(color: Password_Error_color)) ,
                           errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Password_Error_color)),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                        TextButton(onPressed: (){
                          Navigator.push(context, Myroute(forgotpassword(collection_name: 'farmers',)));
                        }, child: Text('Forgot Password?',style: TextStyle(color: Colors.green,fontSize: 16,fontWeight: FontWeight.bold),)),
                      ],),
                      Container(
                        clipBehavior: Clip.antiAlias,
                        width:size.width*0.73,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30)
                          ),
                          child: ElevatedButton(onPressed: () async {
                            s=Email_Validation(email.text);
                            s1=Password_Validation(password.text);

                            if(email.text.isEmpty){
                              EasyLoading.showInfo('Email required !');
                              return;
                            }
                            if(s[1]==Colors.red){
                              EasyLoading.showInfo('Invalid Email');
                              return;
                            }
                            if(password.text.isEmpty){
                              EasyLoading.showInfo('Password required !');
                              return;
                            }
                            if(s1[1]==Colors.red){
                              EasyLoading.showInfo('Invalid Password');
                              return;
                            }
                          EasyLoading.show(status: 'checking info');
                          var farmer_exist=await  new database().Login_Farmer(email.text, password.text);

                          if(farmer_exist){
                            Set_Shared_Preference('farmer',email.text,password.text);
                            EasyLoading.dismiss();
                            Navigator.pushReplacement(context, Myroute(farmerhome()));
                            return;
                          }
                          EasyLoading.showError('No account found with these creddentials \nEmail:${email.text}\nPassword:${password.text}');

                          }, child: Text('Login'),
                              style:ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.green.shade700),
                          ))),
                      Text('or continue with',style:TextStyle(color: Colors.grey,fontSize: 17) ,),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         InkWell(
                             onTap: () async {

                               var userCredential = await _googleSignInHelper.signInWithGoogle();
                               if(userCredential!.user!.email!.isEmpty){
                                 return;
                               }

                               new database().Register_Farmer(userCredential!.user!.email, '', userCredential!.user!.displayName);
                               Set_Shared_Preference('farmer',userCredential!.user!.email,'');
                               Navigator.pushReplacement(context, Myroute(farmerhome()));

                             },
                             child: Image.asset('images/google.png',height: 50,)),
                         Text('  '),
                         InkWell(child: Image.asset('images/twitter.png',height: 50,) ,)

                       ],
                     )
                     ,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have account ?",style: TextStyle(color: Colors.grey,fontSize: 17),),
                          TextButton(onPressed: (){
                            Navigator.push(context, Myroute(registerfarmer()));
                          }, child: Text('Register',style: TextStyle(color: Colors.green,fontSize: 16,fontWeight: FontWeight.bold),)),
                        ],),

                    ],
                  ),
                ),
              ),




            ],)


        ],
      ),
    );
  }
}