


import 'package:easyagro/Company/addproducts.dart';
import 'package:easyagro/splash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Allproducts extends StatefulWidget{
  @override
  State<Allproducts> createState() => _AllproductsState();
}

class _AllproductsState extends State<Allproducts> with SingleTickerProviderStateMixin {
 late TabController catagoty_controller=new TabController(length: 4,vsync: this);

 @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
  return Scaffold(
    backgroundColor:Colors.white,
    appBar: AppBar(centerTitle: true,title: Text('Products',style: TextStyle(fontSize: 22,fontFamily: 'jd'),),
      actions: [IconButton(onPressed: (){
        Navigator.push(context, Myroute(AddProductsPage()));
      }, icon: Icon(Icons.add,color: Colors.white,size: 34,)),
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
         fertilizers(),
         pesticied(),
         drops()
      ,spray()
       ],
     )

  );
  }
}



class fertilizers extends StatelessWidget{
  var products=[{'name':'Pesticides','price':'350','quantity':'500ml','image':""
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQwVDX3Co8ifo9987mVb8swHJ9gG9ScFeUNanbOX1QqdVuIc-JZWt1q0GAFRHgLilaaiXA&usqp=CAU"}];

  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black12,

      body:  Padding(
        padding:  EdgeInsets.only(top: 10),
        child: Center(
          child: SizedBox(
            height: size.height*0.9,
            width: size.width*0.9,
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: List.generate(9, (index) {
                final product = products[index % products.length];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                          child: Image.network(
                            '${product['image']}',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${product['name']}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('Urea fertilizers completely new packaging',),
                            Text(''),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '\R.s ${product['price']}',
                                  style: TextStyle(fontWeight: FontWeight.bold,color: Colors.green.shade700),
                                ),
                                Text(
                                  '(250ml)',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],)
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            )

          ),
        ),
      )

    );
  }


}




class View_product extends StatefulWidget{
  var productdetails=[];
  View_product({required this.productdetails});
  @override
  State<View_product> createState() => _View_productState();
}

class _View_productState extends State<View_product> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [

      ],),
    );
  }
}



















class pesticied extends StatelessWidget{
  var products=[{'name':'Pesticides','price':'350','quantity':'500ml','image':""
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSQF7xljjUZEwHEwR9lyPb9uxycybBC2rlfurLuuAucF0HI6rpHuu2YIzXGK35SiLJa_4o&usqp=CAU"}];

  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return  Scaffold(
      backgroundColor: Colors.black12,
      body: Padding(
        padding:  EdgeInsets.only(top: 10),
        child: Center(
          child: SizedBox(
              height: size.height*0.9,
              width: size.width*0.9,
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: List.generate(9, (index) {
                  final product = products[index % products.length];
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                            child: Image.network(
                              '${product['image']}',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${product['name']}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('Urea fertilizers completely new packaging',),
                              Text(''),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '\R.s ${product['price']}',
                                    style: TextStyle(fontWeight: FontWeight.bold,color: Colors.green.shade700),
                                  ),
                                  Text(
                                    '(250ml)',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],)
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              )

          ),
        ),
      ),
    );
  }


}









class drops extends StatelessWidget{
  var products=[{'name':'Drops','price':'350','quantity':'500ml','image':""
      "https://media.gettyimages.com/id/1248145633/photo/midsection-of-man-holding-bottle-in-farm.jpg?s=612x612&w=gi&k=20&c=cpbI7TWZlJf61kWGfhKSR4nvJWRRf6cKXKzm2Mlql1A="}];
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return  Scaffold(
      backgroundColor: Colors.black12,
      body: Padding(
        padding:  EdgeInsets.only(top: 10),
        child: Center(
          child: SizedBox(
              height: size.height*0.9,
              width: size.width*0.9,
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: List.generate(9, (index) {
                  final product = products[index % products.length];
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                            child: Image.network(
                              '${product['image']}',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${product['name']}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('Urea fertilizers completely new packaging',),
                              Text(''),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '\R.s ${product['price']}',
                                    style: TextStyle(fontWeight: FontWeight.bold,color: Colors.green.shade700),
                                  ),
                                  Text(
                                    '(500ml)',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],)
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              )

          ),
        ),
      ),
    );
  }


}





class spray extends StatelessWidget{
  var products=[{'name':'Spray','price':'350','quantity':'500ml','image':""
      "https://media.istockphoto.com/id/503140566/photo/manual-pesticide-sprayer.jpg?s=612x612&w=0&k=20&c=EYM4IP2HJTeObKfO9HUgzmtv8MehyaS8iQWoRVRgJdI="}];

  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return  Scaffold(
      backgroundColor: Colors.black12,
      body: Padding(
        padding:  EdgeInsets.only(top: 10),
        child: Center(
          child: SizedBox(
              height: size.height*0.9,
              width: size.width*0.9,
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: List.generate(9, (index) {
                  final product = products[index % products.length];
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                            child: Image.network(
                              '${product['image']}',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${product['name']}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('Urea fertilizers completely new packaging',),
                            Text(''),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                              Text(
                                '\R.s ${product['price']}',
                                style: TextStyle(fontWeight: FontWeight.bold,color: Colors.green.shade700),
                              ),
                              Text(
                                '(250ml)',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],)
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              )

          ),
        ),
      ),
    );
  }



}