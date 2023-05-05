




import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';




class database {


  Future<bool> Register_Farmer(email,password,name) async {
    try{
      var s= FirebaseFirestore.instance.collection('farmers').doc(email);
      s.set({'email':"${email}",'password':'${password}','name':'${name}','image':'','date':'${DateTime.now()}'});
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
        'licenseimage':'${license_url}','accountstatus':'unverified','date':'${DateTime.now()}'
      });
      EasyLoading.showSuccess('We have recieved your request . We will review it and will let you know via Email within 3 days . ');
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
      'licenseimage':'${license_url}','accountstatus':'unverified','date':'${DateTime.now()}'
      });
      EasyLoading.showSuccess('We have recieved your request . We will review it and will let you know via Email within 3 days . ');
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
    await FirebaseFirestore.instance.collection("company").where('accountstatus',isEqualTo: 'verified').get().then((querySnapshot) {
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
    await FirebaseFirestore.instance.collection("dealer").where('accountstatus',isEqualTo: 'verified').get().then((querySnapshot) {
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




class GoogleSignInHelper {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential? userCredential = await _auth.signInWithCredential(credential);
      return userCredential;
    } catch (e) {
      print('Error signing in with Google: $e');
      return null;
    }
  }

  Future<void> signOutGoogle() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}




//
// class TwitterAuth {
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//
//   Future<UserCredential> signInWithTwitter() async {
//     // Initialize the Twitter login
//     final TwitterLogin twitterLogin = TwitterLogin(
//       consumerKey: 'YOUR_CONSUMER_KEY',
//       consumerSecret: 'YOUR_CONSUMER_SECRET',
//     );
//
//     // Perform the Twitter login
//     final TwitterLoginResult result = await twitterLogin.authorize();
//
//     // Check if the Twitter login was successful
//     if (result.status == TwitterLoginStatus.loggedIn) {
//       // Get the Twitter session
//       final TwitterSession twitterSession = result.session;
//
//       // Create a TwitterAuthCredential from the access token and secret
//       final TwitterAuthCredential twitterAuthCredential =
//       TwitterAuthProvider.credential(
//         accessToken: twitterSession.token,
//         secret: twitterSession.secret,
//       );
//
//       // Sign in to Firebase with the Twitter credential
//       final UserCredential userCredential =
//       await _firebaseAuth.signInWithCredential(twitterAuthCredential);
//
//       return userCredential;
//     } else {
//       throw FirebaseAuthException(
//         code: 'ERROR_TWITTER_LOGIN_FAILED',
//         message: 'Twitter login failed',
//       );
//     }
//   }
//
//   Future<void> signOut() async {
//     await _firebaseAuth.signOut();
//   }
// }