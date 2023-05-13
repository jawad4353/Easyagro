

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyagro/Company/rud_products.dart';
import 'package:easyagro/Farmer/farmerhome.dart';
import 'package:easyagro/splash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../supportingwidgets.dart';

class displaychats_company extends StatefulWidget{
  @override
  State<displaychats_company> createState() => _displaychats_companyState();
}

class _displaychats_companyState extends State<displaychats_company> {
  var license;
 @override
  void initState() {
   super.initState();
   Load_license();
  }

  @override
  Widget build(BuildContext context) {
   var size=MediaQuery.of(context).size;
   return Scaffold(
     backgroundColor: Colors.white,
     appBar: AppBar(title: Text('Chats'),centerTitle: true,),
     body: StreamBuilder(
       stream:   FirebaseFirestore.instance.collection('chats').where('companylicense', isEqualTo: '$license').snapshots(),
       builder: (BuildContext context,snapshot)
       {
         if (!snapshot.hasData) {
           return show_progress_indicator();
         }
 var data=snapshot.data!.docs;

  return ListView.builder(
    itemCount: data.length,
     itemBuilder: (context,index)  {
       var message,Chater;
       return FutureBuilder(
           future:FirebaseFirestore.instance.collection('dealer').where('license',isEqualTo:data[index]['dealerlicense']).get() ,
         builder: (context,snap) {
           if (!snapshot.hasData) {
             return show_progress_indicator();
           }
           if (snapshot.connectionState==ConnectionState.waiting) {
             return show_progress_indicator();
           }

           try{

              Chater=snap.data!.docs.first.data();
           }
           catch(e){}


           return snap.data==null ? show_progress_indicator():
           Row(
             children: [
               InkWell(
                 onTap: (){
                  if(Chater['profileimage']!=null){
                    Navigator.push(context, Myroute(View_image(imageurl:Chater['profileimage'] ,)));
                  }
                   },
                 child: Container(
                   width: 70,
                     height: 100,
                     clipBehavior: Clip.antiAlias,
                     decoration: BoxDecoration(
                         shape: BoxShape.circle,
                         border: Border.all(color: Colors.black26,width: 2)
                     ),
                     child: Image.network('${Chater['profileimage']}')),
               ),
               Container(
                 width:size.width*0.6 ,
                 child: ListTile(
                 title: Text('${Chater['name']}',),
                 subtitle: Text('${message}'),


             ),
               ),]
           );
         }
       );
     },
  );



       },
     ),
   );
  }

  Load_license() async {
    SharedPreferences pref =await SharedPreferences.getInstance();
    var l=await pref.getString("email");
    var s=await pref.getString("usertype");
    setState(() {
      license=l;
    });
  }

  Get_Message(docid) async {
   var message;
    try{
      var ss=await  FirebaseFirestore.instance.collection('chats').doc(docid).collection('messages').limit(1).get();
      if(ss.docs.first['image']=='noimage'){
        message=ss.docs.first['message'];
      }
      else{
        message='Image';
      }
    }
    catch(e){}
    return message;
}

}