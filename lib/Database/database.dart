




import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';



class database {


  Future<bool> Register_Farmer(email,password,name) async {

    try{
      final _auth =await FirebaseAuth.instance.createUserWithEmailAndPassword
        (email: email, password: password);
      FirebaseFirestore.instance.collection('farmers').add({'email':"${email}",'password':'${password}','name':'${name}'});
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

  Login_Farmer(Email,Password) async {

    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: Email,
          password: Password
      );
      EasyLoading.showSuccess('Sucessfully Login ');
      return true;
    }

    catch(e){
      EasyLoading.showError('Incorrect credentials \n Email: ${Email} \nPassword: ${Password}');
      return false;
    }

  }






  Future<bool> Register_company(name,license_no,address,email,phone,password) async {
    try{

      FirebaseFirestore.instance.collection('company').add({'email':"${email}",'password':'${password}','name':'${name}',
        'license':'${license_no}', 'address':'${address}','phone':'${phone}'
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


  Future<bool> Register_dealer(name,license_no,address,email,phone,password) async {
    try{

      FirebaseFirestore.instance.collection('dealer').add({'email':"${email}",'password':'${password}','name':'${name}',
        'license':'${license_no}', 'address':'${address}','phone':'${phone}'
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
  await FirebaseFirestore.instance.collection("${collection_name}").get().then((querySnapshot) {
  querySnapshot.docs.forEach((result) {
  if(result.data()['email']==email){
  FirebaseFirestore.instance.collection("${collection_name}").doc(result.id).update({'password':'${newpass}'});
  }

  });
  });
}
}