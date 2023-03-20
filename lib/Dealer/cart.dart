import 'dart:async';

import 'package:easyagro/Dealer/dealerhome.dart';
import 'package:easyagro/splash.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../sharedpref_validations.dart';
import 'Addtocart.dart';

class CartScreen extends StatefulWidget {

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var license,totalbill,totalitems,dealer_address,addresschanged=false,Address_error,Address_error_color=Colors.grey;
  int currentStep = 0;
  var Titlelist=['Cart','Address','Payment'],address;
  TextEditingController address_controller=new TextEditingController();
  

  @override
  void initState() {

    super.initState();
    _loadLicense();
    Timer(Duration(seconds: 1),()=>{
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
        title: Text(Titlelist[currentStep]),
        backgroundColor: Colors.green.shade700,
        actions: [
          Center(
            child: Text(
              totalbill==null || totalbill==0 ? '':'Total: $totalbill R.s',style: TextStyle(fontSize: 19,fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
      body:   Theme(
        data: Theme.of(context).copyWith(colorScheme: ColorScheme.light(primary: Colors.green.shade700,onPrimary: Colors.white)),
        child: Stepper(
            type: StepperType.horizontal,
            currentStep: currentStep,
            onStepContinue: () async {

             if(currentStep==0){
               final snapshot = await FirebaseFirestore.instance
                   .collection('cart')
                   .doc(license)
                   .get();
               if(!snapshot.exists){
                 EasyLoading.showInfo('No items in cart. Add items to proceed');
                 return;
               }
             }



          var mycompany;
              if(currentStep==2 ){
                var ordersc=FirebaseFirestore.instance.collection('orders');
                var docum=ordersc.doc();
                FirebaseFirestore.instance.collection('orders').doc(docum.id).set({
                  'dealerlicense':'$license',
                  'address':'$address',
                  'status':'confirmed',
                  'total':'$totalbill',
                  'date':'${DateTime. now()}',

                  });
                var ref=docum.collection('orderitem');
                 var found=false;
                await FirebaseFirestore.instance.collection('cart').get().then((querySnapshot) async {
                  for (var cart in querySnapshot.docs) {
                    print('outer');
                    if (cart.data()['dealerlicense'] == license) {
                      found=true;
                      var cartItems1 = await cart.reference.collection('cartitem').get();
                      for (var cartItem1 in cartItems1.docs) {

                        ref.add({
                          'quantity':cartItem1['quantity'],
                          'productid':cartItem1['productid'],
                          'productquantity':cartItem1['productquantity'],
                          'productname':cartItem1['productname'],
                          'productprice':cartItem1['productprice'],
                          'productimage':cartItem1['productimage'],

                        });
                        mycompany=cartItem1['companylicense'];

                      }
                    }

                    if(found==true){
                      break;
                    }
                  }
                });








                await FirebaseFirestore.instance.collection('cart').get().then((querySnapshot) async {
                  for (var cart in querySnapshot.docs) {
                    if (cart.data()['dealerlicense'] == license) {
                      var cartItems1 = await cart.reference.collection('cartitem').get();
                      for (var cartItem1 in cartItems1.docs) {
                         cart.reference.collection('cartitem').doc(cartItem1.id).delete();
                      }

                      FirebaseFirestore.instance.collection('cart').doc(license).delete();
                    }
                  }
                });
                totalbill=null;
                EasyLoading.showSuccess('Order Placed ');
                Navigator.pushReplacement(context, Myroute(dealerhome()));
              }
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
            onStepTapped: (a) async {
              if(currentStep==0){
                final snapshot = await FirebaseFirestore.instance
                    .collection('cart')
                    .doc(license)
                    .get();
                if(!snapshot.exists){
                  EasyLoading.showInfo('No items in cart. Add items to proceed');
                  return;
                }
              }

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
                                  border: Border(bottom: BorderSide(color: Colors.black12,width: 1))
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
                                  leading: Image.network(cartItems[index]['productimage'],height: 190,width: 70,),
                                  title: Text(cartItems[index]['productname'],style: TextStyle(fontSize: 18)),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('${cartItems[index]['quantity']}\nPrice: ${cartItems[index]['productprice']} R.s',style: TextStyle(fontSize: 15)),

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
                                                      cart.reference.collection('cartitem')
                                                          .get()
                                                          .then((querySnapshot) {
                                                        if (querySnapshot.size == 0) {
                                                          FirebaseFirestore.instance.collection('cart').doc(license).delete();
                                                        } else {
                                                          print('Collection is not empty');
                                                        }
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
                                          Calculate_TotalBill();
                                        }, icon: Icon(Icons.delete_sharp,size: 29,))
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
                                            Calculate_TotalBill();
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
                                            Calculate_TotalBill();
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
                content: Column(children: [
                Container(
                  height: 100,
                  child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('dealer').where('license', isEqualTo: license).snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
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

                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        DocumentSnapshot dealer = snapshot.data!.docs[index];
                        address=dealer['address'];
                        return ListTile(
                          title: Text(dealer['address']),
                          subtitle:Text('Address') ,
                          leading: Icon(Icons.location_on_rounded,size: 45,),
                        );
                      },
                    );
                  },
              ),
                ),

        if(!addresschanged)
                  ElevatedButton(onPressed: (){
                    setState(() {
                      addresschanged=!addresschanged;
                    });
                  }, child: Text('Change')),
                  if(addresschanged)
                    TextField(
                      controller: address_controller,
                      cursorColor: Colors.green.shade700,
                      keyboardType: TextInputType.visiblePassword,
                      onChanged: (a){
                        setState(() {
                          var s=Address_Validation(a.replaceAll(' ', ''));
                          Address_error=s[0];
                          Address_error_color=s[1];
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Address',
                        prefixIcon: Icon(Icons.location_on,color: Colors.green,size: 28,),
                        errorText: Address_error,
                        errorStyle: TextStyle(color: Address_error_color),
                        focusedErrorBorder:UnderlineInputBorder(borderSide: BorderSide(color: Address_error_color))
                        ,focusedBorder:UnderlineInputBorder(borderSide: BorderSide(color: Address_error_color)) ,
                        enabledBorder:UnderlineInputBorder(borderSide: BorderSide(color:Address_error_color)) ,
                        errorBorder: UnderlineInputBorder(borderSide: BorderSide(color:Address_error_color)),

                      ),),
                  if(addresschanged)
                  ElevatedButton(onPressed: () async {
                    var s=Address_Validation(address_controller.text.replaceAll(' ', ''));
                    if(address_controller.text.isEmpty){
                      EasyLoading.showInfo('Address required !');
                      return;
                    }
                    if(s[1]==Colors.red){
                      EasyLoading.showInfo('Invalid Address !');
                      return;
                    }
                    await FirebaseFirestore.instance.collection("dealer").get().then((querySnapshot) {
                      querySnapshot.docs.forEach((result) {
                        if(result.data()['license']==license ){
                        FirebaseFirestore.instance.collection('dealer').doc(result.id).update({'address':'${address_controller.text}'});
                        }
                      });
                    });

                    setState(() {
                      addresschanged=!addresschanged;

                    });
                  }, child: Text('Update')),

                ],),
                isActive: currentStep >= 1,
                  state: currentStep > 1 ?StepState.complete :StepState.editing
              ),
              Step(

                title: Text('Payment'),
                content: Column(
                  children: [
                  Text('Will be delivered to you in 2 to 7 days .')
                ],),
                isActive: currentStep == 2,
                  state: currentStep >2 ?StepState.complete :StepState.complete
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

  Calculate_TotalBill() async {
   var price=[],quantity=[];
   num Bill=0;
   await FirebaseFirestore.instance.collection('cart').get().then((querySnapshot) async {
      for (var cart in querySnapshot.docs) {
        if (cart.data()['dealerlicense'] == license) {
          var cartItems1 = await cart.reference.collection('cartitem').get().then((querySnapshot) {
            querySnapshot.docs.forEach((result) {
              if(result.data()['productprice']!=null){
                price.add(int.parse(result.data()['productprice']));
                quantity.add(int.parse(result.data()['productquantity']));
              }
            });
          });;
          }
      }
    });

   for(int i=0;i<quantity.length;i++){
     Bill+= price[i]*quantity[i];
   }

   setState(() {
     totalbill=Bill.toInt();
   });

  }


  

}








