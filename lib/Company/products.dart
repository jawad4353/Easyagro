


import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyagro/Company/addproducts.dart';
import 'package:easyagro/Company/rud_products.dart';
import 'package:easyagro/splash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Notifiers.dart';


class Allproducts extends StatefulWidget{
  @override
  State<Allproducts> createState() => _AllproductsState();
}

class _AllproductsState extends State<Allproducts> with SingleTickerProviderStateMixin {
 late TabController catagoty_controller=new TabController(length: 7,vsync: this);
 var licenseno,clear_provider=false;

 @override
  void initState() {
    super.initState();
    Getlicense();
    Timer(Duration(milliseconds: 100),()=> Provider.of<GlobalState>(context, listen: false).value = '');

  }

  Future<void> Getlicense() async {
    SharedPreferences pref =await SharedPreferences.getInstance();
    var s=await pref.getString("email");
    setState(() {
      licenseno=s;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
  return  Scaffold(
      backgroundColor:Colors.white,
      appBar: AppBar(centerTitle: true,title: Text('Products',style: TextStyle(fontSize: 20,fontFamily: 'jd'),),
        actions: [IconButton(onPressed: (){
          Navigator.push(context, Myroute(AddProductsPage()));
        }, icon: Icon(Icons.add,color: Colors.white,size: 27,)),
        Text('  '),],elevation: 0,backgroundColor: Colors.green.shade700,

        bottom:PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight + 48),
          child: Column(children: [

            Padding(
              padding: EdgeInsets.only(left: size.width*0.1,right: size.width*0.1),
              child: TextField(
                cursorColor: Colors.green,

                onChanged: (a){
                    Provider.of<GlobalState>(context, listen: false).value = a;
                },

                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 15),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Search products',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.green)
                  ),
                ),),
            ),
            TabBar(
              controller:catagoty_controller ,
              indicatorColor: Colors.white,
              isScrollable: true,
              tabs: [

                Tab( text: 'Pesticides'),
                Tab( text: 'Granuale'),
                Tab( text: 'Micronutrient'),
                Tab(text: 'Fertilizers'),
                Tab(text: 'Seeds'),
                Tab(text: 'Farming Tools'),
                Tab(text: 'Others'),
              ],
            ),
          ],),
        )
      ),
       body: TabBarView(

         controller: catagoty_controller,
         children: [
           display_products(license: licenseno,category: 'Pesticides',),
           display_products(license: licenseno,category: 'Granuale',),
           display_products(license: licenseno,category: 'Micronutrient',),
           display_products(license: licenseno,category: 'Fertilizers',),
           display_products(license: licenseno,category: 'Seeds',),
           display_products(license: licenseno,category: 'Farming Tools',),
           display_products(license: licenseno,category: 'Others',),

         ],
       )

  );
  }
}




class display_products  extends StatefulWidget{
  var license,category;
  display_products({required this.license,this.category});
  @override
  State<display_products> createState() => _display_productsState();
}

class _display_productsState extends State<display_products> {
 late String globalValue;

  @override
  Widget build(BuildContext context) {
    globalValue = Provider.of<GlobalState>(context).value;
    var size=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body:  StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('products').where('companylicense', isEqualTo: '${widget.license}').where('productcategory', isEqualTo: '${widget.category}').snapshots(),
        builder: (context, snapshot) {
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
                        border: Border.all(color: Colors.green)


                    ));
                  }),
                ),
              ),
            );
          }



          List<DocumentSnapshot> filteredProducts = snapshot.data!.docs.where((doc) {
            return doc['productname'].toLowerCase().contains(globalValue.toLowerCase());
          }).toList();


          return filteredProducts.isEmpty? Center(child: Text('No products')): Container(
            color: Colors.white,
            padding: const EdgeInsets.all(8.0),
            child:  GridView.builder(
                padding: EdgeInsets.all(10),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.73,
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
                  return  InkWell(
                    onTap: (){
                      Navigator.push(context, Myroute(ViewProductPage(product: product,)));
                    },
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(width: 2,color: Colors.black12)
                      ),
                      child: Column(
                       crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                         Container(
                           height: 125,
                           child: Image.network(
                              '${product['image']}',fit: BoxFit.fill,

                            ),
                         ),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$nameeshort',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text('$shortDescription'),
                                Text(''),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      ' \R.s ${product['productprice']}',
                                      style: TextStyle(fontWeight: FontWeight.bold,color: Colors.green.shade700),
                                    ),
                                    Text(
                                      '(${product['productquantity']})  ',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),

                                  ],),
                                Text('')
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

          );
        },
      ),

    );
  }
}




