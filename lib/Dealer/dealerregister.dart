

import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:easyagro/Dealer/dealerlogin.dart';
import 'package:easyagro/splash.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proste_bezier_curve/proste_bezier_curve.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Database/database.dart';
import '../OTP.dart';
import '../sharedpref_validations.dart';

class dealerregister extends StatefulWidget{
  @override
  State<dealerregister> createState() => _dealerregisterState();
}

class _dealerregisterState extends State<dealerregister> {

 var  hidepassword=true,Email_Error,Email_Error_color=Colors.grey,Address_error,Address_error_color=Colors.grey,
     Name_Error,Name_error_color=Colors.grey,Password_Error, Password_Error_color=Colors.grey,Liscense_error,
     Liscence_Error_color=Colors.grey,countrycode='+92',allvalid=false,phone_error,phone_error_color=Colors.grey,
     image_uploaded=false;


 TextEditingController name_controller=new TextEditingController();
 TextEditingController license_controller=new TextEditingController();
 TextEditingController address_controller=new TextEditingController();
 TextEditingController email_controller=new TextEditingController();
 TextEditingController phone_controller=new TextEditingController();
 TextEditingController password_controller=new TextEditingController();
 final picker = ImagePicker();
 var license_image;

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
                Container(height: size.height),
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
                  top: size.height*0.04,
                  left: size.width*0.04,
                  child: Container(
                      height: 48,
                      width: 40,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle
                      ),child:  IconButton(onPressed: (){
                    Navigator.pushReplacement(context, Myroute(dealerlogin()));
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
                        Text('Dealer  account\n',style: TextStyle(fontSize: 17,color: Colors.white),)

                        ,Text('\n \n \n \n')
                        ,  Container(
                          height: size.height*0.6,
                          child: ListView(children: [
                            TextField(
                              cursorColor: Colors.green.shade700,
                              controller: name_controller,
                              inputFormatters: [  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z - ]')),],
                              keyboardType: TextInputType.name,
                              onChanged: (a){
                                setState(() {

                                  var s=Name_Validation(a.replaceAll(' ', ''));
                                  Name_Error=s[0];
                                  Name_error_color=s[1];
                                });
                              },
                              decoration: InputDecoration(
                                  hintText: 'Name on CNIC',
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
                              cursorColor: Colors.green.shade700,
                              inputFormatters: [  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),],
                              keyboardType: TextInputType.number,
                              controller: license_controller,
                              onChanged: (a){
                                setState(() {
                                  var s= Liscense_Validate(a);
                                  Liscense_error=s[0];
                                  Liscence_Error_color=s[1];

                                });
                              },
                              decoration: InputDecoration(
                                hintText: 'License no',
                                prefixIcon: Icon(Icons.vpn_key_rounded,color: Colors.green,size: 28,),
                                errorText: Liscense_error,
                                errorStyle: TextStyle(color: Liscence_Error_color),
                                focusedErrorBorder:UnderlineInputBorder(borderSide: BorderSide(color: Liscence_Error_color))
                                ,focusedBorder:UnderlineInputBorder(borderSide: BorderSide(color: Liscence_Error_color)) ,
                                enabledBorder:UnderlineInputBorder(borderSide: BorderSide(color: Liscence_Error_color)) ,
                                errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Liscence_Error_color)),

                              ),)

                            ,
                            TextField(
                              cursorColor: Colors.green.shade700,
                              keyboardType: TextInputType.visiblePassword,
                              controller: address_controller,
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
                                  var s=Email_Validation(a);
                                  Email_Error=s[0];
                                  Email_Error_color=s[1];

                                });
                              },
                              decoration: InputDecoration(
                                hintText: 'Email',
                                prefixIcon: Icon(Icons.mail,color: Colors.green,size: 28,),
                                errorText: Email_Error,
                                errorStyle: TextStyle(color:Email_Error_color),
                                fillColor: Colors.white,
                                filled: true,
                                focusedErrorBorder:UnderlineInputBorder(borderSide: BorderSide(color: Email_Error_color))  ,
                                focusedBorder:UnderlineInputBorder(borderSide: BorderSide(color: Email_Error_color)) ,
                                enabledBorder:UnderlineInputBorder(borderSide: BorderSide(color: Email_Error_color)) ,
                                errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Email_Error_color)),

                              ),

                            ),

                            TextField(
                              controller: password_controller,
                              cursorColor: Colors.green.shade700,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText:  hidepassword,
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
                            TextField(
                              controller: phone_controller,
                              cursorColor: Colors.green.shade700,
                              keyboardType: TextInputType.phone,
                              onChanged: (a){
                                setState(() {
                                  var d=phone_Validate(a);
                                  phone_error=d[0];
                                  phone_error_color=d[1];
                                  allvalid=false;
                                  if(phone_error_color==Colors.green){
                                    allvalid=true;
                                  }
                                });
                              },
                              inputFormatters: [  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),],
                              decoration: InputDecoration(
                                hintText: 'Phone',
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
                            Text(''),
                            GestureDetector(
                              onTap: getlicenseImage,
                              child: Container(
                                height: 150,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(10),
                                  image: license_image == null
                                      ? null
                                      : DecorationImage(
                                    image: FileImage(license_image),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                child: license_image == null
                                    ?  Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add_a_photo_rounded),
                                    Text('License front photo')
                                  ],)
                                    : null,
                              ),
                            ),
                          ],),
                        ),

                        Container(
                            clipBehavior: Clip.antiAlias,
                            width:size.width*0.73,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30)
                            ),
                            child: ElevatedButton(onPressed: () async {

                              var data=[],OTP,mode,f1,f2,f3,f4,f5,duplicate_license,duplicate_email,duplicate_phone;
                              SharedPreferences pref =await SharedPreferences.getInstance();
                              mode=await pref.getString('mode');
                              FirebaseStorage _storage=FirebaseStorage.instance;
                              var storagereflicense=_storage.ref("dealer_licenses/${email_controller.text}");
                              data.add(name_controller.text);
                              data.add(license_controller.text);
                              data.add(address_controller.text);
                              data.add(email_controller.text);
                              data.add(countrycode+phone_controller.text);
                              data.add(password_controller.text);
                              OTP=Generate_OTP();
                              print(OTP);
                              f1=Name_Validation(name_controller.text.replaceAll(' ', ''));
                              f2=Liscense_Validate(license_controller.text);
                              f3=Address_Validation(address_controller.text.replaceAll(' ', ''));
                              f4=Email_Validation(email_controller.text);
                              f5=Password_Validation(password_controller.text);
                              EasyLoading.show(status: 'Processing...');
                              duplicate_license=await new database().Duplicate_license(license_controller.text,'dealer');
                              duplicate_email=await new database().Duplicate_email(email_controller.text,'dealer');
                              duplicate_phone=await new database().Duplicate_phone(countrycode+phone_controller.text,'dealer');

                              if(name_controller.text.isEmpty){
                                EasyLoading.showInfo('Name required !');
                                return;
                              }
                              if(f1[1]==Colors.red){
                                EasyLoading.showInfo('Invalid name');
                                return;
                              }

                              if(license_controller.text.isEmpty){
                                EasyLoading.showInfo('license required !');
                                return;
                              }
                              if(f2[1]==Colors.red){
                                EasyLoading.showInfo('Invalid License !');
                                return;
                              }

                              if(duplicate_license==true){
                                EasyLoading.showInfo('Already registered Liscense : ${license_controller.text}');
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
                              if(duplicate_phone==true){
                                EasyLoading.showInfo('Already registered Phone number : ${countrycode+phone_controller.text}');
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
                              if(license_image==null){
                                EasyLoading.showInfo('Upload License front picture!');
                                return;
                              }
                              var b=new File(license_image!.path);
                              try{

                                var task1=storagereflicense.putFile(b as File);
                              }
                              catch(e){
                                EasyLoading.showError('Images Not uploaded .Try again !');
                                return;
                              }
                              EasyLoading.dismiss();
                            print(OTP);

                              Send_mail(name_controller.text, OTP, email_controller.text);
                              Navigator.push(context, Myroute(OTP_screen(Data: data,type: 'dealer',OTP: OTP,)));



                            }, child: Text('Register'),
                                style:ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.green.shade700),
                                ))),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Already have account ?",style: TextStyle(color: Colors.grey,fontSize: 17),),
                            TextButton(onPressed: (){
                              Navigator.pushReplacement(context, Myroute(dealerlogin()));
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


 Future getlicenseImage() async {
   final pickedFile = await picker.getImage(
     source: ImageSource.camera,
     imageQuality: 75,
   );

   setState(() {
     if (pickedFile != null) {
       license_image = File(pickedFile.path);

     } else {
       EasyLoading.showInfo('No image selected');
     }
   });
 }
}