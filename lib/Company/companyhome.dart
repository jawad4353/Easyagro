


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyagro/Company/companylogin.dart';
import 'package:easyagro/splash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Farmer/farmerlogin.dart';
import '../sharedpref_validations.dart';

class companyhome extends StatefulWidget{
  @override
  State<companyhome> createState() => _companyhomeState();
}

class _companyhomeState extends State<companyhome> {
  var user_data=[];

  @override
  void initState() {
    super.initState();
    Get_current_company_details();
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(title: Text('Company Home'),backgroundColor: Colors.green.shade900,actions: [
       IconButton(onPressed:(){
         Clear_Preferences();
         EasyLoading.showSuccess('Logout');
         Navigator.pushReplacement(context, Myroute(companylogin()));
       }, icon: Icon(Icons.logout,color: Colors.white,))
     ],),
     drawer: Drawer(
       backgroundColor: Colors.transparent,
       child: Container(
         clipBehavior: Clip.antiAlias,
         decoration: BoxDecoration(
           color: Colors.white,
           borderRadius: BorderRadius.only(topRight: Radius.elliptical(120, 800),bottomRight:Radius.elliptical(120, 800), ),
         ),
         child: ListView(
           children: [
             UserAccountsDrawerHeader(decoration: BoxDecoration(
                 color: Colors.green.shade900
             ),accountName: user_data.isEmpty ? Text(''):Text('${user_data[0]}'), accountEmail:user_data.isEmpty ? Text(''):Text('${user_data[1]}'),
               currentAccountPicture: Icon(Icons.face,color: Colors.white,size: 65,),
             ),

             Row(children: [
               TextButton.icon(style: ButtonStyle(
                   overlayColor: MaterialStateProperty.resolveWith((states) => Colors.transparent)
               ),onPressed: (){
                 Clear_Preferences();
                 EasyLoading.showSuccess('Logout');
                 Navigator.pushReplacement(context, Myroute(companylogin()));
               },icon: Icon(Icons.logout,color: Colors.green.shade900,),label: Text('Logout',style: TextStyle(color: Colors.black,fontSize: 17),),),

             ],)

           ],
         ),
       ),

     ),
   );
  }

  Get_current_company_details() async {
    var license;
    SharedPreferences pref =await SharedPreferences.getInstance();
    license=await pref.getString("email");

    await FirebaseFirestore.instance.collection("company").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        if(result.data()['license']==license){
          setState(() {
            user_data.add(result.data()['name']);
            user_data.add(result.data()['email']);
            user_data.add(result.data()['password']);
            user_data.add(result.data()['phone']);
            user_data.add(result.data()['license']);
            user_data.add(result.data()['address']);
          });
        }

      });
    });

  }
}