


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

              Tab(icon: Icon(Icons.accessibility), text: 'Fertilizers'),
              Tab(icon: Icon(Icons.medical_services_sharp), text: 'Medicines'),
              Tab(icon: Icon(Icons.hourglass_bottom), text: 'Drops'),
              Tab(icon: Icon(Icons.ac_unit_sharp), text: 'Spray'),
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
  var products=[{'name':'Urea','price':'350','quantity':'500ml','image':""
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQwVDX3Co8ifo9987mVb8swHJ9gG9ScFeUNanbOX1QqdVuIc-JZWt1q0GAFRHgLilaaiXA&usqp=CAU"}];

  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return Center(
      child: Container(
        width: size.width*0.8,
        child:  ListView(children: [

          Text(''),
          SizedBox(
            height: size.height*0.7,
            width: size.width*0.6,
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 25,
              crossAxisSpacing: 25,
              children: List.generate(9, (index) => Container(
                  height:200 ,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.white,spreadRadius: 3)],
                      border: Border.all(color: Colors.green,width: 2)
                  ),
                  child: Column(children: [
                    Container(
                      child: Image.network('${products[0]['image']}'),
                    ),
                    Text('${products[0]['name']}',style: TextStyle(fontSize: 23,fontWeight: FontWeight.bold),)

                  ],)
              )),),
          )

        ],),
      ),
    );
  }


}























class pesticied extends StatelessWidget{
  var products=[{'name':'Pesticides','price':'350','quantity':'500ml','image':""
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSQF7xljjUZEwHEwR9lyPb9uxycybBC2rlfurLuuAucF0HI6rpHuu2YIzXGK35SiLJa_4o&usqp=CAU"}];

  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return Center(
      child: Container(
        width: size.width*0.8,
        color: Colors.white,
        child:  ListView(children: [

          Text(''),
          SizedBox(
            height: size.height*0.7,
            width: size.width*0.6,
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 25,
              crossAxisSpacing: 25,
              children: List.generate(9, (index) => Container(
                  height:200 ,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.white,spreadRadius: 3)],
                      border: Border.all(color: Colors.green,width: 2)
                  ),
                  child: Column(children: [
                    Container(
                      child: Image.network('${products[0]['image']}'),
                    ),
                    Text('${products[0]['name']}',style: TextStyle(fontSize: 23,fontWeight: FontWeight.bold),)

                  ],)
              )),),
          )

        ],),
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
    return Center(
      child: Container(
        width: size.width*0.8,
        child:  ListView(children: [

          Text(''),
          SizedBox(
            height: size.height*0.7,
            width: size.width*0.6,
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 25,
              crossAxisSpacing: 25,
              children: List.generate(9, (index) => Container(
                  height:200 ,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.white,spreadRadius: 3)],
                      border: Border.all(color: Colors.green,width: 2)
                  ),
                  child: Column(children: [
                    Container(
                      child: Image.network('${products[0]['image']}'),
                    ),
                    Text('${products[0]['name']}',style: TextStyle(fontSize: 23,fontWeight: FontWeight.bold),)

                  ],)
              )),),
          )

        ],),
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
    return Center(
      child: Container(
        width: size.width*0.8,
        child:  ListView(children: [

          Text(''),
          SizedBox(
            height: size.height*0.7,
            width: size.width*0.6,
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 25,
              crossAxisSpacing: 25,
              children: List.generate(9, (index) => Container(
                  height:200 ,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.white,spreadRadius: 3)],
                      border: Border.all(color: Colors.green,width: 2)
                  ),
                  child: Column(children: [
                    Container(
                      child: Image.network('${products[0]['image']}'),
                    ),
                    Text('${products[0]['name']}',style: TextStyle(fontSize: 23,fontWeight: FontWeight.bold),)

                  ],)
              )),),
          )

        ],),
      ),
    );
  }


}