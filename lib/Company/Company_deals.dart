

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyagro/Company/rud_products.dart';
import 'package:easyagro/splash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../supportingwidgets.dart';

class Company_deals extends StatefulWidget{
  @override
  State<Company_deals> createState() => _Company_dealsState();
}

class _Company_dealsState extends State<Company_deals> {
  var license;
  @override
  void initState() {
    super.initState();
    Load_company_deals();
  }

  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
   return Scaffold(
     backgroundColor: Colors.white,
     appBar: AppBar(title:Text('Deals'),backgroundColor: Colors.green.shade700,actions: [
       ElevatedButton.icon(style:ElevatedButton.styleFrom(
         backgroundColor: Colors.white
       ),onPressed: (){
         Navigator.push(context, Myroute(Add_deal(license: license,)));
       }, icon: Icon(Icons.add,color: Colors.lightGreen.shade700,),label: Text('Create',style: TextStyle(color: Colors.lightGreen.shade700,fontSize: 17),),)
     ],),
     body: StreamBuilder(
       stream: FirebaseFirestore.instance.collection('deals').where('license',isEqualTo: license).snapshots(),
       builder: (context,snapshot){

         if (!snapshot.hasData) {
           return Text('Error: ${snapshot.error}');
         }

         if (snapshot.connectionState == ConnectionState.waiting) {
           return show_progress_indicator();
         }
         return GridView.count(crossAxisCount: 2);
       },
     ),
   );
  }

  Load_company_deals() async {
    SharedPreferences pref =await SharedPreferences.getInstance();
    var l=await pref.getString("email");
    var s=await pref.getString("usertype");
    setState(() {
      license=l;
    });
  }

}




class Add_deal extends StatefulWidget{
  var license;
  Add_deal({required this.license});
  @override
  State<Add_deal> createState() => _Add_dealState();
}


class _Add_dealState extends State<Add_deal> {

  var search_controller=TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
   return Scaffold(
     appBar: AppBar(title: Text('Select Products'),),
     body:StreamBuilder(
       stream: FirebaseFirestore.instance.collection('products').where('companylicense',isEqualTo: widget.license).snapshots(),
       builder: (context,snapshot){

         if (!snapshot.hasData) {
           return Text('Error: ${snapshot.error}');
         }
         if (snapshot.connectionState == ConnectionState.waiting) {
           return show_progress_indicator();
         }
         List<DocumentSnapshot> filteredProducts = snapshot.data!.docs.where((doc) {
           return doc['productname'].toLowerCase().contains(search_controller.text);
         }).toList();

         return GridView.builder(

           padding: EdgeInsets.all(10),
           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
             crossAxisCount: 2,
             crossAxisSpacing: 10,
             mainAxisSpacing: 5,
             childAspectRatio:size.width / 690,

           ),
           itemCount: filteredProducts.length,
           itemBuilder: (context, index) {
             final product = filteredProducts[index].data() as Map<String, dynamic>;
             final namee= product['productname'] as String;
             final nameeshort= namee.length > 20 ? '${namee.substring(0, 20)}...' : namee;
             final description = product['productdescription'] as String;
             final shortDescription =
             description.length > 50 ? '${description.substring(0, 50)}...' : description;
             // Replace the placeholders with the actual product data
             return   Container(
               clipBehavior: Clip.antiAlias,
               decoration: BoxDecoration(

                   border: Border.all(width: 3,color: Colors.black12)
               ),
               child: InkWell(
                 onTap: () {
                   Navigator.push(context, Myroute(ViewProductPage(product: product,)));
                 },
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.stretch,
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Container(
                       height: 145,
                       child: Image.network(
                         '${product['image']}',
                         fit: BoxFit.fill,
                       ),
                     ),
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       mainAxisAlignment: MainAxisAlignment.spaceAround,
                       children: [
                         Text(
                           '$namee',
                           style: TextStyle(fontWeight: FontWeight.bold),
                         ),
                         Text('$shortDescription'),
                         SizedBox(height: 10),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Text(
                               ' \R.s ${product['productprice']}',
                               style: TextStyle(
                                 fontWeight: FontWeight.bold,
                                 color: Colors.green.shade700,
                               ),
                             ),
                             Text(
                               '(${product['productquantity']})  ',
                               style: TextStyle(fontWeight: FontWeight.bold),
                             ),

                           ],
                         ),
                         Column(
                           mainAxisAlignment: MainAxisAlignment.end,
                           crossAxisAlignment: CrossAxisAlignment.stretch,

                           children: [
                             ElevatedButton(

                               onPressed: () {
                                 Navigator.push(context, Myroute(ViewProductPage(product: product,)));
                               },
                               style: ButtonStyle(
                                   backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.green.shade700)
                               ),
                               child: Text('Select'),
                             ),
                           ],
                         )
                       ],
                     ),

                   ],
                 ),
               ),

             );
           },
         );
       },
     ),
   );
  }
}