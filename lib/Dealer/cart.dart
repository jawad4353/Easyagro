import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var license;
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart Items'),
        backgroundColor: Colors.green.shade700,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('cart')
            .doc('${license}')
            .collection('cartitem')
            .snapshots(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final cartItems = snapshot.data!.docs;

          return ListView.builder(
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Image.network(cartItems[index]['productimage']),
                title: Text(cartItems[index]['productname']),
                subtitle: Text('${cartItems[index]['quantity']}    ${cartItems[index]['productprice']} R.s'),
                trailing: Text(cartItems[index]['productquantity']),
              );
            },
          );
        },
      ),
    );
  }
}
