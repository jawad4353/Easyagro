


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyagro/Company/addproducts.dart';
import 'package:easyagro/Company/rud_products.dart';
import 'package:easyagro/splash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Allproducts extends StatefulWidget{
  @override
  State<Allproducts> createState() => _AllproductsState();
}

class _AllproductsState extends State<Allproducts> with SingleTickerProviderStateMixin {
 late TabController catagoty_controller=new TabController(length: 4,vsync: this);
 var licenseno;

 @override
  void initState() {
    super.initState();
    Getlicense();
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
  return Scaffold(
    backgroundColor:Colors.white,
    appBar: AppBar(centerTitle: true,title: Text('Products',style: TextStyle(fontSize: 20,fontFamily: 'jd'),),
      actions: [IconButton(onPressed: (){
        Navigator.push(context, Myroute(AddProductsPage()));
      }, icon: Icon(Icons.add,color: Colors.white,size: 27,)),
      Text('  '),],elevation: 0,backgroundColor: Colors.green.shade700,

      bottom:PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 78),
        child: Column(children: [

          Padding(
            padding: EdgeInsets.only(left: size.width*0.1,right: size.width*0.1),
            child: TextField(
              cursorColor: Colors.green,
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
            tabs: [

              Tab(icon: Icon(Icons.accessibility), text: 'Pesticides'),
              Tab(icon: Icon(Icons.hourglass_bottom), text: 'Granuale'),
              Tab(icon: Icon(Icons.directions_ferry), text: 'Micronutrient'),
              Tab(icon: Icon(Icons.ac_unit_sharp), text: 'Fertilizers'),
            ],
          ),
        ],),
      )
    ),
     body: TabBarView(
       controller: catagoty_controller,
       children: [
        pesticides(license: licenseno,),
         granuale(license: licenseno,),
         micronutrient(license: licenseno,),
         fertilizer(license: licenseno,)

       ],
     )

  );
  }
}



class pesticides extends StatefulWidget{
  var license;
  pesticides({required this.license});
  @override
  State<pesticides> createState() => _pesticidesState();
}

class _pesticidesState extends State<pesticides> {

  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body:  StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('products').where('companylicense', isEqualTo: '${widget.license}').where('productcategory', isEqualTo: 'Pesticides').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(color: Colors.green.shade700,),
            );
          }

          // Create a list of product documents from the snapshot
          final products = snapshot.data!.docs;

          return products.isEmpty? Center(child: Text('No products')): Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.75,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index].data() as Map<String, dynamic>;
                  final description = product['productdescription'] as String;
                  final shortDescription =
                  description.length > 50 ? '${description.substring(0, 50)}...' : description;
                  // Replace the placeholders with the actual product data
                  return  Column(
                    children: [
                      Container(
                        height: 120,
                        child: ClipRRect(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                          child: Image.network(
                            '${product['image']}',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${product['productname']}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(shortDescription),
                            Text(''),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '\R.s ${product['productprice']}',
                                  style: TextStyle(fontWeight: FontWeight.bold,color: Colors.green.shade700),
                                ),
                                Text(
                                  '(${product['productquantity']})',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],)
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),

    );
  }
}



class granuale extends StatefulWidget {
  var license;
  granuale({required this.license});
  @override
  State<granuale> createState() => _granualeState();
}

class _granualeState extends State<granuale> {
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body:  StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('products').where('companylicense', isEqualTo: '${widget.license}').where('productcategory', isEqualTo: 'Granuale').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          // Create a list of product documents from the snapshot
          final products = snapshot.data!.docs;

          return products.isEmpty? Center(child: Text('No products')): Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.75,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index].data() as Map<String, dynamic>;
                  final description = product['productdescription'] as String;
                  final shortDescription =
                  description.length > 50 ? '${description.substring(0, 50)}...' : description;
                  // Replace the placeholders with the actual product data
                  return  Column(
                    children: [
                      Container(
                        height: 120,
                        child: ClipRRect(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                          child: Image.network(
                            '${product['image']}',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${product['productname']}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(shortDescription),
                            Text(''),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '\R.s ${product['productprice']}',
                                  style: TextStyle(fontWeight: FontWeight.bold,color: Colors.green.shade700),
                                ),
                                Text(
                                  '(${product['productquantity']})',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],)
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),

    );
  }
}






class micronutrient extends StatefulWidget {
  var license;
  micronutrient({required this.license});

  @override
  State<micronutrient> createState() => _micronutrientState();
}

class _micronutrientState extends State<micronutrient> {
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body:  StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('products').where('companylicense', isEqualTo: '${widget.license}').where('productcategory', isEqualTo: 'Micronutrient').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          // Create a list of product documents from the snapshot
          final products = snapshot.data!.docs;

          return products.isEmpty? Center(child: Text('No products')): Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.75,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index].data() as Map<String, dynamic>;
                  final description = product['productdescription'] as String;
                  final shortDescription =
                  description.length > 50 ? '${description.substring(0, 50)}...' : description;
                  // Replace the placeholders with the actual product data
                  return  Column(
                    children: [
                      Container(
                        height: 120,
                        child: ClipRRect(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                          child: Image.network(
                            '${product['image']}',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${product['productname']}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(shortDescription),
                            Text(''),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '\R.s ${product['productprice']}',
                                  style: TextStyle(fontWeight: FontWeight.bold,color: Colors.green.shade700),
                                ),
                                Text(
                                  '(${product['productquantity']})',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],)
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),

    );
  }
}







class fertilizer extends StatefulWidget {
  var license;
  fertilizer({required this.license});
  @override
  State<fertilizer> createState() => _fertilizerState();
}

class _fertilizerState extends State<fertilizer> {
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body:  StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('products').where('companylicense', isEqualTo: '${widget.license}').where('productcategory', isEqualTo: 'Fertilizers').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          // Create a list of product documents from the snapshot
          final products = snapshot.data!.docs;

          return products.isEmpty? Center(child: Text('No products')):Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.75,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index].data() as Map<String, dynamic>;
                  final description = product['productdescription'] as String;
                  final shortDescription =
                  description.length > 50 ? '${description.substring(0, 50)}...' : description;
                  // Replace the placeholders with the actual product data
                  return  Column(
                    children: [
                      Container(
                        height: 120,
                        child: ClipRRect(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                          child: Image.network(
                            '${product['image']}',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${product['productname']}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(shortDescription),
                            Text(''),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '\R.s ${product['productprice']}',
                                  style: TextStyle(fontWeight: FontWeight.bold,color: Colors.green.shade700),
                                ),
                                Text(
                                  '(${product['productquantity']})',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],)
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),

    );
  }
}













