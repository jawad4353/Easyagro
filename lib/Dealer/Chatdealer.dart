


import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyagro/splash.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../Company/Notifiers.dart';
import '../Company/rud_products.dart';

class Chatdealer extends StatefulWidget{
  var companylicense,dealerlicense,name;
  Chatdealer({required this.companylicense,required this.dealerlicense,required this.name});
  @override
  State<Chatdealer> createState() => _ChatdealerState();
}



class _ChatdealerState extends State<Chatdealer> {
  TextEditingController message_controller=new TextEditingController();



  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.green.shade700,title: Text('${widget.name}'),centerTitle: true,
      actions: [
        IconButton(onPressed: (){}, icon: Icon(Icons.clear))
      ],
      ),
      body:StreamBuilder(
        stream: FirebaseFirestore.instance.collection('chats').doc(widget.companylicense+widget.dealerlicense).
        collection('messages').orderBy('date',descending: false).snapshots(),

        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Container(
                color: Colors.white,
                child: SpinKitFoldingCube(
                  size: 50.0,
                  duration: Duration(milliseconds: 700),
                  itemBuilder: ((context, index) {
                    var Mycolors=[Colors.green.shade700,Colors.white];
                    var Mycol=Mycolors[index%Mycolors.length];
                    return DecoratedBox(decoration: BoxDecoration(
                        color: Mycol,
                        border: Border.all(color: Colors.green,)


                    ));
                  }),
                ),
              ),

            );
          }

          var s=snapshot.data!.docs;


          return Padding(
            padding: const EdgeInsets.only(bottom: 58.0),
            child:  ListView.builder(
                itemCount: s.length,
                  controller: ScrollController(initialScrollOffset:5000,keepScrollOffset: true ),
                itemBuilder: (context,index)
                {

                  return  ListTile(

                  title: s[index]['sender']=='company'?  Container(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black26)
                      ),

                      child: s[index]['message']=='' ? Stack(
                        children: [
                          InkWell(
                            onTap: (){
                              Navigator.push(context,Myroute(View_imagewide(imageurl:s[index]['image'] ,)));
                            },
                            child: Container(
                                height: 300,
                                width: 230,
                                color: Colors.white,

                                child: Image.network(s[index]['image'],fit: BoxFit.fill,)),
                          ),
                          Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5)
                                  ),
                                  child: Text('${s[index]['date']}'.substring(11,16),style: TextStyle(color: Colors.black),))),
                        ],
                      ): Padding(
                            padding: const EdgeInsets.only(left: 20,right: 20),
                            child: RichText(text: TextSpan(
                                text: '${s[index]['message']}',
                                style: TextStyle(color: Colors.black,fontSize: 22),
                                children: [
                                  TextSpan(text: ' '),
                                  TextSpan(text: '${s[index]['date']}'.substring(11,16),
                                    style: TextStyle(color: Colors.black,fontSize: 13),
                                  ),
                                ]
                            ),),
                      ),
                    ),
                  ): Container(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: EdgeInsets.only(left: 0,right: 0),
                      decoration: BoxDecoration(
                          color: Colors.green.shade300,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black26)
                      ),
                      child:
                      s[index]['message']=='' ? Stack(
                            children: [
                              InkWell(
                                onTap: (){
                                  Navigator.push(context,Myroute(View_imagewide(imageurl:s[index]['image'] ,)));
                                },
                                child: Container(
                                    height: 300,
                                    width: 230,
                                    color: Colors.white,

                                    child: Image.network(s[index]['image'],fit: BoxFit.fill,)),
                              ),
                              Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(5)
                                      ),
                                      child: Text('${s[index]['date']}'.substring(11,16),style: TextStyle(color: Colors.black),))),
                            ],
                          ): Padding(
                            padding: const EdgeInsets.only(left: 20,right: 20),
                            child: RichText(text: TextSpan(
                                text: '${s[index]['message']}',
                                style: TextStyle(color: Colors.black,fontSize: 22),
                                children: [
                                  TextSpan(text: ' '),
                                  TextSpan(text: '${s[index]['date']}'.substring(11,16),
                                    style: TextStyle(color: Colors.black,fontSize: 13),
                                  ),
                                ]
                            ),),
                          ),



                    ),
                  ),

                );}

            ),
          );
        },
      ),




      bottomSheet: Container(
        width: size.width,
        padding: EdgeInsets.only(bottom: 5,right: 4,left: 4),
        child: TextField(
          cursorColor: Colors.green.shade700,
          onChanged: (a){
            Provider.of<ButtonColorProvider >(context, listen: false).updateButtonColor(a) ;
          },
          onSubmitted: (a){
            if(message_controller.text.isEmpty){
              return;
            }
            Send_message(message_controller.text,widget.companylicense,widget.dealerlicense,'dealer');
            message_controller.text='';
          },
          style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),
          controller: message_controller,
          decoration: InputDecoration(
              hintText: ' Enter message',
              filled: true,
              fillColor: Colors.white,
              hintStyle: TextStyle(fontWeight: FontWeight.normal),
              contentPadding: EdgeInsets.only(left: 10),
              border:OutlineInputBorder(borderRadius: BorderRadius.circular(20)) ,
              focusedBorder:OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Colors.green.shade700)) ,
              suffixIcon:Wrap(

                children: [
                  IconButton(icon:Icon( Icons.image,color: Colors.green.shade700,),onPressed: () async {
                    final picker = ImagePicker();
                    final pickedFile = await picker.getImage(source: ImageSource.gallery);

                    try{
                      if (pickedFile != null) {
                        // Upload image to Firebase Storage
                        final file = File(pickedFile.path);
                        final fileName = pickedFile.path.split('/').last;
                        final storageRef = FirebaseStorage.instance.ref().child('chats_images/${widget.companylicense+widget.dealerlicense}/${fileName}');
                        final uploadTask = storageRef.putFile(file);
                        await uploadTask.whenComplete(() async {
                          final downloadUrl = await storageRef.getDownloadURL();
                          var sms=FirebaseFirestore.instance.collection('chats').doc(widget.companylicense+widget.dealerlicense);
                          sms.set({'companylicense':"${widget.companylicense}",'dealerlicense':'${widget.dealerlicense}'});
                          sms.collection('messages').add({'message':'','date':'${DateTime.now()}','sender':'dealer','image':'$downloadUrl'});

                        });
                      }
                    }
                    catch(e){
                      EasyLoading.showError('Error sending image');
                      return;
                    }

                  },),



                  Consumer<ButtonColorProvider>(
                    builder: (context,butoncolor,i)=> IconButton(icon:Icon( Icons.send,color: butoncolor.buttonColor,),onPressed: (){
                      if(message_controller.text.isEmpty){
                        return;
                      }
                      Send_message(message_controller.text,widget.companylicense,widget.dealerlicense,'dealer');
                      message_controller.text='';
                    },),
                  )
                ],)
          ),
        ),
      ),

    );
  }

  Send_message(message,companylicense,dealerlicense,sender){
    var sms=FirebaseFirestore.instance.collection('chats').doc(companylicense+dealerlicense);
    sms.set({'companylicense':"${companylicense}",'dealerlicense':'${dealerlicense}'});
    sms.collection('messages').add({'message':'${message}','date':'${DateTime.now()}','sender':'$sender','image':'noimage'});


  }
}

