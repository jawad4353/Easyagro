








import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Company/rud_products.dart';
import '../splash.dart';
import '../Database/database.dart';

class Add_to_cart extends StatefulWidget{
  var product;
  Add_to_cart({required this.product});
  @override
  State<Add_to_cart> createState() => _Add_to_cartState();
}

class _Add_to_cartState extends State<Add_to_cart> {
  var quantity=1;
  TextEditingController quantity_controller=new TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    quantity_controller.text='$quantity';
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle:true,backgroundColor: Colors.green.shade700,title: Text('${widget.product['productname']}'),actions: [
        IconButton(onPressed: (){}, icon: Icon(Icons.shopping_cart))
      ],),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(left: 5,right: 5),
        child:  ListView(
          children: [
            InkWell(
              hoverColor: Colors.green,
              onTap: (){
                Navigator.push(context,Myroute(View_image(imageurl:widget.product['image'] ,)));
              },
              child: Image.network(
                '${widget.product['image']}',
                fit: BoxFit.fill,
                height: 350,
              ),
            ),
            Text(
              '\n${widget.product['productname']}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'R.s ${widget.product['productprice']}',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700
                  ),
                ),
                Text('  '),
                Text('('),
                Icon(Icons.star, color: Colors.yellow),

                Text(
                  '4.7)   ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),





            Row(children: [
              Text('Quantity  :'),
              Padding(
                padding:EdgeInsets.only(bottom: 12),
                child: IconButton(onPressed: (){
                  if(quantity_controller.text=='1'){
                    return;
                  }
                  var s=int.parse(quantity_controller.text);
                  s=s-1;
                  setState(() {
                    quantity_controller.text="$s";
                  });
                }, icon: Icon(Icons.minimize_outlined)),
              ),
               Container(
                   width: 30,
                   child: TextField(
                     cursorColor: Colors.green.shade700,
                     controller: quantity_controller,
                     keyboardType: TextInputType.phone,
                     maxLength: 2,
               onChanged: (a){

               },
                     inputFormatters: [  FilteringTextInputFormatter.allow(RegExp(r'[1-9]')),],
                     decoration: InputDecoration(
                       counterText: '',
                       border: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(5),
                         borderSide: BorderSide.none,
                       ),
                         contentPadding: EdgeInsets.zero),
                   )),
              IconButton(onPressed: (){
                var s=int.parse(quantity_controller.text);
                s=s+1;
                setState(() {
                  quantity_controller.text="$s";
                });
              }, icon: Icon(Icons.add)),

              Text('Total : ${int.parse(quantity_controller.text)*int.parse(widget.product['productprice'])}')
            ],),







            Row(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Expanded(
                  flex: 2,
                  child: ElevatedButton(style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith((states) =>
                  Colors.green.shade700)),
                      onPressed: () async {
                        Add_tocart();

                      }, child: Text('Add to cart')),
                ),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(style: OutlinedButton.styleFrom(

                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.green.shade700,width: 2)

                  ),
                      onPressed: (){}, child: Text('Buy Now',style: TextStyle(color: Colors.green.shade700),)),
                ),



            ],),

            Text('\nDescription',style: TextStyle(fontSize: 19),),
            Text(
              '${widget.product['productdescription']}',
              style: TextStyle(fontSize: 16),
            )
            ,
            Text('\n \n Reviews\n',style: TextStyle(fontSize: 19),)

          ],
        ),
      ),
    );
  }

  Add_tocart() async {
    var license,cart=FirebaseFirestore.instance.collection('cart'),productexist;
    SharedPreferences pref =await SharedPreferences.getInstance();
    license=pref.getString("email");
    bool licenseExists = await licenseExistsInCart('${license}');
    if (licenseExists) {

      await FirebaseFirestore.instance.collection('cart').get().then((querySnapshot) {
        querySnapshot.docs.forEach((cart) {
          if(cart.data()['dealerlicense']==license){
            cart.reference.collection('cartitem').get().then((querySnapshot) {
              querySnapshot.docs.forEach((cartitem)  {
                if(cartitem.data()['productid']==widget.product['productid']){
                  productexist=true;
                  cart.reference.collection('cartitem').doc(cartitem.id).update({'productquantity':'${quantity_controller.text}',});

                }
              });
            });;
          }
        });
      }).whenComplete(() =>Product_not_exist(productexist,license) );


    } else {
      cart.add({'dealerlicense':'${license}'});
      cart.get().then((querySnapshot) {
        querySnapshot.docs.forEach((result) {
          if(result.data()['dealerlicense']==license){
           result.reference.collection('cartitem').add({
             'productid':'${widget.product['productid']}',
             'productquantity':'${quantity_controller.text}',
             'companylicense':'${widget.product['companylicense']}',
           });
          }
        });
      });
    }


  }




  Future<bool> licenseExistsInCart(String license) async {
    final cartSnapshot = await FirebaseFirestore.instance.collection('cart').get();
    return cartSnapshot.docs.any((doc) => doc.data()['dealerlicense'] == license);
  }

   Product_not_exist(productexist,license){
    EasyLoading.showInfo(productexist);
    if(productexist==false){
      FirebaseFirestore.instance.collection('cart').get().then((querySnapshot) {
        querySnapshot.docs.forEach((cart) {
          if(cart.data()['dealerlicense']==license){
            cart.reference.collection('cartitem').add({
              'productid':'${widget.product['productid']}',
              'productquantity':'${quantity_controller.text}',
              'companylicense':'${widget.product['companylicense']}',
            });
          }
        });
      });
    }
  }

}