import 'package:easyagro/splash.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class OrdersScreen extends StatefulWidget{
  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(backgroundColor: Colors.green.shade700,title: Text('Orders'),),
     body: Container(
       height: 500,
       child: StreamBuilder<QuerySnapshot>(
         stream: FirebaseFirestore.instance.collection('orders').snapshots(),
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

           return ListView.builder(
             itemCount:snapshot.data!.docs.length,
            itemBuilder: (context,index) =>
              Container(
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color:Colors.grey ))
                ),
                child: ListTile(
                  onTap: (){
                    Navigator.push(context, Myroute(View_details(id: '${snapshot.data!.docs[index].id}',)));
                  },
                  title: Text('${snapshot.data!.docs[index]['date']}'),
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
  var id;
  View_details({required this.id});
  @override
  State<View_details> createState() => _View_detailsState();
}

class _View_detailsState extends State<View_details> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Order details'),backgroundColor: Colors.green.shade700,),
      body:StreamBuilder(
        stream: FirebaseFirestore.instance.collection('orders').doc(widget.id).collection('orderitem').snapshots(),
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

      var s=snapshot.data!.docs;
          return ListView.builder(
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
          );
        },
      )
    );
  }
}











