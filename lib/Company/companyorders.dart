


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../splash.dart';
import '../supportingwidgets.dart';

class companyorders extends StatefulWidget{
  var companylicense;
  companyorders({required this.companylicense});

  @override
  State<companyorders> createState() => _companyordersState();
}

class _companyordersState extends State<companyorders> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.green.shade700,title: Text('Orders'),),
      body: Container(
          height: MediaQuery.of(context).size.height,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('orders').where('companylicense',isEqualTo:widget.companylicense ).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return show_progress_indicator();
              }


              //     print(s);
              return snapshot.data!.docs.isEmpty ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('No Active Orders')
                ],) : ListView.builder(
                itemCount:snapshot.data!.docs.length,
                itemBuilder: (context,index) =>
                    Container(
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color:Colors.grey ))
                      ),
                      child: ListTile(
                        splashColor: Colors.green.shade700,
                        onTap: (){
                          Navigator.push(context, Myroute(View_details(id: '${snapshot.data!.docs[index].id}',date: snapshot.data!.docs[index]['date'],status:snapshot.data!.docs[index]['status'] ,total:snapshot.data!.docs[index]['total'])));
                        },
                        title: Text('${snapshot.data!.docs[index]['date']}'.substring(0,19)),
                        subtitle: Text('Total : ${snapshot.data!.docs[index]['total']}'),
                        trailing: Text('${snapshot.data!.docs[index]['status']}'),
                      ),
                    ),
              );
            },
          )


      ),
    );
  }
}








class View_details extends StatefulWidget{
  var id,total,date,status;
  View_details({required this.id,required this.date,required this.status,required this.total});
  @override
  State<View_details> createState() => _View_detailsState();
}

class _View_detailsState extends State<View_details> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Order details'),backgroundColor: Colors.green.shade700,actions: [
          Center(child: Text('Total bill : ${widget.total} R.s',style: TextStyle(fontSize: 16))),
        ],),
        body:StreamBuilder(
          stream: FirebaseFirestore.instance.collection('orders').doc(widget.id).collection('orderitem').snapshots(),
          builder: (context, snapshot) {
            widget.date='${widget.date}'.substring(0,19);
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
            return Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Container(
                    height:MediaQuery.of(context).size.height*0.77 ,
                    child: ListView.builder(
                      itemCount:s.length,
                      itemBuilder: (context,index) =>
                          Container(
                            decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(color:Colors.grey ))
                            ),
                            child: ListTile(
                              leading: Image.network('${s[index]['productimage']}',fit: BoxFit.fill,),
                              isThreeLine: true,
                              trailing:Text('Price : ${s[index]['productprice']}') ,
                              title: Text('${s[index]['productname']}',style: TextStyle(fontSize: 17),),
                              subtitle:Text('${s[index]['quantity']}\nQuantity : ${s[index]['productquantity']}\nTotal : ${int.parse(s[index]['productquantity'])*int.parse(s[index]['productprice'])} R.s',style: TextStyle(fontSize: 15)) ,

                            ),
                          ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('  Status : ${widget.status}',style: TextStyle(fontSize: 16),),
                      Text('  Order Date : ${widget.date}',style: TextStyle(fontSize: 16)),

                    ],)
                ],
              ),
            );
          },
        )
    );
  }
}




