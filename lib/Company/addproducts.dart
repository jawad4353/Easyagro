import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:select_form_field/select_form_field.dart';

class AddProductsPage extends StatefulWidget {
  @override
  _AddProductsPageState createState() => _AddProductsPageState();
}

class _AddProductsPageState extends State<AddProductsPage> {
  final _productNameController = TextEditingController();
  final _productPriceController = TextEditingController();
  final _productDescriptionController = TextEditingController();
  var active_color=Colors.grey;

  final List<Map<String, dynamic>> _categoryOptions = [
    {
      'value': 'Fertilizers',
      'label': 'Fertilizers',
    },
    {
      'value': 'Pesticides',
      'label': 'Pesticides',
    },
    {
      'value': 'Drops',
      'label': 'Drops',
    },
    {
      'value': 'Spray',
      'label': 'Spray',
    },
  ];

  late String _selectedCategory='';

  var _image ;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);

      } else {
        print('No image selected.');
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.green.shade700,
        title: Text('Add Products'),
      ),
      body: Padding(
        padding:  EdgeInsets.all(16.0),
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
            TextFormField(
              cursorColor: Colors.green,
              decoration: InputDecoration(
                hintText: 'Product Price',
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
              decoration: InputDecoration(
             hintText: 'Fertilizers',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color:Colors.green.shade700,width: 2),
                ),
              ),
              items: _categoryOptions,
              onChanged: (val) => setState(() => _selectedCategory = val),
              initialValue: _selectedCategory,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              style: ButtonStyle(backgroundColor: 
              MaterialStateProperty.resolveWith((states) => Colors.green.shade700)),
              onPressed: () {

              },
              child: Text('Save Product',style: TextStyle(fontSize: 17),),
            ),
          ],
        ),
      ),
    );
  }
}
