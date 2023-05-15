



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Company/chatscreen.dart';
import '../Company/rud_products.dart';
import '../splash.dart';
import '../supportingwidgets.dart';
import 'Chatdealer.dart';

class displaychats_dealer extends StatefulWidget {
  @override
  State<displaychats_dealer> createState() => _displaychats_dealerState();
}

class _displaychats_dealerState extends State<displaychats_dealer> {
  var license,Last_sms=[];

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
      appBar: AppBar(title: Text('Previous Chats'),centerTitle: true,),
      body: StreamBuilder(
        stream:   FirebaseFirestore.instance.collection('chats').where('dealerlicense', isEqualTo: '$license').snapshots(),
        builder: (BuildContext context,snapshot)
        {
          if (!snapshot.hasData) {
            return show_progress_indicator();
          }
          var data=snapshot.data!.docs;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context,index)  {
              var Chater;
              Get_Message(data[index].id);
              return FutureBuilder(
                  future:FirebaseFirestore.instance.collection('company').where('license',isEqualTo:data[index]['companylicense']).get() ,
                  builder: (context,snap) {
                    if (!snap.hasData) {
                      return show_progress_indicator();
                    }
                    if (snap.connectionState==ConnectionState.waiting) {
                      return show_progress_indicator();
                    }


                    print(Last_sms);
                    try{
                      Chater=snap.data!.docs.first.data();
                    }
                    catch(e){}



                    return snap.data==null ? show_progress_indicator():
                    Container(
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.black26))
                      ),
                      child: Row(
                          children: [
                            InkWell(

                              overlayColor: MaterialStateProperty.resolveWith((states) => Colors.transparent),
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
                                  child:Chater==null ? Text(''): Image.network('${Chater['profileimage']}')),
                            ),
                            InkWell(
                              onTap: (){
                                Navigator.push(context, Myroute(Chatdealer(companylicense: data[index]['companylicense'],dealerlicense:license ,name: Chater['name'],)));

                              },
                              child: Container(
                                width:size.width*0.75,
                                child: ListTile(
                                  title: Chater==null ? Text('') :Text('${Chater['name']}',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 17),),
                                  subtitle: Text(''),


                                ),
                              ),
                            ),]
                      ),
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

  Future<String>Get_Message(docid) async {
    var message;
    try{
      var ss=await  FirebaseFirestore.instance.collection('chats').doc(docid).collection('messages').limit(1).get();
      if(ss.docs.first['image']=='noimage'){
        message=ss.docs.first['message'];
     Last_sms.add(message);
      }
      else{
        message='Image';
      }
    }
    catch(e){
      EasyLoading.showInfo('$e');
    }
    return message;
  }
}