
import 'dart:convert';

import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';


Future<void> Set_Shared_Preference(user_type,email,password) async {
  SharedPreferences pref =await SharedPreferences.getInstance();
 await pref.setString("email", "${email}");
  await pref.setString("password", "${password}");
  await pref.setString("usertype", user_type);
  print(user_type);
}

 Get_Shared_Preference() async {
  SharedPreferences pref =await SharedPreferences.getInstance();
  pref.getString("email");
  pref.getString("password");
  return await pref.getString("usertype");
}



Clear_Preferences() async {
  SharedPreferences pref =await SharedPreferences.getInstance();
  pref.clear();
}



 UploadShop_image(foldername,image_name) async {
  FirebaseStorage _storage=FirebaseStorage.instance;
  PickedFile? _image=await ImagePicker.platform.pickImage(source: ImageSource.gallery);
  var storageref=_storage.ref("${foldername}/${image_name}");
  if(_image==null){
    EasyLoading.showError('Choose any image');
    return false;
  }
  var a= new File(_image!.path);
  EasyLoading.show(status: 'Uploading');
  try{
    var task=storageref.putFile(a as File);
    print(task.whenComplete(() => EasyLoading.showSuccess('Uploaded')));
    return true;
  }
  catch(e){
    EasyLoading.showError('Image has not been Uploaded');
  }

}








bool Validate_Email(email){
  String  pattern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  RegExp regExp = new RegExp(pattern);
  return regExp.hasMatch(email);
}

bool Validate_Password(String password){
  String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  RegExp regExp = new RegExp(pattern);
  return regExp.hasMatch(password) ;
}


List Email_Validation(a){
  var mylist=[],is_valid_email;
  if(a.isEmpty){
    mylist.add(null);
    mylist.add(Colors.grey);
    return mylist;
  }
  is_valid_email=EmailValidator.validate(a);
  if(!is_valid_email) {
    mylist.add('Invalid Email');
    mylist.add(Colors.red);
    return mylist;
  }

  if(!'${a}'.endsWith('.com')  ) {
    mylist.add('Invalid Email');
    mylist.add(Colors.red);
    return mylist;
  }

  mylist.add('Valid Email');
  mylist.add(Colors.green);
  return mylist;


}



List Password_Validation(a){
  var mylist=[],is_valid_email;
  if(a.isEmpty){
    mylist.add(null);
    mylist.add(Colors.grey);
    return mylist;
  }

  if(!Validate_Password(a)) {
    mylist.add('Must have length 8,one upper & lowercase,\ndigit,specialchar');
    mylist.add(Colors.red);
    return mylist;
  }
  if(a.length>16){
    mylist.add('Password length should not exceed 15');
    mylist.add(Colors.red);
    return mylist;
  }

  mylist.add('Valid Password');
  mylist.add(Colors.green);
  return mylist;


}








List Name_Validation(a){
  var mylist=[];
  if(a.isEmpty){
    mylist.add(null);
    mylist.add(Colors.grey);
    return mylist;
  }

  if(a.length<3) {
    mylist.add('Must have three characters');
    mylist.add(Colors.red);
    return mylist;
  }
  if(a.length>21){
    mylist.add('Name length should not exceed 20');
    mylist.add(Colors.red);
    return mylist;
  }

  mylist.add('Valid Name');
  mylist.add(Colors.green);
  return mylist;


}




List Address_Validation(a){
  var mylist=[];
  if(a.isEmpty){
    mylist.add(null);
    mylist.add(Colors.grey);
    return mylist;
  }

  if(a.length<8) {
    mylist.add('Must have Eight characters');
    mylist.add(Colors.red);
    return mylist;
  }
  if(a.length>50){
    mylist.add('Address length should not exceed 50');
    mylist.add(Colors.red);
    return mylist;
  }
  mylist.add('Valid Address');
  mylist.add(Colors.green);
  return mylist;


}




List Liscense_Validate(a)  {
  var mylist=[];
  if(a.isEmpty){
    mylist.add(null);
    mylist.add(Colors.grey);
    return mylist;
  }
  if(a.length<13 || a.length>13){
    mylist.add('Enter 13 digit Liscense number');
    mylist.add(Colors.red);
    return mylist;
  }
 mylist.add('Valid Liscense no');
  mylist.add(Colors.green);
 return mylist;
}

List phone_Validate(a)  {
  var mylist=[];
  if(a.isEmpty){
    mylist.add(null);
    mylist.add(Colors.grey);
    return mylist;
  }
  if(a.length<10 || a.length>10){
    mylist.add('Enter 10 digit number');
    mylist.add(Colors.red);
    return mylist;
  }
  mylist.add('Valid Phone');
  mylist.add(Colors.green);
  return mylist;
}





 Generate_OTP(){
  var ABC=['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q',
    'R','S','T','U','V','W','X','Y','Z'
  ],abc=['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p',
  'q','r','s','t','u','v','w','x','y','z'
  ];
  Random a=new Random();
  var random_number=a.nextInt(999999);
  var capital_alphabet=ABC[a.nextInt(ABC.length-1)];
  var capital_alphabet1=ABC[a.nextInt(ABC.length-1)];
  var small_alphabet=abc[a.nextInt(ABC.length-1)];
  return '${capital_alphabet1+small_alphabet+random_number.toString()+capital_alphabet}';
}







void Send_mail(name,OTP,receiver_email){
  var
      Service_id='service_plttjgm',
      Template_id='template_z5tnyrc',
      User_id='_ILHAzYAP3Rq7M8s7';
  var s=http.post(Uri.parse('https://api.emailjs.com/api/v1.0/email/send'),
      headers: {
        'origin':'http:localhost',
        'Content-Type':'application/json'
      },
      body: jsonEncode({
        'service_id':Service_id,
        'user_id':User_id,
        'template_id':Template_id,
        'template_params':{
          'name':name,
          'receiver_email':receiver_email,
          'OTP':OTP

        }
      })
  ).onError((error, stackTrace) => jd());

}


jd(){
  EasyLoading.showError('Error sending email ');
}



void Customize_Easyloading(){
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.white
    ..backgroundColor =  Colors.green.shade700
    ..indicatorColor = Colors.white
    ..textColor = Colors.white
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = true;

}

Future<bool> onClick(context)async{
  return (await showDialog(context: context, builder:(context)=>AlertDialog(
    title: Text('Are you sure?'),
    content:  Text('Do you want to exit this page'),
    actions: [
      ElevatedButton(
        onPressed: () => Navigator.of(context).pop(true),
        child: Text('Yes'),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700),
      ),
      ElevatedButton(
        onPressed: () => Navigator.of(context).pop(false),
        child:  Text('No'),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700),
      ),
    ],
  ))) ?? false;
}





String getUniqueProductID() {
  var uuid = Uuid();
  var random = Random();
  String uniqueID = uuid.v4();
  int randomInt = random.nextInt(100000);
  return "PRODUCT-$uniqueID-$randomInt";
}