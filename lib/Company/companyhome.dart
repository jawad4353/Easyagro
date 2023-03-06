



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyagro/Company/companylogin.dart';
import 'package:easyagro/splash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Farmer/farmerlogin.dart';
import '../sharedpref_validations.dart';

class companyhome extends StatefulWidget{
  @override
  State<companyhome> createState() => _companyhomeState();
}

class _companyhomeState extends State<companyhome> {
  var user_data=[],sections_list=['Products','Dealers','Orders','Add new','Delivered','Policies'],
      images_list=['images/products.png','images/dealer.png','images/orders.png','images/add.png','images/delivery.png','images/policy.png'];
   var index_curent=0;
  @override
  void initState() {
    super.initState();
    Get_current_company_details();
  }

  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
   return Scaffold(
     backgroundColor: Colors.white,
     appBar: AppBar(title:user_data.isEmpty ? Text(''): Text('${user_data[0]}'.toUpperCase()),centerTitle: true,iconTheme: IconThemeData(color: Colors.white,
     size: 27),
         elevation: 0,
         backgroundColor: Colors.green.shade700,actions: [
       IconButton(onPressed:(){
         Clear_Preferences();
         EasyLoading.showSuccess('Logout');
         Navigator.pushReplacement(context, Myroute(companylogin()));
       }, icon: Icon(Icons.logout,color: Colors.white,)),
         IconButton(onPressed: (){}, icon: Icon(Icons.notifications))
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
                   color: Colors.green.shade700
               ),accountName: user_data.isEmpty ? Text(''):Text('${user_data[0]}'.toUpperCase()), accountEmail:user_data.isEmpty ? Text(''):Text('${user_data[1]}'),
                 currentAccountPicture: Icon(Icons.face,color: Colors.white,size: 65,),
               ),


               Row(children: [
                 Text('  Night Mode',style: TextStyle(color: Colors.black,fontSize: 16)),
                 Switch.adaptive(value: false, onChanged: (a){})
               ],),


               Row(children: [
                 TextButton.icon(style: ButtonStyle(
                     overlayColor: MaterialStateProperty.resolveWith((states) => Colors.transparent)
                 ),onPressed: (){

                 },icon: Icon(Icons.supervised_user_circle,color: Colors.green.shade700,),label: Text('About Us',style: TextStyle(color: Colors.black,fontSize: 16),),),

               ],),

               Row(children: [
                 TextButton.icon(style: ButtonStyle(
                     overlayColor: MaterialStateProperty.resolveWith((states) => Colors.transparent)
                 ),onPressed: (){

                 },icon: Icon(Icons.contact_page,color: Colors.green.shade700,),label: Text('Contact Us',style: TextStyle(color: Colors.black,fontSize: 16),),),

               ],),


               Row(children: [
                 TextButton.icon(style: ButtonStyle(
                     overlayColor: MaterialStateProperty.resolveWith((states) => Colors.transparent)
                 ),onPressed: (){
                   Clear_Preferences();
                   EasyLoading.showSuccess('Logout');
                   Navigator.pushReplacement(context, Myroute(companylogin()));
                 },icon: Icon(Icons.logout,color: Colors.green.shade700,),label: Text('Logout',style: TextStyle(color: Colors.black,fontSize: 16),),),

               ],),



             ],
           ),
         ),
     ),

     bottomNavigationBar: BottomNavigationBar(
       backgroundColor: Colors.white,
       currentIndex: index_curent,
       onTap: (a){
         setState(() {
           index_curent=a;
         });
       },
       selectedItemColor: Colors.green.shade700,
       items: [
         BottomNavigationBarItem(icon:Icon(Icons.home) ,label: 'Home'),
         BottomNavigationBarItem(icon:Icon(Icons.supervised_user_circle),label: 'Account' ),
         BottomNavigationBarItem(icon:Icon(Icons.sms),label: 'Chat' ),
       ],
     ),


     body:ListView(
       children: [
         Container(height: size.height*0.11,
         child: Column(
         crossAxisAlignment: CrossAxisAlignment.center,
           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
           children: [
           Container(
            width: size.width*0.8,
            child: TextField(
             cursorColor:Colors.green.shade700 ,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: ' Search Dealer',
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.white)
                ),
              ),
            ),
          )
         ],),
         decoration: BoxDecoration(
             color: Colors.green.shade700,
           borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20) ),

         ),),
        Text('\n'),
       Container(
         height: size.height*0.62,

         child: GridView.count(
           crossAxisCount: 3,
           padding: EdgeInsets.all(16),
           childAspectRatio: 1,
           crossAxisSpacing: 10.0,
           mainAxisSpacing: 10,
           children: List.generate(
             sections_list.length,
                 (index) {
               return InkWell(
                 borderRadius: BorderRadius.circular(20),
                 onTap: (){
                   print(sections_list[index]);
                 },
                 child: Container(
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(20),
                     boxShadow: [
                       BoxShadow(
                         color: Colors.grey.withOpacity(0.1),
                         spreadRadius: 1.0,
                         blurRadius: 1.0,
                         offset: Offset(0, 3), // changes position of shadow
                       ),
                     ],
                   ),
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Image.asset(images_list[index], width: 50, height: 50),
                       SizedBox(height: 8),
                       Text(sections_list[index]),
                     ],
                   ),
                 ),
               );
             },
           ),
         ),
       ),



       ]),
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