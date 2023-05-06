

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyagro/Dealer/dealerlogin.dart';
import 'package:easyagro/Dealer/update_dealer.dart';
import 'package:easyagro/supportingwidgets.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Company/companylogin.dart';
import '../Company/chatscreen.dart';
import '../Database/database.dart';
import '../sharedpref_validations.dart';
import '../splash.dart';
import './Productsdealer.dart';
import 'complaintsdealer.dart';
import 'dealerorders.dart';

class dealerhome extends StatefulWidget{
  @override
  State<dealerhome> createState() => _dealerhomeState();
}

class _dealerhomeState extends State<dealerhome> {
  var user_data=[], index_current=0,license;
  TextEditingController search_controller=new TextEditingController();
  final CollectionReference companyCollection =
  FirebaseFirestore.instance.collection('company');

  @override
  void initState() {
    super.initState();
    Get_current_dealer_details();
  }
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        elevation: 0,
        title: Container(
          height:37,

          child: TextField(
            controller: search_controller,
            onChanged: (a){
              setState(() {

              });
            },
            style: TextStyle(fontSize: 21,fontWeight: FontWeight.w400),
            cursorColor: Colors.green.shade700,
            decoration: InputDecoration(
              hintText: 'Search company',
              hintStyle:TextStyle(fontSize: 16) ,
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide:BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
        ),backgroundColor: Colors.green.shade700,actions: [

         IconButton(onPressed: (){
           Clear_Preferences();
           EasyLoading.showSuccess('Logout');
           Navigator.pushReplacement(context, Myroute(dealerlogin()));
         },icon: Icon(Icons.logout,),) ,
          IconButton(onPressed:(){}, icon: Icon(Icons.notifications,)),

      ],

      ),



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
                ),accountName: user_data.isEmpty ?Text(''):Text('${user_data[0]}'), accountEmail: user_data.isEmpty ?Text(''):Text('${user_data[1]}'),
                  currentAccountPicture: StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('dealer').where('license',isEqualTo: '$license').snapshots(),
                    builder: (context,snap){
                      if(!snap.hasData){
                        show_progress_indicator();
                      }
                      if(snap.hasError || snap.data==null){
                        show_progress_indicator();
                      }

                      var data;

                      try{
                        data=snap.data!.docs.single;
                      }
                      catch(e){}

                      return InkWell(
                        onTap: (){
                          Navigator.push(context, Myroute(ImageScreen(imageUrl:data.data()['profileimage'],)));
                        },
                        child: Container(
                          height: 70,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child:snap.data==null? Icon(Icons.face,color: Colors.white,size: 65,):
                          Image.network(data.data()['profileimage'],fit: BoxFit.fill,),
                        ),
                      );

                    },
                  )

                ),




                Row(children: [
                  TextButton.icon(style: ButtonStyle(
                      overlayColor: MaterialStateProperty.resolveWith((states) => Colors.transparent)
                  ),onPressed: (){
                  Navigator.push(context, Myroute(OrdersScreen(dealerlicense:user_data[4])));
                  },icon: Icon(Icons.favorite_border,color: Colors.green.shade700,),label: Text('Orders',style: TextStyle(color: Colors.black,fontSize: 16),),),

                ],),
                Row(children: [
                  TextButton.icon(style: ButtonStyle(
                      overlayColor: MaterialStateProperty.resolveWith((states) => Colors.transparent)
                  ),onPressed: (){
                   Navigator.push(context, Myroute( Dealer_Complains(data:user_data)));
                  },icon: Icon(Icons.report,color: Colors.green.shade700,),label: Text('Complains',style: TextStyle(color: Colors.black,fontSize: 16),),),

                ],),
                Row(children: [
                  TextButton.icon(style: ButtonStyle(
                      overlayColor: MaterialStateProperty.resolveWith((states) => Colors.transparent)
                  ),onPressed: (){

                  },icon: Icon(Icons.approval,color: Colors.green.shade700,),label: Text('About Us',style: TextStyle(color: Colors.black,fontSize: 16),),),

                ],),


                Row(children: [

                  TextButton.icon(style: ButtonStyle(
                      overlayColor: MaterialStateProperty.resolveWith((states) => Colors.transparent)
                  ),onPressed: (){
                    Clear_Preferences();
                    EasyLoading.showSuccess('Logout');
                    Navigator.pushReplacement(context, Myroute(dealerlogin()));
                  },icon: Icon(Icons.logout,color: Colors.green.shade900,),label: Text('Logout',style: TextStyle(color: Colors.black,fontSize: 17),),),

                ],)

              ],
            ),
        ),
      ),



      body: ListView(
        children: [

         Container(
            height: size.height*0.77,

            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('company').snapshots(),
              builder: (context, snapshot)  {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                if (!snapshot.hasData) {
                  return show_progress_indicator();
                }

                List<DocumentSnapshot> filteredcompanies = snapshot.data!.docs.where((doc) {
                  return doc['name'].toLowerCase().contains(search_controller.text.toLowerCase());
                }).toList();
                // Navigator.push(context, Myroute(dealer_products(company_license:companyData['license'] ,)));

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
                        Navigator.push(context, Myroute(dealer_products(company_license: companyData['license'],)));
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.white,width: 2))
                      ),
                        child: Column(
                          children: [
                            Container(
                              height:200,
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

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: index_current,
        onTap: (a){
          setState(() {
            index_current=a;
          });
          if(a==1){
            Navigator.push(context, Myroute(update_dealer_account(user_data: user_data,)));
          }
          if(a==2){
            // Navigator.push(context, Myroute(ChatScreen()));
          }

        },
        selectedItemColor: Colors.green.shade700,
        elevation: 0,
        items: [
          BottomNavigationBarItem(icon:Icon(Icons.home,color: Colors.black,) ,label: 'Home',
          backgroundColor: Colors.white),
          BottomNavigationBarItem(icon:Icon(Icons.supervised_user_circle,color: Colors.black,),label: 'Account' ),
          BottomNavigationBarItem(icon:Icon(Icons.sms,color: Colors.black,),label: 'Chat' ),
        ],
      ),


    );
  }

  Get_current_dealer_details() async {
    var a;
    SharedPreferences pref =await SharedPreferences.getInstance();
    license=await pref.getString("email");

    await FirebaseFirestore.instance.collection("dealer").get().then((querySnapshot) {
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
    a=await new database().GetImage_Firebase('dealer_licenses',user_data[1]);
    user_data.add(a);

  }



}




