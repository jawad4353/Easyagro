
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:select_form_field/select_form_field.dart';

import '../supportingwidgets.dart';


class calculator extends StatefulWidget{
  @override
  State<calculator> createState() => _calculatorState();
}

class _calculatorState extends State<calculator> {

  var  _selectedLandQuantity, _selectedSoilType , _selectedcrop, Calculated_fertilizer_string='',
      Data_list=['','','','','','','','',''];
  final TextEditingController _soilTypeController = TextEditingController();
  final TextEditingController _cropController = TextEditingController();
  final TextEditingController _unitcontroller = TextEditingController();
  final TextEditingController _landquantitycontroller = TextEditingController();

  final List<Map<String, dynamic>> _soilTypeOptions = [
    {'value': 'Loamy', 'label': 'Loamy'},
    {'value': 'Sandy', 'label': 'Sandy'},
    {'value': 'Clay', 'label': 'Clay'},
    {'value': 'Silt', 'label': 'Silt'},  ];

   List<Map<String, dynamic>> _crops = []  ;

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
        child: SingleChildScrollView(
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

                ),
                items: _soilTypeOptions,
                onChanged: (val) => setState(() {
                  _selectedSoilType = val;

                }),
                onSaved: (val) => setState((){
                  _selectedSoilType = val;

                }),
              ),
              SizedBox(height: 16.0),
             StreamBuilder(
                 stream: FirebaseFirestore.instance.collection('cropname').snapshots(),
                 builder: (context,snap){

               if (!snap.hasData) {
                 return show_progress_indicator();
               }

               var ss = snap.data!.docs.map((doc) => doc['name']).toList();
               _crops.clear();
               for(int i=0;i<ss.length;i++){
                 _crops.add({'value': '${ss[i]}', 'label': '${ss[i]}'});
               }


               return  snap.data!.docs.length==0 ? Column(children: [
                 Icon(Icons.no_drinks),
                 Text('No Crops ')
               ],) : SelectFormField(
                 style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400),
                 controller: _cropController,
                 decoration: InputDecoration(
                   border: OutlineInputBorder(
                     borderSide: BorderSide(color: Colors.green,),
                   ),
                   focusedBorder: OutlineInputBorder(
                     borderSide: BorderSide(color: Colors.green,width: 2),
                   ),
                   labelText: 'Crops',
                 ),
                 items: _crops,
                 onChanged: (val) => setState((){
                   _selectedcrop=val;

                 }),
                 onSaved: (val) => setState(() {
                   _selectedcrop=val;

                 }),
               );
             }),
              SizedBox(height: 16.0),
              SelectFormField(
                style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400),
                controller: _unitcontroller,
                decoration: InputDecoration(

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

                }),
                onSaved: (val) => setState(() {
                  _selectedLandQuantity = val;

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
                 if(_soilTypeController.text.isEmpty){
                   EasyLoading.showInfo('Select soil type !');
                   return;
                 }
                 if(_cropController.text.isEmpty){
                   EasyLoading.showInfo('Select crop !');
                   return;
                 }
                 if(_unitcontroller.text.isEmpty){
                   EasyLoading.showInfo('Select Area unit !');
                   return;
                 }
                 if(_landquantitycontroller.text.isEmpty){
                   EasyLoading.showInfo('Enter Land Area!');
                   return;
                 }


                 Calculate_fertilizer();





                },
              ),
              RichText(
               text: TextSpan(
                 text: '\n${Data_list[0]}',
                 style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16, color: Colors.black),
               children: [
                 TextSpan(
                   text: Data_list[1],
                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                 ),
                 TextSpan(
                   text: Data_list[2],
                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                 ),
                 TextSpan(
                   text: Data_list[3],
                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                 ),
                 TextSpan(
                   text: Data_list[4],
                 ),
                 TextSpan(
                   text:Data_list[5],
                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                 ),
                 TextSpan(
                   text:Data_list[6],
                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                 ),
                 TextSpan(
                   text: Data_list[7],
                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                 ),
                 TextSpan(
                   text: Data_list[8],
                 ),


               ]
               ),

              ),

            ],
          ),
        ),
      ),
    );
  }

  Calculate_fertilizer() async {
   late double total_nitrogen,Urea,total_phosphorus,DAP,total_potash,Potash;

  try {
    EasyLoading.show(status: 'processing');
    var result = await FirebaseFirestore.instance.collection('crops').doc(
        '${_soilTypeController.text}+${_cropController.text}').get();


    if (_unitcontroller.text == 'Marla') {
      total_nitrogen = double.parse(result.data()!['nitrogen']) *
          Marla_to_Acre(_landquantitycontroller.text);
      Urea = (total_nitrogen * 0.46);
      total_phosphorus = (double.parse(result.data()!['phosphorus']) *
          Marla_to_Acre(_landquantitycontroller.text));
      DAP = (total_phosphorus * 0.46);
      total_potash = (double.parse(result.data()!['potassium']) *
          Marla_to_Acre(_landquantitycontroller.text));
      Potash = (total_potash * 0.6);
      Message_updater(
          total_nitrogen, total_phosphorus, total_potash, Urea, DAP, Potash);
    }
    if (_unitcontroller.text == 'Kanal') {
      total_nitrogen = double.parse(result.data()!['nitrogen']) *
          kanal_to_Acre(_landquantitycontroller.text);
      Urea = (total_nitrogen * 0.46);
      total_phosphorus = (double.parse(result.data()!['phosphorus']) *
          kanal_to_Acre(_landquantitycontroller.text));
      DAP = (total_phosphorus * 0.46);
      total_potash = (double.parse(result.data()!['potassium']) *
          kanal_to_Acre(_landquantitycontroller.text));
      Potash = (total_potash * 0.6);
      Message_updater(
          total_nitrogen, total_phosphorus, total_potash, Urea, DAP, Potash);
    }
    if (_unitcontroller.text == 'Acres') {
      total_nitrogen = double.parse(result.data()!['nitrogen']) *
          double.parse(_landquantitycontroller.text);
      Urea = (total_nitrogen * 0.46);
      total_phosphorus = (double.parse(result.data()!['phosphorus']) *
          double.parse(_landquantitycontroller.text));
      DAP = (total_phosphorus * 0.46);
      total_potash = (double.parse(result.data()!['potassium']) *
          double.parse(_landquantitycontroller.text));
      Potash = (total_potash * 0.6);
      Message_updater(
          total_nitrogen, total_phosphorus, total_potash, Urea, DAP, Potash);
    }
    EasyLoading.dismiss();
  }
  catch(e){
    EasyLoading.showError('Data not found for \nSoil : ${_soilTypeController.text} , Crop : ${_cropController.text} ');
    return;
  }

  }

  Marla_to_Acre(marla){
   return  double.parse(marla)/160;

  }

 kanal_to_Acre(kanal){
   return  double.parse(kanal)/8;
  }

  Message_updater(total_nitrogen,total_phosphorus,total_potash,Urea,DAP,Potash){
    setState(() {
      Data_list[0]='As you have told that total land is ${_landquantitycontroller.text} ${_unitcontroller.text} and soil type is ${_soilTypeController.text}. So '
          'the amount of fertilizers required for your crop (${_cropController.text}) is : ';
      Data_list[1]='\n\nTotal Nitrogen   : ${total_nitrogen.toStringAsFixed(2)} kg';
      Data_list[2]='\nTotal Phosphorus : ${total_phosphorus.toStringAsFixed(2)} kg';
      Data_list[3]='\nTotal Potash     : ${total_potash.toStringAsFixed(2)} kg';
      Data_list[4]='\n\nSo If you distribute the amount of Nitrogen , Phosphorus and Potassium in three fertilizers Urea , DAP ,Potash you will need';
      Data_list[5]='\n\nTotal Urea   : ${Urea.toStringAsFixed(2)} kg';
      Data_list[6]='\nTotal DAP    : ${DAP.toStringAsFixed(2)} kg';
      Data_list[7]='\nTotal Potash : ${Potash.toStringAsFixed(2)} kg';
      Data_list[8]='\n\nThese are the required quantities of fertilizers for your crop';

    });

  }

}

















