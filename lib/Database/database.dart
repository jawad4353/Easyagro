




import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';



class database {


  Future<bool> Register_Farmer(email,password,name) async {
    try{
      var s= FirebaseFirestore.instance.collection('farmers').doc(email);
      s.set({'email':"${email}",'password':'${password}','name':'${name}','image':''});
      EasyLoading.showSuccess('Account created Sucessfully  ');
      return true;
    }
    catch(e){
      EasyLoading.showError('! Account has not been created.');
      return false;
    }
  }

  Login_Farmer(Email,Password) async {
    var s=false;
    await FirebaseFirestore.instance.collection("farmers").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {

        if(result.data()['email']==Email && result.data()['password']==Password ){
          s=true;

        }
      });
    });
    return await s;


  }






  Future<bool> Register_company(name,license_no,address,email,phone,password,profile_url,license_url) async {
    try{

      FirebaseFirestore.instance.collection('company').add({'email':"${email}",'password':'${password}','name':'${name}',
        'license':'${license_no}', 'address':'${address}','phone':'${phone}',
        'profileimage':"${profile_url}",
        'licenseimage':'${license_url}','accountstatus':'unverified'
      });
      EasyLoading.showSuccess('Account created Sucessfully  ');
      return true;
    }
    catch(e){
      var s=e.toString().split(']');
      EasyLoading.showError('! Account has not been created.'
          '${s[1]}');
      return false;
    }
  }


  Future<bool> Register_dealer(name,license_no,address,email,phone,password,profile_url,license_url) async {
    try{

      FirebaseFirestore.instance.collection('dealer').add({'email':"${email}",'password':'${password}','name':'${name}',
        'license':'${license_no}', 'address':'${address}','phone':'${phone}','profileimage':"${profile_url}",
      'licenseimage':'${license_url}','accountstatus':'unverified'
      });
      EasyLoading.showSuccess('Account created Sucessfully  ');
      return true;
    }
    catch(e){
      var s=e.toString().split(']');
      EasyLoading.showError('! Account has not been created.'
          '${s[1]}');
      return false;
    }
  }



  Future<bool> Duplicate_license(license,collection_name) async {
    var s=false;
   await FirebaseFirestore.instance.collection("${collection_name}").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        if(result.data()['license']==license){
          s=true;

        }

      });
    });
    return s;
  }

  Login_company(license,password) async {
    var s=false;
    await FirebaseFirestore.instance.collection("company").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        if(result.data()['license']==license && result.data()['password']==password ){
          s=true;
        }
      });
    });
    return s;
  }

  Login_dealer(license,password) async {
    var s=false;
    await FirebaseFirestore.instance.collection("dealer").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        if(result.data()['license']==license && result.data()['password']==password ){
          s=true;
        }
      });
    });
    return s;
  }

Future<bool> Duplicate_email(email,collection_name) async {
  var s=false;
  await FirebaseFirestore.instance.collection("${collection_name}").get().then((querySnapshot) {
    querySnapshot.docs.forEach((result) {
      if(result.data()['email']==email){
        s=true;
      }

    });
  });
  return s;
}



  Future<bool> Duplicate_email_updation(email,collection_name,license) async {
    var s=false;
    await FirebaseFirestore.instance.collection("${collection_name}").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        if(result.data()['email']==email ){
          s=true;
          if(license==result.data()['license']){
            s=false;
          }

        }

      });
    });
    return s;
  }








Future<bool> Duplicate_phone(phone,collection_name) async {
  var s=false;
  await FirebaseFirestore.instance.collection("${collection_name}").get().then((querySnapshot) {
    querySnapshot.docs.forEach((result) {
      if(result.data()['phone']==phone){
        s=true;
      }

    });
  });
  return s;
}

Update_password(newpass,email,collection_name) async {
  await FirebaseFirestore.instance.collection("${collection_name}").get().
  then((querySnapshot) {
  querySnapshot.docs.forEach((result) {
  if(result.data()['email']==email){
  FirebaseFirestore.instance.collection("${collection_name}").doc(result.id).update({'password':'${newpass}'});
  }

  });
  });
}






  Future<String> GetImage_Firebase(foldername,imageName) async {
    var imagePath;
    final storage = FirebaseStorage.instance;
    try {
      final ref =await storage.ref().child('$foldername/$imageName');
      imagePath = await ref.getDownloadURL();
    } catch (e) {
      print('Error fetching image path: $e');
    }
    print(imagePath);
    return imagePath;
  }




  Future<void> updateImageName(String oldImageName, String newImageName) async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    final  oldRef = storage.ref().child('${oldImageName}');
    final newRef = storage.ref().child('${newImageName}');
    final Directory systemTempDir = Directory.systemTemp;
    final File tempFile = File('${systemTempDir.path}/temp.jpg');
    if (tempFile.existsSync()) {
      await tempFile.delete();
    }
    await oldRef.writeToFile(tempFile);
    await newRef.putFile(tempFile).whenComplete(() => tempFile.delete());
    await oldRef.delete();
  }



}