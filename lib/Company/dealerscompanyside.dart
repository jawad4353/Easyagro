



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../Dealer/dealerorders.dart';
import '../splash.dart';
import '../supportingwidgets.dart';
import 'chatscreen.dart';

class Dealerscompanyside extends StatefulWidget{
  var companylicense;
  Dealerscompanyside({required this.companylicense});
  @override
  State<Dealerscompanyside> createState() => _DealerscompanysideState();
}

class _DealerscompanysideState extends State<Dealerscompanyside> {
  TextEditingController search_controller =new TextEditingController();
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
   return Scaffold(
     appBar: AppBar(backgroundColor: Colors.green.shade700,
       title: Container(
         height: 40,
         child: TextField(
           cursorColor: Colors.green.shade700,
         style: TextStyle(fontSize: 19,fontWeight: FontWeight.w600),
         controller: search_controller,
           onChanged: (a){
             setState(() {

             });
           },
           decoration: InputDecoration(
             contentPadding: EdgeInsets.only(left: 5),
             hintText: 'Search name',
             hintStyle: TextStyle(fontWeight: FontWeight.normal),
             fillColor: Colors.white,
             filled: true,
             border: OutlineInputBorder(),
             focusedBorder:OutlineInputBorder(borderSide: BorderSide(color: Colors.white))
           ),
     ),
       ),),
     body: ListView(
       children: [

         Container(
           height: size.height*0.85,

           child: StreamBuilder<QuerySnapshot>(
             stream: FirebaseFirestore.instance.collection('dealer').snapshots(),
             builder: (context, snapshot)  {
               if (snapshot.hasError) {
                 return Center(
                   child: Text('Error: ${snapshot.error}'),
                 );
               }

               if (!snapshot.hasData) {
                 return Center(
                   child:  Container(
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

               List<DocumentSnapshot> filteredcompanies = snapshot.data!.docs.where((doc) {
                 return doc['name'].toLowerCase().startsWith(search_controller.text.toLowerCase());
               }).toList();


               return ListView.builder(
                 itemCount: filteredcompanies.length,
                 itemBuilder: (context, index)  {
                   DocumentSnapshot document = filteredcompanies[index];
                   Map<String, dynamic> companyData = document.data() as Map<String, dynamic>;
                   var addressshort='${companyData['address']}'.length<25 ?companyData['address']:'${companyData['address']}'.substring(0,25)+'..' ;
                   var nameshort='${companyData['name']}'.length<17 ?companyData['name']:'${companyData['name']}'.substring(0,17)+'..' ;
                   return InkWell(
                     splashColor: Colors.white,
                     onTap: (){
                       Navigator.push(context, Myroute(Viewdealer(dealer_license: companyData['license'],companylicense: widget.companylicense,name: nameshort,)));
                     },
                     child: Container(
                       padding: EdgeInsets.all(10),
                       decoration: BoxDecoration(
                           border: Border(bottom: BorderSide(color: Colors.white,width: 2))
                       ),
                       child: Column(
                         children: [
                           Container(
                               height:220,
                               color: Colors.green.shade700,
                               width: size.width,
                               child:  Image.network('${companyData['profileimage']}',fit: BoxFit.fill,)),
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               Text('$nameshort',style: TextStyle(fontFamily: 'jd',fontSize: 18,color: Colors.black,fontWeight: FontWeight.bold),),
                               Text('${companyData['email']}',style: TextStyle(color: Colors.black),),
                             ],),
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               Row(children: [
                                 Icon(Icons.house_siding_sharp,color: Colors.green,),
                                 Text('$addressshort',style: TextStyle(color: Colors.black),),
                               ],),
                               Row(children: [
                                 Icon(Icons.phone,color: Colors.black,),
                                 Text('${companyData['phone']}',style: TextStyle(color: Colors.black),),
                               ],),


                             ],)

                         ],
                       ),
                     ),
                   );
                 },
               );
             },
           ),
         ),

       ],
     ),

   );
  }
}





class Viewdealer extends StatefulWidget{
 var dealer_license,companylicense,name;
 Viewdealer({required this.dealer_license,required this.companylicense,required this.name});
  @override
  State<Viewdealer> createState() => _ViewdealerState();
}

class _ViewdealerState extends State<Viewdealer> {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(backgroundColor: Colors.green.shade700,title: Text('${widget.name}'),

     actions: [
       IconButton(onPressed: (){
         Navigator.push(context, Myroute(ChatScreen(companylicense: widget.companylicense,dealerlicense: widget.dealer_license,name: widget.name,)));
       }, icon: Icon(Icons.chat))
     ],),
     body: StreamBuilder(
       stream: FirebaseFirestore.instance.collection('orders').where('dealerlicense',isEqualTo: widget.dealer_license).where('companylicense',
           isEqualTo: widget.companylicense).snapshots(),
       builder: (context, snapshot) {
         if (snapshot.hasError) {
           return Text('Error: ${snapshot.error}');
         }

         if (snapshot.connectionState == ConnectionState.waiting) {
           return show_progress_indicator();
         }



         return snapshot.data!.docs.isEmpty ? Row(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Center(child: Text('No Active Orders'))
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

                   },
                   title: Text('${snapshot.data!.docs[index]['date']}'.substring(0,19)),
                   subtitle: Text('Total : ${snapshot.data!.docs[index]['total']}'),
                   trailing: Text('${snapshot.data!.docs[index]['status']}'),
                 ),
               ),
         );
       },
     ),
   );
  }
}