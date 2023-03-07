

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:easyagro/Company/companyhome.dart';
import 'package:easyagro/OTP.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:proste_bezier_curve/proste_bezier_curve.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Database/database.dart';
import '../sharedpref_validations.dart';
import '../splash.dart';

class update_company_account extends StatefulWidget{
  var user_data=[];
  update_company_account({required this.user_data});
  @override
  State<update_company_account> createState() => _update_company_accountState();
}

class _update_company_accountState extends State<update_company_account> {
  var hidepassword=true,Address_error,phone_error,phone_error_color=Colors.grey,Address_error_color=Colors.grey,Name_Error,Name_error_color=Colors.grey,Email_Error,Email_Error_color=Colors.grey,Password_Error,Password_Error_color=Colors.grey,Liscense_error,Liscence_Error_color=Colors.grey;
  var countrycode='+92',license_image;
  TextEditingController company_controller=new TextEditingController();
  TextEditingController address_controller=new TextEditingController();
  TextEditingController email_controller=new TextEditingController();
  TextEditingController phone_controller=new TextEditingController();
  TextEditingController password_controller=new TextEditingController();

  @override
  void initState() {
    super.initState();
    company_controller.text=widget.user_data[0];
    email_controller.text=widget.user_data[1];
    password_controller.text=widget.user_data[2];
    phone_controller.text=widget.user_data[3];
    address_controller.text=widget.user_data[5];

  }

 
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
   return WillPopScope(
     onWillPop: ()=>onClick(context),
     child: Scaffold(
       backgroundColor: Colors.white,
       body: ListView(children: [
        Stack(
        children: [
          Container(height: size.height*0.8,),
          ClipPath(
          clipper: ProsteBezierCurve(
            position: ClipPosition.bottom,
            list: [
              BezierCurveSection(
                start: Offset(0, 166),
                top: Offset(size.width / 4, 110),
                end: Offset(size.width / 2, 155),
              ),
              BezierCurveSection(
                start: Offset(size.width / 2, 25),
                top: Offset(size.width / 4 * 3, 80),
                end: Offset(size.width, 150),
              ),
            ],
          ),child: Container(color: Colors.green.shade700,height: 220,),

        ),
          Positioned(
            top: 10,
              left: 10,
              child: Row(

                children: [
                Container(
                    height: 38,
                    width: 30,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle
                    ),child:  IconButton(onPressed: (){
                  Navigator.pushReplacement(context, Myroute(companyhome()));
                },icon: Icon(Icons.arrow_back_ios,color: Colors.green,size: 25,),)),
               Padding(padding: EdgeInsets.only(left: size.width*0.24)),
                Text('  Profile',style: TextStyle(fontSize: 22,color: Colors.white,fontWeight: FontWeight.bold,fontFamily: 'jd'),)
              ],))
        ,
        Positioned(
          left: 40,
          right: 40,
          child: Container(
            height: size.height*0.78,

            child: ListView(
              children: [
                Text('\n \n'),

                CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.transparent,
                 child: Container(
                     clipBehavior: Clip.antiAlias,
                     decoration: BoxDecoration(
                       color: Colors.white,
                       shape: BoxShape.circle,
                       boxShadow: [BoxShadow(color: Colors.green.shade700,spreadRadius: 4)]
                     ),
                     child: Image.network('${widget.user_data[6]}',fit: BoxFit.cover,)),
              ),
              Text('\n'),
               TextField(
                     controller: company_controller,
                     inputFormatters: [  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z - ]')),],
                     keyboardType: TextInputType.name,
                    cursorColor: Colors.green.shade700,
                    onChanged: (a){
                    setState(() {

                    var s=Name_Validation(a.replaceAll(' ', ''));
                    Name_Error=s[0];
                    Name_error_color=s[1];
          });
    },
                 decoration: InputDecoration(
                 hintText: 'Company Name',
                 errorText: Name_Error,

                 errorStyle:TextStyle(color:Name_error_color) ,
                 filled: true,
                 fillColor: Colors.white
                ,focusedErrorBorder:UnderlineInputBorder(borderSide: BorderSide(color: Name_error_color))  ,
                focusedBorder:UnderlineInputBorder(borderSide: BorderSide(color: Name_error_color)) ,
                enabledBorder:UnderlineInputBorder(borderSide: BorderSide(color: Name_error_color)) ,
                errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Name_error_color)),
               prefixIcon: Icon(Icons.supervised_user_circle_sharp,color: Colors.green,size: 28,)

                    ),
              ),


              TextField(
              controller: address_controller,
              cursorColor: Colors.green.shade700,
              keyboardType: TextInputType.visiblePassword,
              onChanged: (a){
              setState(() {

                    var s=Address_Validation(a.replaceAll(' ', ''));
                    Address_error=s[0];
                    Address_error_color=s[1];
                   });
                },
            decoration: InputDecoration(
            hintText: 'Address',
            prefixIcon: Icon(Icons.location_on,color: Colors.green,size: 28,),
            errorText: Address_error,
            filled: true,
            fillColor: Colors.white,
            errorStyle: TextStyle(color: Address_error_color),
            focusedErrorBorder:UnderlineInputBorder(borderSide: BorderSide(color: Address_error_color))
            ,focusedBorder:UnderlineInputBorder(borderSide: BorderSide(color: Address_error_color)) ,
            enabledBorder:UnderlineInputBorder(borderSide: BorderSide(color:Address_error_color)) ,
            errorBorder: UnderlineInputBorder(borderSide: BorderSide(color:Address_error_color)),

          ),)

                ,
                TextField(
                  controller: email_controller,
                  cursorColor: Colors.green.shade700,
                  keyboardType: TextInputType.visiblePassword,
                  inputFormatters: [  FilteringTextInputFormatter.allow(RegExp(r'[0-9a-zA-Z.-.@-@_-_]')),],
                  onChanged: (a){
                    setState(() {
                      print(a);
                      var s=Email_Validation(a);
                      Email_Error=s[0];
                      Email_Error_color=s[1];

                    });
                  },
                  decoration: InputDecoration(
                      hintText: 'Email',
                      errorText: Email_Error,
                      errorStyle: TextStyle(color:Email_Error_color),
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
                  controller: phone_controller,
                  cursorColor: Colors.green.shade700,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),],
                  onChanged: (a){
                    setState(() {
                      var d=phone_Validate(a);
                      phone_error=d[0];
                      phone_error_color=d[1];
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Phone',
                    contentPadding: EdgeInsets.only(top: 15),
                    prefixIcon: ElevatedButton(style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white
                    ),child: Text('${countrycode}',style: TextStyle(color: Colors.black,fontSize: 18),),onPressed: () async {
                      showCountryPicker(
                        context: context,
                        showPhoneCode: true,
                        countryListTheme: CountryListThemeData(
                            inputDecoration: InputDecoration(
                              hintText: 'Search',
                              fillColor: Colors.white,
                              filled: true,
                              focusedErrorBorder:UnderlineInputBorder(borderSide: BorderSide(color: Colors.green))  ,
                              focusedBorder:UnderlineInputBorder(borderSide: BorderSide(color: Colors.green)) ,
                              enabledBorder:UnderlineInputBorder(borderSide: BorderSide(color:Colors.grey)) ,
                              errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                              border:  UnderlineInputBorder(borderSide: BorderSide(color:Colors.grey)),
                            )
                        ),// optional. Shows phone code before the country name.
                        onSelect: (Country country) {
                          print('Select country: ${country.displayName}');
                          setState(() {
                            countrycode='+'+country.phoneCode;
                          });
                        },
                      );


                    },),

                    errorText:phone_error,
                    errorStyle: TextStyle(color:phone_error_color),
                    fillColor: Colors.white,
                    filled: true,
                    focusedErrorBorder:UnderlineInputBorder(borderSide: BorderSide(color: phone_error_color))  ,
                    focusedBorder:UnderlineInputBorder(borderSide: BorderSide(color:phone_error_color)) ,
                    enabledBorder:UnderlineInputBorder(borderSide: BorderSide(color: phone_error_color)) ,
                    errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: phone_error_color)),

                  ),

                ),



                TextField(
                  controller: password_controller,
                  cursorColor: Colors.green.shade700,
                  obscureText: hidepassword,
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

             ],
            ),
          ),
        )],

        ),
         Padding(
           padding:  EdgeInsets.only(right: size.width*0.14,left: size.width*0.14),
           child: ElevatedButton(style: ButtonStyle(
             backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.green.shade700)
           ),onPressed: () async {
             var f1,f2,f3,f4,f5,duplicate_email,mode,new_data=[],OTP;
             f1=Name_Validation(company_controller.text.replaceAll(' ', ''));
             f3=Address_Validation(address_controller.text.replaceAll(' ', ''));
             f4=Email_Validation(email_controller.text);
             f5=Password_Validation(password_controller.text);
             SharedPreferences pref =await SharedPreferences.getInstance();
             mode=await pref.getString('mode');
             duplicate_email=await new database().Duplicate_email_updation(email_controller.text,'company',widget.user_data[4]);




             if(company_controller.text.isEmpty){
               EasyLoading.showInfo('Name required !');
               return;
             }
             if(f1[1]==Colors.red){
               EasyLoading.showInfo('Invalid name');
               return;
             }

             if(address_controller.text.isEmpty){
               EasyLoading.showInfo('Address required !');
               return;
             }
             if(f3[1]==Colors.red){
               EasyLoading.showInfo('Invalid Address');
               return;
             }
             if(email_controller.text.isEmpty){
               EasyLoading.showInfo('Email required !');

               return;
             }
             if(f4[1]==Colors.red){
               EasyLoading.showInfo('Invalid Email');
               return;
             }

             if(duplicate_email==true){
               EasyLoading.showInfo('Already registered Email : ${email_controller.text}');
               return;
             }
             if(phone_controller.text.isEmpty){
               EasyLoading.showInfo('Phone required !');
               return;
             }
             if(phone_controller.text.length!=10){
               EasyLoading.showInfo('Invalid Phone!');
               return;
             }

             if(password_controller.text.isEmpty){
               EasyLoading.showInfo('Password required !');
               return;
             }
             if(f5[1]==Colors.red){
               EasyLoading.showInfo('Invalid Password!');
               return;
             }
             if(mode=='offline'){
               EasyLoading.showInfo('Offline ! Connect to internet ');
               return;
             }
             OTP=Generate_OTP();
             new_data.add(widget.user_data[4]);
             new_data.add(company_controller.text);
             new_data.add(email_controller.text);
             new_data.add(countrycode+phone_controller.text);
             new_data.add(password_controller.text);
             new_data.add(address_controller.text);
             new_data.add(widget.user_data[1]);
             print(OTP);
             Send_mail(widget.user_data[0], OTP,email_controller.text );
             Navigator.push(context, Myroute(OTP_screen(Data: new_data,type: 'update_profile_company',OTP:OTP ,)));





           }, child: Text('Update',style: TextStyle(fontSize: 17),)),
         )
       ],),
     ),
   );
  }


}