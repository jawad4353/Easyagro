import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var license;
  int currentStep = 0;

  @override
  void initState() {

    super.initState();
    _loadLicense();
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
      ),
      body:   Stepper(

          type: StepperType.horizontal,
          currentStep: currentStep,
          onStepContinue: () {
            if(currentStep==2){
              return;
            }
            setState(() {
              currentStep += 1;
            });
          },
          onStepCancel: () {
            if(currentStep==0){
              return;
            }
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
                            return ListTile(
                              leading: Image.network(cartItems[index]['productimage']),
                              title: Text(cartItems[index]['productname']),
                              subtitle: Text('${cartItems[index]['quantity']}    ${cartItems[index]['productprice']} R.s'),
                              trailing: Text(cartItems[index]['productquantity']),
                            );
                          },
                        ),
                      );
                    },
                  ),


              isActive: currentStep == 0,
            ),

            Step(
              title: Text('Address'),
              content: Text('Step 2 content'),
              isActive: currentStep == 1,
            ),
            Step(
              title: Text('Payment'),
              content: Text('Step 7 content'),
              isActive: currentStep == 1,
            ),
          ],
        ),




    );
  }
}








