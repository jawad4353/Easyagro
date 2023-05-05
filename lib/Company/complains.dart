



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:select_form_field/select_form_field.dart';


class Company_complaints extends StatefulWidget {
  var data;
  Company_complaints({required this.data});
  @override
  State<Company_complaints> createState() => _Company_complaintsState();
}

class _Company_complaintsState extends State<Company_complaints> {
  TextEditingController _subjectController = TextEditingController();
  TextEditingController _complainController = TextEditingController(text: 'Assalamoalikum !\n'
      'I am writing this as ... ');
  TextEditingController Complain_type_control=TextEditingController();
  String selected_type='';
  final List<Map<String, dynamic>> Options=[
    {
    'value': 'Complain about order',
    'label': 'Complain about order',
  },
    {
      'value': 'Complain about dealer',
      'label': 'Complain about dealer',
    },
    {
      'value': 'Complain about App',
      'label': 'Complain about App',
    },
    {
      'value': 'Others',
      'label': 'Others',
    },

  ];

  @override
  Widget build(BuildContext context) {
 return Scaffold(
   backgroundColor: Colors.white,
   appBar: AppBar(title: Text('Compaints'),),
   body:Padding(
     padding:  EdgeInsets.only(left: 10,right: 10),
     child: ListView(
       children: [
         SizedBox(height: 20.0),
         TextFormField(
           controller: _subjectController,
           keyboardType: TextInputType.name,
           decoration: InputDecoration(
             labelText: 'Subject',
             border: OutlineInputBorder(),
             focusedBorder: OutlineInputBorder(
               borderSide: BorderSide(color:Colors.green.shade700,width: 2),
             ),
           ),
         ),
         SizedBox(height: 10.0),
         SelectFormField(
             controller: Complain_type_control,
             decoration: InputDecoration(
               hintText: 'Complain about',
               border: OutlineInputBorder(),
               focusedBorder: OutlineInputBorder(
                 borderSide: BorderSide(color:Colors.green.shade700,width: 2),
               ),
             ),
             items:Options,
             onChanged: (val) {
               print(val);
               setState(() {
                selected_type=val;

               });
             } ),
         SizedBox(height: 10.0),
         TextFormField(
           controller: _complainController,
           keyboardType: TextInputType.name,
           maxLines: 17,
           decoration: InputDecoration(
             labelText: 'Complain',
             border: OutlineInputBorder(),
           ),
         ),
         ElevatedButton(onPressed: () async {
           if(_subjectController.text.isEmpty){
             EasyLoading.showInfo('Subject required !');
             return;
           }
           if(Complain_type_control.text.isEmpty){
             EasyLoading.showInfo('Select Complain about');
             return;
           }
           if(_complainController.text.replaceAll(' ', '').length<30){
             EasyLoading.showInfo('Write atleast 20 Words');
             return;
           }
          try{
             EasyLoading.show(status: 'Submitting');
            await FirebaseFirestore.instance.collection('complains').add({
              'subject':_subjectController.text,
              'about':Complain_type_control.text,
              'complain':_complainController.text,
              'from':'Company',
              'license':widget.data[4],
              'date':DateTime.now()
            });
            EasyLoading.showSuccess('Submitted');
          }
           catch(e){
             EasyLoading.showError('Not Submitted');
           }
           _subjectController.text='';
           Complain_type_control.text='';

         }, child: Text('Submit'))
     ],
     ),
   ) ,
 );
  }
}
