



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyagro/Company/companylogin.dart';
import 'package:easyagro/Company/complains.dart';
import 'package:easyagro/Company/products.dart';
import 'package:easyagro/Company/updateaccount.dart';
import 'package:easyagro/Database/database.dart';
import 'package:easyagro/Farmer/diseases.dart';
import 'package:easyagro/splash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Farmer/farmerlogin.dart';
import '../sharedpref_validations.dart';
import 'Company_deals.dart';
import 'addproducts.dart';
import 'companyorders.dart';
import 'dealerscompanyside.dart';
import 'chatscreen.dart';

class companyhome extends StatefulWidget{
  @override
  State<companyhome> createState() => _companyhomeState();
}

class _companyhomeState extends State<companyhome> {
  var user_data=[],sections_list=['Products','Dealers','Orders','Add new','Delivered','Bulk Deals',
    'Revenues','Diseases','Complaints','Logout'],
      images_list=['images/products.png','images/dealer.png','images/orders.png','images/add.png',
        'images/delivery.png','images/policy.png','images/revenue.png','images/disease.png','images/complain.png','images/logout.png'];

   var index_curent=0,searched_section=[],searched_images=[];

   TextEditingController search_controller=new TextEditingController();

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

         IconButton(onPressed: (){}, icon: Icon(Icons.notifications))
     ],),
     drawer: Container(
       clipBehavior: Clip.antiAlias,
       decoration: BoxDecoration(
         color: Colors.white,
         borderRadius: BorderRadius.only(topRight: Radius.elliptical(120, 800),bottomRight:Radius.elliptical(120, 800), ),
       ),
       child: Drawer(
           backgroundColor: Colors.white,

             child: ListView(
               children: [

                 UserAccountsDrawerHeader(decoration: BoxDecoration(
                     color: Colors.green.shade700
                 ),accountName: user_data.isEmpty ? Text(''):Text('${user_data[0]}'.toUpperCase()), accountEmail:user_data.isEmpty ? Text(''):Text('${user_data[1]}'),
                   currentAccountPicture:Icon(Icons.supervised_user_circle,size: 76,color: Colors.white,)

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
         if(a==1){
           Navigator.push(context, Myroute(update_company_account(user_data: user_data,)));
         }
         if(a==2){
           // Navigator.push(context, Myroute(ChatScreen()));
         }

       },
       selectedItemColor: Colors.green.shade700,
       elevation: 0,
       unselectedItemColor:Colors.black ,
       items: [
         BottomNavigationBarItem(icon:Icon(Icons.home,) ,label: 'Home'),
         BottomNavigationBarItem(icon:Icon(Icons.supervised_user_circle),label: 'Account' ),
         BottomNavigationBarItem(icon:Icon(Icons.sms,),label: 'Chat' ),
       ],
     ),


     body:ListView(
       children: [
         Container(height: size.height*0.11,
         child: Row(
         crossAxisAlignment: CrossAxisAlignment.center,
           mainAxisAlignment: MainAxisAlignment.center,
           children: [

           Container(
            width: size.width*0.7,
            child: TextField(
             cursorColor:Colors.green.shade700 ,
              controller: search_controller,
              onChanged: (a){

                searched_section.clear();
                searched_images.clear();
                for(int i=0;i<sections_list.length;i++){
                   if(sections_list[i].toUpperCase().startsWith(a.toUpperCase())){
                     setState(() {
                       searched_section.add(sections_list[i]);
                       searched_images.add(images_list[i]);
                     });
                   }
                }


              },
              inputFormatters: [  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),],
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: ' Search',
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.green)
                ),
              ),
            ),
          ),
             LottieBuilder.asset('images/seedanimation.json',height: 80,),
         ],),
         decoration: BoxDecoration(
             color: Colors.green.shade700,
           borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20) ),

         ),),
        Text('\n'),
       Container(
         height: size.height*0.62,

         child: search_controller.text.isEmpty ? GridView.count(
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
                   if(sections_list[index]=='Logout'){
                     Clear_Preferences();
                     EasyLoading.showSuccess('Logout');
                     Navigator.pushReplacement(context, Myroute(companylogin()));
                     return;
                   }

                   if(sections_list[index]=='Add new'){
                     Navigator.push(context, Myroute(AddProductsPage()));
                     return;
                   }
                   if(sections_list[index]=='Products'){
                     Navigator.push(context, Myroute(Allproducts()));
                     return;
                   }
                   if(sections_list[index]=='Complaints'){
                     Navigator.push(context, Myroute(Company_complaints()));
                     return;
                   }
                   if(sections_list[index]=='Bulk Deals'){
                     Navigator.push(context, Myroute(Company_deals()));
                     return;

                   }
                   if(sections_list[index]=='Orders'){
                     Navigator.push(context, Myroute( companyorders(companylicense: user_data[4],)));
                     return;

                   }
                   if(sections_list[index]=='Dealers'){
                     Navigator.push(context, Myroute(Dealerscompanyside (companylicense: user_data[4],)));
                     return;

                   }
                   if(sections_list[index]=='Diseases'){
                     Navigator.push(context, Myroute(diseases()));
                     return;

                   }

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
         ):
         GridView.count(
           crossAxisCount: 3,
           padding: EdgeInsets.all(16),
           childAspectRatio: 1,
           crossAxisSpacing: 10.0,
           mainAxisSpacing: 10,
           children: List.generate(
             searched_section.length,
                 (index) {
               return InkWell(
                 borderRadius: BorderRadius.circular(20),
                 onTap: (){

                   if(searched_section[index]=='Logout'){
                     Clear_Preferences();
                     EasyLoading.showSuccess('Logout');
                     Navigator.pushReplacement(context, Myroute(companylogin()));
                     return;
                   }
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
                       Image.asset(searched_images[index], width: 50, height: 50),
                       SizedBox(height: 8),
                       Text(searched_section[index]),
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
    var license,a;
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

    a=await new database().GetImage_Firebase('company_licenses',user_data[1]);
    user_data.add(a);


  }
}