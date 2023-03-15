import 'dart:async';

import 'package:easyagro/splash.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Addtocart.dart';

class CartScreen extends StatefulWidget {

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var license,totalbill=0,totalitems;
  int currentStep = 0;

  

  @override
  void initState() {

    super.initState();
    _loadLicense();
    Timer(Duration(seconds: 2),()=>{
    Calculate_TotalBill()
    });
  }
  void _loadLicense() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var s = await prefs.getString('email');
    setState(() {
      license = s;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Cart Items'),
        backgroundColor: Colors.green.shade700,
        actions: [
          Text(
            'Total: $totalbill R.s',style: TextStyle(fontSize: 19,fontWeight: FontWeight.bold),
          )
        ],
      ),
      body:   Theme(
        data: Theme.of(context).copyWith(colorScheme: ColorScheme.light(primary: Colors.green.shade700,onPrimary: Colors.white)),
        child: Stepper(
            type: StepperType.horizontal,
            currentStep: currentStep,
            onStepContinue: () {
              setState(() {
                if(currentStep<2) {
                  currentStep += 1;
                }
              });
            },
            onStepCancel: currentStep==0 ? null:() {
              setState(() {
                  currentStep -= 1;
              });
            },
            onStepTapped: (a){
              setState(() {
                currentStep=a;
              });
            },
            steps: [
              Step(
                title: Text('Cart'),

                content:  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('cart')
                          .doc('${license}')
                          .collection('cartitem')
                          .snapshots(),
                      builder: (context, snapshot) {

                        if (!snapshot.hasData) {
                          return  Center(
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

                          );
                        }

                        final cartItems = snapshot.data!.docs;
                         totalitems=cartItems;
                        return cartItems.isEmpty? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.remove_shopping_cart),
                              Text('No items in cart',style: TextStyle(fontSize: 18),)
                            ],),
                        ) :Container(
                          height: size.height*0.63,
                          child: ListView.builder(
                            itemCount: cartItems.length,
                            itemBuilder: (context, index) {
                              var nameshort='${cartItems[index]['productname']}'.length<20 ?cartItems[index]['productname'] :
                             '${ cartItems[index]['productname']}'.substring(0,19,)+'..'
                              ;
                              return Container(

                                decoration: BoxDecoration(
                                  border: Border(top: BorderSide(color: Colors.black12,width: 1))
                                ),
                                child: ListTile(
                                  isThreeLine: true,
                                  contentPadding: EdgeInsets.zero,
                                  onTap: () async {
                                    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
                                        .collection('products')
                                        .where('productid', isEqualTo:cartItems[index]['productid'] )
                                        .get();

                                    Navigator.push(context,Myroute( Add_to_cart(product: snapshot.docs.first,type: '${cartItems[index]['productquantity']}',)));
                                  },
                                  leading: Image.network(cartItems[index]['productimage'],height: 190,),
                                  title: Text(cartItems[index]['productname']),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('${cartItems[index]['quantity']}\n${cartItems[index]['productprice']} R.s'),

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                        IconButton(onPressed: () async {
                                          var found=false;
                                          await FirebaseFirestore.instance.collection('cart').get().then((querySnapshot) async {
                                            for (var cart in querySnapshot.docs) {
                                              if (cart.data()['dealerlicense'] == license) {
                                                var cartItems1 = await cart.reference.collection('cartitem').get();
                                                for (var cartItem1 in cartItems1.docs) {
                                                  if (cartItem1.data()['productid'] == cartItems[index]['productid']) {
                                                      await cart.reference.collection('cartitem').doc(cartItem1.id).delete();
                                                    found =  true;
                                                    break;
                                                  }
                                                }
                                              }
                                              if (found) {
                                                break;
                                              }
                                            }
                                          });
                                        }, icon: Icon(Icons.delete_sharp,size: 29,color: Colors.redAccent,))
                                      ],)

                                    ],
                                  ),
                                  trailing: Wrap(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 26),
                                        child: IconButton(
                                          onPressed: () async {
                                            var found=false;
                                            await FirebaseFirestore.instance.collection('cart').get().then((querySnapshot) async {
                                              for (var cart in querySnapshot.docs) {
                                                if (cart.data()['dealerlicense'] == license) {
                                                  var cartItems1 = await cart.reference.collection('cartitem').get();
                                                  for (var cartItem1 in cartItems1.docs) {
                                                    if (cartItem1.data()['productid'] == cartItems[index]['productid']) {
                                                      if(int.parse(cartItems[index]['productquantity'])>1){
                                                        await cart.reference.collection('cartitem').doc(cartItem1.id).update({
                                                          'productquantity': '${ int.parse(cartItems[index]['productquantity'])-1}',
                                                        });
                                                      }

                                                      found =  true;

                                                      break;
                                                    }
                                                  }
                                                }
                                                if (found) {
                                                  break;
                                                }
                                              }
                                            });
                                          },
                                          icon: Icon(Icons.minimize_outlined,color: Colors.red,),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 22),
                                        child: Text(cartItems[index]['productquantity']),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 6),
                                        child: IconButton(
                                          onPressed: () async {
                                            var found=false;
                                            await FirebaseFirestore.instance.collection('cart').get().then((querySnapshot) async {
                                              for (var cart in querySnapshot.docs) {
                                                if (cart.data()['dealerlicense'] == license) {
                                                  var cartItems1 = await cart.reference.collection('cartitem').get();
                                                  for (var cartItem1 in cartItems1.docs) {
                                                    if (cartItem1.data()['productid'] == cartItems[index]['productid']) {
                                                      await cart.reference.collection('cartitem').doc(cartItem1.id).update({
                                                        'productquantity': '${ int.parse(cartItems[index]['productquantity'])+1}',
                                                      });
                                                      found =  true;

                                                      break;
                                                    }
                                                  }
                                                }
                                                if (found) {
                                                  break;
                                                }
                                              }
                                            });
                                          },
                                          icon: Icon(Icons.add,color: Colors.green.shade700,),
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


                isActive: currentStep >= 0,
                state: currentStep > 0 ?StepState.complete :StepState.editing
              ),

              Step(
                title: Text('Address'),
                content: Text('Step 2 content'),
                isActive: currentStep >= 1,
                  state: currentStep > 1 ?StepState.complete :StepState.editing
              ),
              Step(
                title: Text('Payment'),
                content: Text('Step 3 content'),
                isActive: currentStep == 2,
                  state: currentStep >2 ?StepState.complete :StepState.editing
              ),
            ],
          controlsBuilder: (context, details) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,

            children: [
              Expanded(
                flex: 1,
                child: ElevatedButton(onPressed: details.onStepContinue, child: Text('Continue')),),
              Expanded(child: ElevatedButton(style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.black12)
              ),onPressed: details.onStepCancel, child: Text('Back')),)
            ],
          ),
          ),
      ),




    );
  }

  Calculate_TotalBill(){
    totalbill=0;
    for (int i = 0; i < totalitems.length; i++) {
      if (totalitems[i]['productprice'] != null && totalitems[i]['productquantity'] != null) {
        totalbill+= int.parse(totalitems[i]['productprice']) * int.parse(totalitems[i]['productquantity']);
      }
    }
    Future.delayed(Duration(seconds: 2),()=>setState(() {
      totalbill;
    }));
  }
  

}








