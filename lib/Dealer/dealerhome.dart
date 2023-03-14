

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyagro/Dealer/dealerlogin.dart';
import 'package:easyagro/Dealer/update_dealer.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Company/companylogin.dart';
import '../Company/live_chat.dart';
import '../Database/database.dart';
import '../sharedpref_validations.dart';
import '../splash.dart';
import './Productsdealer.dart';

class dealerhome extends StatefulWidget{
  @override
  State<dealerhome> createState() => _dealerhomeState();
}

class _dealerhomeState extends State<dealerhome> {
  var user_data=[], index_current=0;
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

      backgroundColor: Colors.green.shade700,


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
              ),accountName: user_data.isEmpty ?Text(''):Text('${user_data[0]}'), accountEmail: user_data.isEmpty ?Text(''):Text('${user_data[1]}'),
                currentAccountPicture: Icon(Icons.face,color: Colors.white,size: 65,),
              ),


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
                              height:160,
                                color: Colors.green.shade700,
                                width: size.width,
                                child:  Image.network('${companyData['profileimage']}',fit: BoxFit.fill,)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                              Text('$nameshort',style: TextStyle(fontFamily: 'jd',fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold),),
                              Text('${companyData['email']}',style: TextStyle(color: Colors.white),),
                            ],),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                              Row(children: [
                                Icon(Icons.house_siding_sharp,color: Colors.white,),
                                Text('$addressshort',style: TextStyle(color: Colors.white),),
                              ],),
                                Row(children: [
                                  Icon(Icons.phone,color: Colors.white,),
                                  Text('${companyData['phone']}',style: TextStyle(color: Colors.white),),
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
            Navigator.push(context, Myroute(LiveChatPage()));
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
    var license,a;
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




