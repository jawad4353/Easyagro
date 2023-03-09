import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyagro/sharedpref_validations.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddProductsPage extends StatefulWidget {
  @override
  _AddProductsPageState createState() => _AddProductsPageState();
}

class _AddProductsPageState extends State<AddProductsPage> {
  final productName_Controller = TextEditingController();
  final productPrice_Controller = TextEditingController();
  final productDescription_Controller = TextEditingController();
  final productquantity_Controller = TextEditingController();
  final product_category_Controller = TextEditingController();
  var active_color=Colors.grey;

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
  ];
  final List<Map<String, dynamic>> _quantity_list = [
    {
      'value': '250ml',
      'label': '250ml',
    },
    {
      'value': '500ml',
      'label': '500ml',
    },
    {
      'value': '1Litre',
      'label': '1Litre',
    },
    {
      'value': '5 Litre',
      'label': '5 Litre',
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
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.green.shade700,
        title: Text('Add Products'),
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
                      ? Center(child: Text('Tap to add image'))
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
                items: _quantity_list,
                onChanged: (val) => setState(() => _selectedCategory = val),

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
              SelectFormField(
                controller: product_category_Controller,
                decoration: InputDecoration(
                  hintText: 'Fertilizers',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color:Colors.green.shade700,width: 2),
                  ),
                ),
                items: _categoryOptions,
                onChanged: (val) => setState(() => _selectedCategory = val),

              ),
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
                  productid=getUniqueProductID();

                    if(_image==null){
                      EasyLoading.showInfo('Product image required!');
                      return;
                    }
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
                    FirebaseStorage _storage=FirebaseStorage.instance;
                    var storageref=_storage.ref("products/${licenseno}/${product_category_Controller.text}/${productid}");
                  var a= new File(_image!.path);
                  try{
                    var task=storageref.putFile(a as File);
                    FirebaseFirestore.instance.collection('products').add({
                      'productid':'${productid}',
                      'productname':'${productName_Controller.text}',
                      'productprice':'${productPrice_Controller.text}',
                      'productdescription':'${productDescription_Controller.text}',
                      'productquantity':'${productquantity_Controller.text}',
                      'productcategory':'${product_category_Controller.text}',
                      'companylicense':'${licenseno}'

                    });
                    EasyLoading.showSuccess('Product added Sucessfully');
                  }
                  catch(e){
                    var s='${e}'.split(']');
                    EasyLoading.showError('Error Adding Product:${s[1]}');
                    return;
                  }

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
