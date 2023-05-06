



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyagro/splash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:select_form_field/select_form_field.dart';

import '../sharedpref_validations.dart';
import '../supportingwidgets.dart';


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
   appBar: AppBar(title: Text('Submit Compaints'),actions: [
     IconButton(onPressed: (){
       Navigator.push(context, Myroute(View_Previous_complains(license: widget.data[4],type: 'Company',)));
     }, icon: Icon(Icons.report))
   ],),
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
              'date':'${DateTime.now()}',
              'status':'Pending',
              'complainid':'${getUnique_ComplainID()}'
            });
            EasyLoading.showSuccess('Submitted');
          }
           catch(e){
             EasyLoading.showError('Not Submitted');
           }
           _subjectController.text='';


         }, child: Text('Submit'))
     ],
     ),
   ) ,
 );
  }
}

class View_Previous_complains extends StatefulWidget{
  var license,type;
  View_Previous_complains({required this.license,required this.type});
  @override
  State<View_Previous_complains> createState() => _View_Previous_complainsState();
}

class _View_Previous_complainsState extends State<View_Previous_complains> {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(title: Text('Previous Complains'),),
     body: StreamBuilder(
       stream: FirebaseFirestore.instance.collection('complains').where('license', isEqualTo: '${widget.license}').where('from', isEqualTo: '${widget.type}').snapshots(),
    builder: (context, snapshot) {

    if (!snapshot.hasData) {
    return show_progress_indicator();
    }

    var data=snapshot.data!.docs;
    return ListView.builder(
      itemCount: data.length,
    itemBuilder: (context,index){
        var short_subject='${data[index]['subject']}'.length<39 ? data[index]['subject']:'${data[index]['subject']}'.substring(0,39)+'..';
        var short_about='${data[index]['about']}'.toUpperCase().split(' ');
     return Container(
       padding: const EdgeInsets.all(6.0),
       decoration: BoxDecoration(
         border: Border.all(color: Colors.black12)
       ),
       child: ListTile(
         onTap: (){},
         title:Text('$short_subject',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),) ,
         subtitle: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
            Text('Status : ${data[index]['status']}',style: TextStyle(fontSize: 16),),
             Text('About : ${short_about[2]}',style: TextStyle(fontSize: 16),),
           Text('Date : ${data[index]['date']}'.substring(0,17),style: TextStyle(fontSize: 16),),
           Text('${data[index]['complainid']}',style: TextStyle(fontSize: 16),),
         ],),
         trailing: ElevatedButton.icon(onPressed: () async {
           try{
             EasyLoading.show(status: 'Closing');
             var s=await FirebaseFirestore.instance.collection('complains').where('complainid',isEqualTo: '${data[index]['complainid']}').limit(1).get();
             await FirebaseFirestore.instance.collection('complains').doc(s.docs.single.id).delete();
            EasyLoading.showSuccess('Closed');
           }
           catch(e){
             EasyLoading.showError('Error');
           }

         }, icon: Icon(Icons.clear), label: Text('Close')),
       ),
     );
    }
    );
    })
   );
  }
}
