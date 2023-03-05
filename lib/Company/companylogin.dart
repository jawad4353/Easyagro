

import 'package:easyagro/Company/companyhome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:proste_bezier_curve/proste_bezier_curve.dart';

import '../Database/database.dart';
import '../forgotpassword.dart';
import '../selection.dart';
import '../splash.dart';
import '../sharedpref_validations.dart';
import 'companyregister.dart';

class companylogin extends StatefulWidget{
  @override
  State<companylogin> createState() => _companyloginState();
}

class _companyloginState extends State<companylogin> {
  var hidepassword=true ,Password_Error,Password_Error_color=Colors.grey,Liscense_error,Liscence_Error_color=Colors.grey;
  TextEditingController license_controller=new TextEditingController();
  TextEditingController password_controller=new TextEditingController();

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
                      Text('WelcomeBack',style: TextStyle(fontSize: 34,fontWeight: FontWeight.bold,color: Colors.white),)
                      ,
                      Text('Login to company account\n',style: TextStyle(fontSize: 17,color: Colors.white),)

                   ,Text('\n \n \n \n'),
                       TextField(
                        cursorColor: Colors.green.shade700,
                        controller: license_controller,
                        inputFormatters: [  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),],
                        keyboardType: TextInputType.number,
                        onChanged: (a){
                          setState(() {
                           var s= Liscense_Validate(a);
                           Liscense_error=s[0];
                           Liscence_Error_color=s[1];

                          });
                        },
                        decoration: InputDecoration(
                            hintText: 'Liscence no',
                            errorText: Liscense_error,
                            errorStyle: TextStyle(color: Liscence_Error_color),
                            prefixIcon: Icon(Icons.vpn_key_rounded,color: Colors.green,size: 28,)
                         , fillColor: Colors.white,
                          filled: true,
                          focusedErrorBorder:UnderlineInputBorder(borderSide: BorderSide(color: Liscence_Error_color))  ,
                          focusedBorder:UnderlineInputBorder(borderSide: BorderSide(color: Liscence_Error_color)) ,
                          enabledBorder:UnderlineInputBorder(borderSide: BorderSide(color: Liscence_Error_color)) ,
                          errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Liscence_Error_color)),
                        ),

                      ),

                      TextField(
                        cursorColor: Colors.green.shade700,
                        obscureText: hidepassword,
                        controller: password_controller,
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
                            fillColor: Colors.white,
                            filled: true,
                            focusedErrorBorder:UnderlineInputBorder(borderSide: BorderSide(color: Password_Error_color))  ,
                            focusedBorder:UnderlineInputBorder(borderSide: BorderSide(color: Password_Error_color)) ,
                            enabledBorder:UnderlineInputBorder(borderSide: BorderSide(color: Password_Error_color)) ,
                            errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Password_Error_color)),
                            suffixIcon: IconButton(icon: Icon(Icons.remove_red_eye,color: Colors.green.shade700,),onPressed: (){
                              setState(() {
                                hidepassword=!hidepassword;
                              });
                            },),
                            prefixIcon: Icon(Icons.https,color: Colors.green,size: 28,)
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(onPressed: (){
                            Navigator.push(context, Myroute(forgotpassword(collection_name: 'company',)));
                          }, child: Text('Forgot Password?',style: TextStyle(color: Colors.green,fontSize: 16,fontWeight: FontWeight.bold),)),
                        ],),
                      Container(
                          clipBehavior: Clip.antiAlias,
                          width:size.width*0.73,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30)
                          ),
                          child: ElevatedButton(onPressed: () async {
                           var userexist=await new database().Login_company(license_controller.text,password_controller.text);
                           var s=Password_Validation(password_controller.text);
                            if(license_controller.text.isEmpty){
                              EasyLoading.showInfo('License required !');
                              return;
                            }
                           if(license_controller.text.length!=13){
                             EasyLoading.showInfo('Invalid License!');
                             return;
                           }
                           if(password_controller.text.isEmpty){
                             EasyLoading.showInfo('Password required !');
                             return;
                           }
                           if(s[1]==Colors.red){
                             EasyLoading.showInfo('Invalid password!');
                             return;
                           }
                           if(userexist==false){
                             EasyLoading.showError('Incorrect credentials! ! \nlicense : ${license_controller.text}\npassword : ${password_controller.text}');
                             return;
                           }
                           Set_Shared_Preference('company', license_controller.text, password_controller.text);
                           EasyLoading.showSuccess('Login Successful');
                           Navigator.pushReplacement(context, Myroute(companyhome()));

                          }, child: Text('Login'),
                              style:ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.green.shade700),
                              ))),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have account ?",style: TextStyle(color: Colors.grey,fontSize: 17),),
                          TextButton(onPressed: (){
                            Navigator.push(context, Myroute(companyresgister()));
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