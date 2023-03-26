

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyagro/Farmer/farmerlogin.dart';
import 'package:easyagro/splash.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_icons/weather_icons.dart';

import '../Database/database.dart';
import '../sharedpref_validations.dart';
import 'package:http/http.dart' as http;

import '../supportingwidgets.dart';
import 'calculator.dart';
import 'diseases.dart';











class farmerhome extends StatefulWidget{
  @override
  State<farmerhome> createState() => _farmerhomeState();
}

class _farmerhomeState extends State<farmerhome> {
  final pages=[farmerhome1(),calculator(),disease()];

  int myindex=0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: pages[myindex],

 bottomNavigationBar: BottomNavigationBar(
   currentIndex: myindex,
   elevation: 0,

   backgroundColor: Colors.white,
   selectedItemColor: Colors.green.shade700,
   onTap: (a){
       setState(() {
         myindex=a;
       });
   },
   items: [
       BottomNavigationBarItem(icon: Icon(Icons.home),label: 'Home'),
       BottomNavigationBarItem(icon: Icon(Icons.calculate),label: 'Calculators'),
       BottomNavigationBarItem(icon: Icon(Icons.coronavirus),label: 'Diseases'),
   ],
 ),
      ),
    );
  }
}




class farmerhome1 extends StatefulWidget{
  @override
  State<farmerhome1> createState() => _farmerhomeState1();
}

class _farmerhomeState1 extends State<farmerhome1> {

  var user_data=[];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final String apiKey = '9bf76e4fddf97812e3d9dae079b63770';
  final String apiUrl = 'https://api.openweathermap.org/data/2.5/weather?q=Lahore&appid=';

  String city = '';
  String description = '';
  String temperature = '';
  IconData iconData = WeatherIcons.cloud_refresh;

  File? _image;
  final picker = ImagePicker();

  Future getImageAndUploadToFirebase(photoname) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

   try{
     if (pickedFile != null) {
       setState(() {
         _image = File(pickedFile.path);
       });

       String fileName = _image!.path.split('/').last;
       Reference firebaseStorageRef =
       FirebaseStorage.instance.ref().child('farmerphotos/${photoname}');
       UploadTask uploadTask = firebaseStorageRef.putFile(_image!);
       TaskSnapshot storageTaskSnapshot1 = await uploadTask.whenComplete(() => null);
       String Url_profile_photo = await storageTaskSnapshot1.ref.getDownloadURL();
       await FirebaseFirestore.instance
           .collection('farmers')
           .doc(photoname)
           .update({'image': Url_profile_photo});




     } else {
       print('No image selected.');
     }
   }
   catch(e){}
  }

  Future<void> getWeather() async {
    var response = await http.get(Uri.parse(apiUrl + apiKey));
    var result = jsonDecode(response.body);
    setState(() {
      city = result['name'];
      description = result['weather'][0]['description'];
      temperature = (result['main']['temp'] - 273.15).toStringAsFixed(1) + ' °C';
       iconData=_getWeatherIcon(int.parse('${result['weather'][0]['id']}'));


    });
  }


 _getWeatherIcon(int weatherId) {

    if (weatherId > 200 && weatherId < 232) {
        iconData= WeatherIcons.thunderstorm;
    } else if (weatherId > 300 && weatherId < 321) {
      return WeatherIcons.rain_mix;
    } else if (weatherId > 500 && weatherId < 531) {
      return WeatherIcons.rain;
    } else if (weatherId > 600 && weatherId < 622) {
      return WeatherIcons.snow;
    } else if (weatherId > 701 && weatherId < 781) {

        return WeatherIcons.fog;

    } else if (weatherId == 800) {
      return WeatherIcons.day_sunny;
    } else if (weatherId == 801) {
      return WeatherIcons.day_cloudy;
    } else if (weatherId == 802) {
      return WeatherIcons.cloud;
    } else if (weatherId == 803 || weatherId == 804) {
      return WeatherIcons.cloudy;
    } else {
      return WeatherIcons.na;
    }
  }


  @override
  void initState() {
    super.initState();
    Get_current_farmer_details();
    getWeather();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(title: Text('Farmer Home'),
          leading: IconButton(icon:Icon(Icons.waves_outlined,color: Colors.grey,),onPressed: (){
            _scaffoldKey.currentState!.openDrawer();
          },),
          backgroundColor: Colors.transparent,elevation: 0,centerTitle: true,actions: [
          IconButton(onPressed:(){
            Clear_Preferences();
            EasyLoading.showSuccess('Logout');
            Navigator.pushReplacement(context, Myroute(farmerlogin()));
          }, icon: Icon(Icons.logout,color: Colors.grey,))
        ],),
        drawer: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topRight: Radius.elliptical(120, 800),bottomRight:Radius.elliptical(120, 800), ),
          ),
          child: Drawer(
            backgroundColor: Colors.white,
            child:  ListView(
                children: [
                  UserAccountsDrawerHeader(decoration: BoxDecoration(
                    color: Colors.green.shade700
                  ),accountName: user_data.isEmpty ?Text('') :Text('${user_data[0]}'), accountEmail:user_data.isEmpty ?Text(''): Text('${user_data[1]}'),
                  currentAccountPicture: StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('farmers').doc(user_data[1]).snapshots(),
                    builder:(context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return show_progress_indicator();
                      }

                      return snapshot.data!.data()!['image']==''? InkWell(
                        onTap: (){
                          getImageAndUploadToFirebase(user_data[1]);
                        },
                        child: Container(
                            height: 120,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(width: 2,color: Colors.black38),
                                shape: BoxShape.circle
                            ),
                            child: Center(child: Text('${user_data[0][0]}'.toUpperCase(),style: TextStyle(fontSize: 36),))),
                      ):
                      InkWell(
                        onTap: (){
                          Navigator.push(context, Myroute(ViewImage(email: user_data[1],)));
                        },
                        child:Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle
                            ),
                            child: Image.network('${snapshot.data!.data()!['image']}',fit: BoxFit.fill,)),
                      );




                    },
                  )
            ),




                 Row(children: [
                   TextButton.icon(style: ButtonStyle(
                     overlayColor: MaterialStateProperty.resolveWith((states) => Colors.transparent)
                   ),onPressed: (){
                     Clear_Preferences();
                     EasyLoading.showSuccess('Logout');
                     Navigator.pushReplacement(context, Myroute(farmerlogin()));
                   },icon: Icon(Icons.logout,color: Colors.green.shade900,),label: Text('Logout',style: TextStyle(color: Colors.black,fontSize: 17),),),

                 ],)

                ],
              ),
          ),

          ),
















        body:Center(
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Icon(
                  iconData,
                  size: 128,
                  color: Colors.green.shade700,
                ),
                Text('\n \n'),
                Text(
                  city,
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text(
                  description,
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(height: 20),
                Text(
                  temperature,
                  style: TextStyle(fontSize: 48),
                ),
              ],
            ),
          ),
        ) ,

      
    );
  }









  Get_current_farmer_details() async {
    var email;
    SharedPreferences pref =await SharedPreferences.getInstance();
    email=await pref.getString("email");

    await FirebaseFirestore.instance.collection("farmers").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        if(result.data()['email']==email){
          setState(() {
            user_data.add(result.data()['name']);
            user_data.add(result.data()['email']);
            user_data.add(result.data()['password']);
            user_data.add(result.data()['image']);
          });
        }

      });
    });

  }
}




class ViewImage extends StatefulWidget{
  var email;
  ViewImage({required this.email});

  @override
  State<ViewImage> createState() => _ViewImageState();
}

class _ViewImageState extends State<ViewImage> {
  @override
  Widget build(BuildContext context) {

   return Scaffold(
       backgroundColor: Colors.black,
     appBar: AppBar(backgroundColor: Colors.black,actions: [
       IconButton(onPressed: (){
         _farmerhomeState1().getImageAndUploadToFirebase(widget.email);
       }, icon: Icon(Icons.update)),
       IconButton(onPressed: (){
         Reference firebaseStorageRef =
         FirebaseStorage.instance.ref().child('farmerphotos/${widget.email}');
         firebaseStorageRef.delete();
         FirebaseFirestore.instance.collection('farmers').doc(widget.email).update({'image':''});
       }, icon: Icon(Icons.delete,color: Colors.white,)),

     ],),
     body: Center(
       child: InteractiveViewer(
           maxScale: 14,
           child: Container(
               height: 550,
               width: MediaQuery.of(context).size.width,
               child: StreamBuilder(
                 stream: FirebaseFirestore.instance.collection('farmers').doc(widget.email).snapshots(),
                 builder: (context,snap){

                   if(snap.connectionState==ConnectionState.waiting || !snap.hasData)
                     {
                       return show_progress_indicator();
                     }
                   return snap.data!.data()!['image']=='' ? Text('hi',style: TextStyle(color: Colors.white),)  : Image.network('${snap.data!.data()!['image']}',fit: BoxFit.fill,);
                 },
               ))),
     )
   );
  }
}












