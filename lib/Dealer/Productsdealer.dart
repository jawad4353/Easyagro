

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyagro/Dealer/dealerhome.dart';
import 'package:easyagro/splash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../Company/Notifiers.dart';
import '../Company/rud_products.dart';

class dealer_products extends StatefulWidget{
  var company_license;
  dealer_products({required this.company_license});
  @override
  State<dealer_products> createState() => _dealer_productsState();
}

class _dealer_productsState extends State<dealer_products> with SingleTickerProviderStateMixin{
 // TextEditingController catagoty_controller=new TextEditingController();
 late TabController catagoty_controller=new TabController(length: 7,vsync: this);
  var mytabs=[];

  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 100),()=> Provider.of<GlobalState>(context, listen: false).value = '');
  }

  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('Products'),centerTitle: true,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios_rounded,size: 30),onPressed: (){
          Navigator.push(context, Myroute(dealerhome()));
        },),
        backgroundColor: Colors.green.shade700,actions: [
        IconButton(onPressed: (){}, icon: Icon(Icons.shopping_cart)),
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 43),
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
      ),),
      body: TabBarView(
        controller: catagoty_controller,
        children: [
          load_Products(license: widget.company_license,category: 'Pesticides',),
          load_Products(license: widget.company_license,category: 'Granuale',),
          load_Products(license: widget.company_license,category: 'Micronutrient',),
          load_Products(license: widget.company_license,category: 'Fertilizers',),
          load_Products(license: widget.company_license,category: 'Seeds',),
          load_Products(license: widget.company_license,category: 'Farming Tools',),
          load_Products(license: widget.company_license,category: 'Others',),
        ],
      ),
    );
  }
}


class load_Products extends StatefulWidget{
  var license,category;
  load_Products({required this.license,this.category});
  @override
  State<load_Products> createState() => _load_ProductsState();
}

class _load_ProductsState extends State<load_Products> {
  late String globalValue;

  @override
  Widget build(BuildContext context) {
    globalValue = Provider.of<GlobalState>(context).value;
    var size=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black12,
      body:  StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('products').where('companylicense', isEqualTo: '${widget.license}').where('productcategory', isEqualTo: '${widget.category}').snapshots(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return Center(
              child: Container(
                color: Colors.white,
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
              ),
            );
          }


          // var filteredProducts=snapshot.data!.docs;
          List<DocumentSnapshot> filteredProducts = snapshot.data!.docs.where((doc) {
            return doc['productname'].toLowerCase().contains(globalValue.toLowerCase());
          }).toList();


          return filteredProducts.isEmpty? Stack(
            children: [
              Container(color: Colors.white,height: double.maxFinite,),
              Center(
                child: Container(
                  color: Colors.white,
                  child: Text('No products'),
                ),
              )
            ],
          ): Container(
            color: Colors.white,
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.65
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index].data() as Map<String, dynamic>;
                final name = product['productname'] as String;
                final nameShort = name.length > 20 ? '${name.substring(0, 20)}...' : name;
                final description = product['productdescription'] as String;
                final shortDescription =
                description.length > 50 ? '${description.substring(0, 50)}...' : description;
                return Card(
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(width: 2, color: Colors.black12),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, Myroute(ViewProductPage(product: product)));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          height: 125,
                          child: Image.network(
                            '${product['image']}',
                            fit: BoxFit.fill,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                '$nameShort',
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
                                      // Handle button press
                                    },
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.green.shade700)
                                    ),
                                    child: Text('Add to cart'),
                                  ),
                                ],
                              )
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






