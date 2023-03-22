


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

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
      appBar: AppBar(backgroundColor: Colors.green.shade700,title: Text('${widget.name}'),centerTitle: true,),
      body:StreamBuilder(
        stream: FirebaseFirestore.instance.collection('chats').doc(widget.companylicense+widget.dealerlicense).
        collection('messages').snapshots(),

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

          return ListView.builder(
            itemCount: s.length,
            itemBuilder: (context,index)=> ListTile(
              title: s[index]['sender']=='company' ?  Container(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: EdgeInsets.only(left: 20,right: 20),
                  decoration: BoxDecoration(
                      color: Colors.green.shade200,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.green.shade200)

                  ),
                  child:  Wrap(

                    children: [
                      Text(s[index]['message'],style: TextStyle(fontSize: 21),),
                      Text('  '),
                      Text('${s[index]['date']}'.substring(11,16)),
                    ],
                  ),
                ),
              ):null,
              subtitle:s[index]['sender']=='dealer' ?  Container(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: EdgeInsets.only(left: 20,right: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black26)
                  ),
                  child: Wrap(

                    children: [
                      Text(s[index]['message'],style: TextStyle(fontSize: 21,color: Colors.black),),
                      Text('  '),
                      Text('${s[index]['date']}'.substring(11,16),style: TextStyle(color: Colors.black),),
                    ],
                  ),
                ),
              ):null ,
            ),
          );
        },
      ),




      bottomSheet: Container(
        width: size.width,
        padding: EdgeInsets.only(bottom: 5,right: 4,left: 4),
        child: TextField(
          cursorColor: Colors.green.shade700,
          style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),
          keyboardType: TextInputType.visiblePassword,
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
                  IconButton(icon:Icon( Icons.image,color: Colors.green.shade700,),onPressed: (){},),
                  IconButton(icon:Icon( Icons.send,color: Colors.green.shade700,),onPressed: (){
                    Send_message(message_controller.text,widget.companylicense,widget.dealerlicense,'dealer');
                  },)
                ],)
          ),
        ),
      ),

    );
  }

  Send_message(message,companylicense,dealerlicense,sender){
    var sms=FirebaseFirestore.instance.collection('chats').doc(companylicense+dealerlicense);
    sms.set({'companylicense':"${companylicense}",'dealerlicense':'${dealerlicense}'});
    sms.collection('messages').add({'message':'${message}','date':'${DateTime.now()}','sender':'$sender'});


  }
}