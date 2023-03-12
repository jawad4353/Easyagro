
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyagro/splash.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'products.dart';

class ViewProductPage extends StatefulWidget {
  Map<String, dynamic> product;

  ViewProductPage({required this.product});

  @override
  State<ViewProductPage> createState() => _ViewProductPageState();
}

class _ViewProductPageState extends State<ViewProductPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green.shade700,
        actions: [
          IconButton(onPressed: (){
            print(widget.product['productname']);
            Navigator.push(context, Myroute(Updateproduct(product: widget.product,)));
          }, icon: Icon(Icons.update,size: 30,)),
          IconButton(onPressed: (){

            showDialog(context: context, builder: (context)=>AlertDialog(
              title:   Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text('Are you sure?'),
                Text('This product will be deleted permanently you will not be able to see it again',
                style: TextStyle(fontSize: 17,fontWeight: FontWeight.normal),),
              ],),

              actions: [
              ElevatedButton(style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.green.shade700)

              ),onPressed: () async {
                EasyLoading.show(status: 'Deleting ...');
                Navigator.of(context).pop();
                final storage = FirebaseStorage.instance;
                final ref = storage.ref().child('products/${widget.product['companylicense']}/${widget.product['productcategory']}/${widget.product['productid']}');
                try {
                  await ref.delete();
                  await FirebaseFirestore.instance.collection("products").get().then((querySnapshot) {
                    querySnapshot.docs.forEach((result) {
                      if(result.data()['productid']==widget.product['productid'] && result.data()['companylicense']==
                          widget.product['companylicense']
                      ){
                        FirebaseFirestore.instance.collection("products").doc(result.id).delete();
                      }

                    });
                  });
                  EasyLoading.showSuccess('Product Deleted');
                  Navigator.pushReplacement(context, Myroute(Allproducts()));
                } catch (e) {
                 EasyLoading.showError('Error deleting Products');
                }


              }, child: Text('Yes')),
                ElevatedButton(style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.green.shade700)

            ),onPressed: (){
                  Navigator.of(context).pop();
                }, child: Text('No')),
              ],
            ));
          }, icon: Icon(Icons.delete,size: 30,)),
          Text('  '),
        ],
        title: Text('Product details'),
      ),
      body: Container(
        color: Colors.white,
              padding: const EdgeInsets.all(3.0),
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
                      '${widget.product['productname']}',
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
                    SizedBox(height: 8),

                    Text(
                      '${widget.product['productdescription']}',
                      style: TextStyle(fontSize: 16),
                    )

                  ],
              ),
      ),
    );
  }
}




class View_image extends StatelessWidget{
  var imageurl;
  View_image({required this.imageurl});
  @override
  Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.black,
    body: Center(
      child: InteractiveViewer(
          maxScale: 10,

          child: Image.network('${imageurl}')),
    ),
  );
  }
  
}








class Updateproduct extends StatefulWidget{
  var product;
  Updateproduct({required this.product});
  @override
  State<Updateproduct> createState() => _UpdateproductState();
}

class _UpdateproductState extends State<Updateproduct> {


  final productName_Controller = TextEditingController();

  final productPrice_Controller = TextEditingController();

  final productDescription_Controller = TextEditingController();

  final productquantity_Controller = TextEditingController();

  final product_category_Controller = TextEditingController();

  var active_color=Colors.grey,quantity_list;

  final List<Map<String, dynamic>> _categoryOptions = [
    {
      'value': 'Pesticides',
      'label': 'Pesticides',
    },

    {
      'value': 'Granuale',
      'label': 'Granuale',
    },
    {
      'value': 'Micronutrient',
      'label': 'Micronutrient',
    },
    {
      'value': 'Fertilizers',
      'label': 'Fertilizers',
    },
    {
      'value': 'Seeds',
      'label': 'Seeds',
    },
    {
      'value': 'Farming Tools',
      'label': 'Farming Tools',
    },
    {
      'value': 'Others',
      'label': 'Others',
    },
  ];


  final List<Map<String, dynamic>> _quantity_list_ml = [
    {
      'value': '250ml',
      'label': '250ml',
    },
    {
      'value': '100ml',
      'label': '100ml',
    },
    {
      'value': '400ml',
      'label': '400ml',
    },
    {
      'value': '800ml',
      'label': '800ml',
    },
    {
      'value': '5Liter',
      'label': '5Liter',
    },
    {
      'value': '50Liter',
      'label': '50Liter',
    },
  ];




  final List<Map<String, dynamic>> _quantity_list_grams_kg = [
    {
      'value': '50 Gram',
      'label': '50 Gram',
    },
    {
      'value': '100 Gram',
      'label': '100 Gram',
    },
    {
      'value': '200 Gram',
      'label': '200 Gram',
    },
    {
      'value': '250 Gram',
      'label': '250 Gram',
    },
    {
      'value': '500 Gram',
      'label': '500 Gram',
    },
    {
      'value': '800 Gram',
      'label': '800 Gram',
    },
    {
      'value': '1KG',
      'label': '1KG',
    },
    {
      'value': '5KG',
      'label': '5KG',
    },
    {
      'value': '20KG',
      'label': '20KG',
    },
    {
      'value': '40KG',
      'label': '40KG',
    },
  ];


  final List<Map<String, dynamic>> _quantity_list_others = [

    {
      'value': '50 Gram',
      'label': '50 Gram',
    },
    {
      'value': '50ml',
      'label': '50ml',
    },
    {
      'value': '100 Gram',
      'label': '100 Gram',
    },

    {
      'value': '100ml',
      'label': '100ml',
    },
    {
      'value': '200 Gram',
      'label': '200 Gram',
    },
    {
      'value': '200ml',
      'label': '200ml',
    },
    {
      'value': '800 Gram',
      'label': '800 Gram',
    },
    {
      'value': '800ml',
      'label': '800ml',
    },
    {
      'value': '5Liter',
      'label': '5Liter',
    },
    {
      'value': '50Liter',
      'label': '50Liter',
    },


    {
      'value': '500 Gram',
      'label': '500 Gram',
    },
    {
      'value': '800 Gram',
      'label': '800 Gram',
    },
    {
      'value': '1KG',
      'label': '1KG',
    },
    {
      'value': '5KG',
      'label': '5KG',
    },
    {
      'value': '20KG',
      'label': '20KG',
    },
    {
      'value': '40KG',
      'label': '40KG',
    },
    {
      'value': 'Other',
      'label': 'Other',
    },

  ];

  late String _selectedCategory='';

  var _image ;

  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
      maxHeight: 1920,
      maxWidth: 1080,
      imageQuality: 75,

    );

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);

      } else {
        EasyLoading.showInfo('No image selected');
      }
    });
  }

  @override
  void initState() {
    super.initState();
  product_category_Controller.text=widget.product['productcategory'];
  productquantity_Controller.text=widget.product['productquantity'];
  productDescription_Controller.text=widget.product['productdescription'];
  productPrice_Controller.text=widget.product['productprice'];
  productName_Controller.text=widget.product['productname'];
  if(widget.product['productcategory']=='Others' || widget.product['productcategory']=='Farming Tools' ){
    quantity_list=_quantity_list_others;
    return;
  }
  if(widget.product['productcategory']=='Fertilizers' || widget.product['productcategory']=='Seeds'){
    quantity_list=_quantity_list_grams_kg;

  }
  else{
    quantity_list=_quantity_list_ml;

  }
  

  }


  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.green.shade700,
        title: Text('Update Product'),
      ),
      body: Padding(
        padding:  EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Container(
              height: size.height*0.74,
              child: ListView(
                children: [
                  GestureDetector(
                    onTap: getImage,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                        image: _image == null
                            ? null
                            : DecorationImage(
                          image: FileImage(_image),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: _image == null
                          ? Image.network('${widget.product['image']}',fit: BoxFit.fill,)
                          : null,
                    ),
                  ),
                  Text(''),
                  TextFormField(
                    cursorColor: Colors.green,
                    controller: productName_Controller,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      hintText: 'Product Name',
                      hintStyle: TextStyle(color: Colors.grey),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green.shade700,width: 2),
                      ),
                      border:OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      focusColor: Colors.green,
                    ),
                  ),
                  Text(''),
                  SelectFormField(
                    controller: productquantity_Controller,
                    decoration: InputDecoration(
                      hintText: '500ml',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color:Colors.green.shade700,width: 2),
                      ),
                    ),
                    items: quantity_list,
                    onChanged: (val){setState(() {
                      quantity_list=val;
                    });},

                  ),
                  Text(''),

                  TextFormField(
                    cursorColor: Colors.green,
                    keyboardType: TextInputType.phone,
                    controller: productPrice_Controller,
                    inputFormatters: [  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),],
                    decoration: InputDecoration(
                      hintText: 'Price in R.s',
                      hintStyle: TextStyle(color: Colors.grey),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green.shade700,width: 2),
                      ),
                      border:OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      focusColor: Colors.green,
                    ),
                  ),
                  Text(''),
                  TextFormField(
                    cursorColor: Colors.green,
                    controller: productDescription_Controller,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      hintText: 'Product Description',
                      hintStyle: TextStyle(color: Colors.grey),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color:Colors.green.shade700,width: 2),
                      ),
                      border:OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      focusColor: Colors.green,
                    ),
                  ),
                  Text(''),
                  // SelectFormField(
                  //   controller: product_category_Controller,
                  //   decoration: InputDecoration(
                  //     hintText: 'Fertilizers',
                  //     border: OutlineInputBorder(),
                  //     focusedBorder: OutlineInputBorder(
                  //       borderSide: BorderSide(color:Colors.green.shade700,width: 2),
                  //     ),
                  //   ),
                  //   items: _categoryOptions,
                  //   onChanged: (val) {
                  //     setState(() {
                  //       _selectedCategory = val;
                  //       if(val=='Others' || val=='Farming Tools' ){
                  //         quantity_list=_quantity_list_others;
                  //         productquantity_Controller.clear();
                  //         return;
                  //       }
                  //       if(val=='Fertilizers' || val=='Seeds'){
                  //         quantity_list=_quantity_list_grams_kg;
                  //         productquantity_Controller.clear();
                  //       }
                  //       else{
                  //         quantity_list=_quantity_list_ml;
                  //         productquantity_Controller.clear();
                  //       }
                  //
                  //     });
                  //   },
                  //
                  // ),
                  SizedBox(height: 16.0),
                ],
              ),
            ),
            Container(
              width: size.width*0.8,
              child: ElevatedButton(
                style: ButtonStyle(backgroundColor:
                MaterialStateProperty.resolveWith((states) => Colors.green.shade700)),
                onPressed: () async {
                  var productid,licenseno;
                  SharedPreferences pref =await SharedPreferences.getInstance();
                  licenseno=await pref.getString("email");


                  if(productName_Controller.text.isEmpty){
                    EasyLoading.showInfo('Product name required!');
                    return;
                  }

                  if(productquantity_Controller.text.isEmpty){
                    EasyLoading.showInfo('Product quantity required!');
                    return;
                  }
                  if(productPrice_Controller.text.isEmpty){
                    EasyLoading.showInfo('Product price required!');
                    return;
                  }
                  if(productDescription_Controller.text.isEmpty){
                    EasyLoading.showInfo('Product description required!');
                    return;
                  }
                  if(product_category_Controller.text.isEmpty){
                    EasyLoading.showInfo('Product category required!');
                    return;
                  }
                  EasyLoading.show(status: 'Updating ...');
                  var Urll=widget.product['image'];
                  if(_image!=null){
                    try{
                      final storage = FirebaseStorage.instance;
                      final ref = storage.ref().child('products/${widget.product['companylicense']}/${widget.product['productcategory']}/${widget.product['productid']}');
                      ref.delete();
                      var storageref= FirebaseStorage.instance.ref().child('products/${widget.product['companylicense']}/${widget.product['productcategory']}/${widget.product['productid']}');
                      var a= new File(_image!.path);
                      var task=storageref.putFile(a as File);
                      TaskSnapshot storageTaskSnapshot = await task.whenComplete(() => null);
                      Urll = await storageTaskSnapshot.ref.getDownloadURL();
                      await FirebaseFirestore.instance.collection("products").get().then((querySnapshot) {
                        querySnapshot.docs.forEach((result) async {
                          if(result.data()['productid']==widget.product['productid'] && result.data()['companylicense']==
                              widget.product['companylicense']
                          ){

                            FirebaseFirestore.instance.collection("products").doc(result.id).update({
                              'productname':'${productName_Controller.text}',
                              'productprice':'${productPrice_Controller.text}',
                              'productdescription':'${productDescription_Controller.text}',
                              'productquantity':'${productquantity_Controller.text}',
                              'productcategory':'${product_category_Controller.text}',
                              'image':'${Urll}'
                            });
                          }

                        });
                      });
                      EasyLoading.showSuccess('Updated');
                      Navigator.push(context, Myroute(Allproducts()));
                      return;
                    }
                    catch(e){
                      EasyLoading.showError('Error updating product');
                    }

                  }

                  await FirebaseFirestore.instance.collection("products").get().then((querySnapshot) {
                    querySnapshot.docs.forEach((result) async {
                      if(result.data()['productid']==widget.product['productid'] && result.data()['companylicense']==
                          widget.product['companylicense']
                      ){

                        FirebaseFirestore.instance.collection("products").doc(result.id).update({
                          'productname':'${productName_Controller.text}',
                          'productprice':'${productPrice_Controller.text}',
                          'productdescription':'${productDescription_Controller.text}',
                          'productquantity':'${productquantity_Controller.text}',
                          'productcategory':'${product_category_Controller.text}',
                          'image':'${Urll}'
                        });
                      }

                    });
                  });
                  EasyLoading.showSuccess('Updated');
                  Navigator.push(context, Myroute(Allproducts()));




                },
                child: Text('Save Product',style: TextStyle(fontSize: 17),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}