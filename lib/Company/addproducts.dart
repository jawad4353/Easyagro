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
                controller: product_category_Controller,
                decoration: InputDecoration(
                  hintText: 'Fertilizers',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color:Colors.green.shade700,width: 2),
                  ),
                ),
                items: _categoryOptions,
                onChanged: (val) {
                  setState(() {
                    _selectedCategory = val;
                    if(val=='Others' || val=='Farming Tools' ){
                      quantity_list=_quantity_list_others;
                      productquantity_Controller.clear();
                      return;
                    }
                    if(val=='Fertilizers' || val=='Seeds'){
                      quantity_list=_quantity_list_grams_kg;
                      productquantity_Controller.clear();
                    }
                    else{
                      quantity_list=_quantity_list_ml;
                      productquantity_Controller.clear();
                    }

                  });
                } ),



              Text(''),
              SelectFormField(
                controller: productquantity_Controller,
                decoration: InputDecoration(
                  hintText: 'Quantity',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color:Colors.green.shade700,width: 2),
                  ),
                ),
                items: quantity_list,
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
                    var pd=productDescription_Controller.text.replaceAll(' ','');
                  if(pd.length<50){
                    EasyLoading.showInfo('Product description must have 50 characters!');
                    return;
                  }
                    if(product_category_Controller.text.isEmpty){
                      EasyLoading.showInfo('Product category required!');
                      return;
                    }
                  EasyLoading.show(status: 'Processing...',dismissOnTap: false);
                    FirebaseStorage _storage=FirebaseStorage.instance;
                    var storageref=_storage.ref("products/${licenseno}/${product_category_Controller.text}/${productid}");
                  var a= new File(_image!.path);
                  try{
                    var task=storageref.putFile(a as File);
                    TaskSnapshot storageTaskSnapshot = await task.whenComplete(() => null);
                    String Urll = await storageTaskSnapshot.ref.getDownloadURL();
                    FirebaseFirestore.instance.collection('products').add({
                      'productid':'${productid}',
                      'productname':'${productName_Controller.text}',
                      'productprice':'${productPrice_Controller.text}',
                      'productdescription':'${productDescription_Controller.text}',
                      'productquantity':'${productquantity_Controller.text}',
                      'productcategory':'${product_category_Controller.text}',
                      'companylicense':'${licenseno}',
                      'image':'${Urll}'

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
