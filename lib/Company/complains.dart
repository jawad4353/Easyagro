



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:select_form_field/select_form_field.dart';


class Company_complaints extends StatefulWidget {
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
         SizedBox(height: 10.0),
         TextFormField(
           controller: _subjectController,
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
           maxLines: 17,
           decoration: InputDecoration(
             labelText: 'Complain',
             border: OutlineInputBorder(),
           ),
         ),
         ElevatedButton(onPressed: (){}, child: Text('Submit'))
     ],
     ),
   ) ,
 );
  }
}
