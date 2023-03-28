
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:select_form_field/select_form_field.dart';


class calculator extends StatefulWidget{
  @override
  State<calculator> createState() => _calculatorState();
}

class _calculatorState extends State<calculator> {

  var _selectedLandQuantity,_selectedSoilType,soiltypecolor=Colors.grey,soilquantitycolor=Colors.grey;
  final TextEditingController _soilTypeController = TextEditingController();
  final TextEditingController _unitcontroller = TextEditingController();
  final TextEditingController _landquantitycontroller = TextEditingController();

  final List<Map<String, dynamic>> _soilTypeOptions = [
    {'value': 'Loamy', 'label': 'Loamy'},
    {'value': 'Sandy', 'label': 'Sandy'},
    {'value': 'Clay', 'label': 'Clay'},
    {'value': 'Silt', 'label': 'Silt'},  ];

  final List<Map<String, dynamic>> _units = [
    {'value': 'Marla', 'label': 'Marla'},
    {'value': 'Kanal', 'label': 'Kanal'},
    {'value': 'Acres', 'label': 'Acres'},         ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text('Fertilizer Calculator'),backgroundColor: Colors.green.shade700,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SelectFormField(
              controller: _soilTypeController,
              style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green,width: 2),
                ),
                labelText: 'Soil Type',

              labelStyle: TextStyle(color:soiltypecolor)
              ),
              items: _soilTypeOptions,
              onChanged: (val) => setState(() {
                _selectedSoilType = val;
                soiltypecolor=Colors.green;
              }),
              onSaved: (val) => setState((){
                _selectedSoilType = val;
                soiltypecolor=Colors.green;
              }),
            ),
            SizedBox(height: 16.0),
            SelectFormField(
              style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400),
              controller: _unitcontroller,
              decoration: InputDecoration(
    labelStyle: TextStyle(color: soilquantitycolor),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green,),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green,width: 2),
                ),
                labelText: 'Unit',
              ),
              items: _units,
              onChanged: (val) => setState((){
                _selectedLandQuantity = val;
                soilquantitycolor=Colors.green;
              }),
              onSaved: (val) => setState(() {
                _selectedLandQuantity = val;
                soilquantitycolor=Colors.green;
              }),
            ),
            SizedBox(height: 16.0),
            TextField(
              cursorColor: Colors.green.shade700,
              cursorWidth: 2,
              controller: _landquantitycontroller,
              style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400),
              keyboardType: TextInputType.phone,
              inputFormatters: [  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),],
              decoration: InputDecoration(

                hintText: 'Land Quatity',
                labelStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
              ),

            ),

            SizedBox(height: 16.0),
            ElevatedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2))
              ),
              child: Text('Calculate'),
              onPressed: () {
                // Submit button action goes here
              },
            ),
          ],
        ),
      ),
    );
  }
}










class watercalculator extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('water calculator')),
    );
  }

}







