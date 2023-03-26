import 'package:easyagro/splash.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../supportingwidgets.dart';
import 'Chatdealer.dart';

class OrdersScreen extends StatefulWidget{
  var dealerlicense;
  OrdersScreen({required this.dealerlicense});
  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {



  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(backgroundColor: Colors.green.shade700,title: Text('Orders'),),
     body: Container(
       height: MediaQuery.of(context).size.height,
       child: StreamBuilder<QuerySnapshot>(
         stream: FirebaseFirestore.instance.collection('orders').where('dealerlicense' ,isEqualTo:widget.dealerlicense)
            .snapshots(),
         builder: (context, snapshot) {
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


           return snapshot.data!.docs.isEmpty ? Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Text('No Previous Orders')
           ],) : ListView.builder(
             itemCount:snapshot.data!.docs.length,
            itemBuilder: (context,index) =>
              Container(
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color:Colors.grey ))
                ),
                child: ListTile(
                  splashColor: Colors.green.shade700,
                  onTap: () async {

                    final CollectionReference companyCollection = FirebaseFirestore.instance.collection('company');
                    final QuerySnapshot querySnapshot = await companyCollection.where('license', isEqualTo:snapshot.data!.docs[index]['companylicense'] ).get();
                    final List<QueryDocumentSnapshot> documents = querySnapshot.docs;

                    Navigator.push(context, Myroute(View_details(id: '${snapshot.data!.docs[index].id}',date: snapshot.data!.docs[index]['date'],status:snapshot.data!.docs[index]['status'] ,total:snapshot.data!.docs[index]['total'],
                      companylicense: snapshot.data!.docs[index]['companylicense'],dealerlicense: snapshot.data!.docs[index]['dealerlicense'],
                      name: '${documents[0]['name']}',
                    )));
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
  var id,total,date,status,companylicense,dealerlicense,name;
  View_details({required this.id,required this.date,required this.status,required this.total,
  required this.companylicense,required this.dealerlicense,required this.name}
  );
  @override
  State<View_details> createState() => _View_detailsState();
}

class _View_detailsState extends State<View_details> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Order details'),backgroundColor: Colors.green.shade700,actions: [
        Center(child: Text('Total bill : ${widget.total} R.s',style: TextStyle(fontSize: 16))),
        IconButton(onPressed: (){
          Navigator.push(context, Myroute(Chatdealer(companylicense: widget.companylicense,dealerlicense: widget.dealerlicense,
          name: widget.name,
          )));
        }, icon: Icon(Icons.chat))
      ],),
      body:StreamBuilder(
        stream: FirebaseFirestore.instance.collection('orders').doc(widget.id).collection('orderitem').snapshots(),
        builder: (context, snapshot) {
          widget.date='${widget.date}'.substring(0,19);
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return show_progress_indicator();
          }

      var s=snapshot.data!.docs;
          return Container(
            height: MediaQuery.of(context).size.height,
            child:  Column(
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











