

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyagro/Farmer/farmerlogin.dart';
import 'package:easyagro/splash.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:proste_bezier_curve/proste_bezier_curve.dart';
import 'package:proste_bezier_curve/utils/type/index.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_icons/weather_icons.dart';

import '../Database/database.dart';
import '../selection.dart';
import '../sharedpref_validations.dart';
import 'package:http/http.dart' as http;

import '../supportingwidgets.dart';
import 'calculator.dart';
import 'diseases.dart';
import 'package:intl/intl.dart';

import 'location.dart';







class farmerhome extends StatefulWidget{
  @override
  State<farmerhome> createState() => _farmerhomeState();
}

class _farmerhomeState extends State<farmerhome> {
  final pages=[farmerhome1(),calculator(),watercalculator(),disease()];

  int myindex=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: pages[myindex],

 bottomNavigationBar: BottomNavigationBar(
   currentIndex: myindex,
   elevation: 0,


   backgroundColor: Colors.white,
   unselectedItemColor: Colors.black,
   selectedItemColor: Colors.green.shade700,

   onTap: (a){
       setState(() {
         myindex=a;
       });
   },
   items: [
       BottomNavigationBarItem(icon: Icon(Icons.home),label: 'Home'),
       BottomNavigationBarItem(icon: Icon(Icons.calculate),label: 'Fertilizers Calculator'),
       BottomNavigationBarItem(icon: Icon(Icons.calculate),label: 'Water Calculator'),
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


  String city = '',description = '',temperature = '',pressure='',wind='',humidity='',winddegree='',feelslike='',
  precipitation='',rainchances='',date='',visibility='';
  var sunrise,sunset,email,rainforcats=[],temperatureforcast=[];

 late IconData iconData= WeatherIcons.na ;
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('dd MMMM ');
  final DateFormat formattersun = DateFormat('HH:MM a ');



  File? _image;
  final picker = ImagePicker();
  var s;

  Future getImageAndUploadToFirebase(photoname) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

   try{
     if (pickedFile != null) {
         _image = File(pickedFile.path);
       String fileName = _image!.path.split('/').last;
       Reference firebaseStorageRef =
       FirebaseStorage.instance.ref().child('farmerphotos/${photoname}');
       UploadTask uploadTask = firebaseStorageRef.putFile(_image!);
       TaskSnapshot storageTaskSnapshot1 = await uploadTask.whenComplete(() => null);
       String Url_profile_photo = await storageTaskSnapshot1.ref.getDownloadURL();
       print('here');
       await FirebaseFirestore.instance
           .collection('farmers').doc(photoname).update({'image': Url_profile_photo});
     } else {
       print('No image selected.');
     }
   }
   catch(e){
     print(e);
   }
  }


  Future<void> getWeather(cityi) async {

    s=await fetchLocation();
    if(s==''){
      cityi='Lahore';
    }
    s=s.split(',');
    print(s);
    final String apiUrl_city = 'https://api.openweathermap.org/data/2.5/weather?q=Lahore&appid=';
    var response,result;
    if(cityi=='no'){
       try{
         final url_long_lat = 'https://api.openweathermap.org/data/2.5/weather?lat=${s[0]}&lon=${s[1]}&units=metric&appid=';
         response = await http.get(Uri.parse(url_long_lat + apiKey));
         result = jsonDecode(response.body);
       }
       catch(e){
         print(e);
       }
    }
    else{
       try{
         response = await http.get(Uri.parse(apiUrl_city+ apiKey));
         result = jsonDecode(response.body);
       }
       catch(e){
         print(e);
       }
    }


    print(result);

    setState(() {
       sunrise = DateTime.fromMillisecondsSinceEpoch(
          result['sys']['sunrise'] * 1000);
       sunset = DateTime.fromMillisecondsSinceEpoch(
          result['sys']['sunset'] * 1000);
       sunrise=formattersun.format(sunrise);
       sunset=formattersun.format(sunset);

      date = formatter.format(now);
      city = result['name'];
      rainchances='${result['clouds']['all']}'+' %';
      visibility='${result['visibility']/1000} KM';
      description = result['weather'][0]['description'];
      temperature = (result['main']['temp'] - 273.15).toStringAsFixed(1) + ' °C';
      pressure='${result['main']['pressure']}'+' N/m';
      humidity='${result['main']['humidity']}'+' %';
      wind='${result['wind']['speed']}'+' km/s';
      winddegree='${result['wind']['deg']}'+' deg';
      feelslike=(result['main']['feels_like'] - 273.15).toStringAsFixed(1) + ' °C';
      precipitation='${30+Random().nextInt(70)} %';
       iconData=_getWeatherIcon(int.parse('${result['weather'][0]['id']}'));

       rainforcats.add('${20+Random().nextInt(60)} %');
       rainforcats.add('${20+Random().nextInt(60)} %');
       rainforcats.add('${20+Random().nextInt(60)} %');

       var d=(result['main']['temp']-273).toInt();
       temperatureforcast.add('${((d-5)+Random().nextInt(d-(d-5)))}');
       temperatureforcast.add('${((d-5)+Random().nextInt(d-(d-5)))}');
       temperatureforcast.add('${((d-5)+Random().nextInt(d-(d-5)))}');

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
    Get_current_farmer_details();
    getWeather('no');
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;

    return Scaffold(
        key: _scaffoldKey,

        backgroundColor: Colors.white,

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
                    stream: FirebaseFirestore.instance.collection('farmers').doc(email).snapshots(),
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
                     new GoogleSignInHelper().signOutGoogle();
                     EasyLoading.showSuccess('Logout');
                     Navigator.pushReplacement(context, Myroute(farmerlogin()));
                   },icon: Icon(Icons.logout,color: Colors.green.shade900,),label: Text('Logout',style: TextStyle(color: Colors.black,fontSize: 17),),),

                 ],)

                ],
              ),
          ),

          ),
















        body:ListView(
          children: [
       Stack(
         children: [
             Container(height: size.height*0.18,),
           ClipPath(
             clipper: ProsteBezierCurve(
               position: ClipPosition.bottom,
               list: [
                 BezierCurveSection(
                   start: Offset(0, 166),
                   top: Offset(size.width / 4, 190),
                   end: Offset(size.width / 2, 155),
                 ),
                 BezierCurveSection(
                   start: Offset(size.width / 2, 25),
                   top: Offset(size.width / 4 * 3, 160),
                   end: Offset(size.width, 180),
                 ),
               ],
             ),
             child: Container(
               height: size.height*0.25,
               width: size.width,
               color: Colors.green.shade900,
               child: Opacity(opacity: 0.2,child: Image.asset('images/back.jpg',fit: BoxFit.cover,),),
             ),
           ),
           Positioned(
             left: 0,
             top: 0,
             child: IconButton(icon:Icon(Icons.waves_sharp,color: Colors.white,),onPressed: (){
               _scaffoldKey.currentState!.openDrawer();
             },),
           ),
           Positioned(
             left: 5,
             top: 80,
             child:Column(children: [
               Text(
                 ' ${city}',
                 style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold,color: Colors.white),
               ),
               Text(
                 ' ${temperature}',

                 style: TextStyle(fontSize: 24,color: Colors.white),
               ),
             ],),
           ),
           Positioned(
               right: 0,
               top: 0,
               child: IconButton(onPressed: (){}, icon: Icon(Icons.search,color: Colors.white,))),
           Positioned(
             right: 10,
             top: 30,
             child: Column(children: [

               Icon(
                 iconData,size: 50,color: Colors.white,
               ),

               Text(
                 description=='' ? '':'\n${description[0]}'.toUpperCase()+'${description.substring(1)}',
                 style: TextStyle(fontSize: 24,color: Colors.white),
               ),
               Text(
                 '$date',
                 style: TextStyle(fontSize: 17,color: Colors.white),
               )


             ],),
           ),



         ],
       ),
         Text(' Now ',style: TextStyle(fontSize: 22,fontWeight: FontWeight.w600),)
           ,


            Container(
              height: 300,
              child: GridView(
                gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio:size.width / 100,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10
                ),
                children: [
                  ListTile(
                    title: Text('FeelLike'),
                    subtitle: Text('$feelslike',style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.w600,)),
                    leading: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.green.shade700,
                          shape: BoxShape.circle
                      ),child:Text("C°",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),),
                  ),
                  ListTile(
                    title: Text('Pressure'),
                    subtitle: Text('$pressure',style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.w600,)),
                    leading: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.green.shade700,
                          shape: BoxShape.circle
                      ),child:Icon(Icons.hourglass_bottom,color: Colors.white),),
                  ),
                  ListTile(
                    title: Text('Wind'),
                    subtitle: Text('$wind ',style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.w600,)),
                    leading: Container(
                      padding: EdgeInsets.only(bottom: 16,left: 10,right: 10),
                      decoration: BoxDecoration(
                          color: Colors.green.shade700,
                          shape: BoxShape.circle
                      ),child: Icon(WeatherIcons.wind,color: Colors.white,size: 27,)),
                  ),
                  ListTile(
                    title: Text('Direction'),
                    subtitle: Text('$winddegree ',style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.w600,)),
                    leading: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.green.shade700,
                          shape: BoxShape.circle
                      ),child:Icon(Icons.text_rotation_angledown_outlined,color: Colors.white),),
                  ),
                  ListTile(
                    title: Text('Precipitation'),
                    subtitle: Text('$precipitation',style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.w600,)),
                    leading: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.green.shade700,
                          shape: BoxShape.circle
                      ),child: Icon(Icons.umbrella,color: Colors.white),),
                  ),
                  ListTile(
                    title: Text('Humidity'),
                    subtitle: Text('$humidity',style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.w600,)),
                    leading: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.green.shade700,
                          shape: BoxShape.circle
                      ),child: Icon(Icons.wb_cloudy_outlined,color: Colors.white),),
                  ),
                  ListTile(
                    title: Text('Rain chances'),
                    subtitle: Text('$rainchances',style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.w600,)),
                    leading: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.green.shade700,
                          shape: BoxShape.circle
                      ),child: Icon(WeatherIcons.rain,color: Colors.white,),),
                  ),
                  ListTile(
                    title: Text('Visibility'),
                    subtitle: Text('$visibility',style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.w600,)),
                    leading: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.green.shade700,
                          shape: BoxShape.circle
                      ),child: Icon(Icons.remove_red_eye,color: Colors.white),),
                  ),
                  ListTile(
                    title: Text('Sunrise'),
                    subtitle: Text(sunrise==null ? '':'$sunrise',style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.w600,)),
                    leading: Container(
                      padding: EdgeInsets.only(bottom: 14,left: 10,right: 10),
                      decoration: BoxDecoration(
                          color: Colors.green.shade700,
                          shape: BoxShape.circle
                      ),child: Icon(WeatherIcons.sunrise,color: Colors.white,size: 28,),),
                  ),
                  ListTile(
                    title: Text('Sunset'),
                    subtitle: Text(sunset==null ? '':'$sunset',style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.w600,)),
                    leading: Container(
                      padding: EdgeInsets.only(bottom: 14,left: 10,right: 10),
                      decoration: BoxDecoration(
                          color: Colors.green.shade700,
                          shape: BoxShape.circle
                      ),child: Icon(WeatherIcons.sunset,color: Colors.white,),),
                  ),
                ],
              ),
            ),





            Text('\n Forcast ',style: TextStyle(fontSize: 22,fontWeight: FontWeight.w600),),

            Padding(
              padding: const EdgeInsets.only(left: 5,right:10 ),
              child: ListTile(title: Text('${formatter.format(now.add(Duration(days: 1)))}'),
              subtitle: Row(children: [Icon(WeatherIcons.rain_mix,color: Colors.green),Text(rainforcats.isEmpty? '':'  ${rainforcats[0]}',style: TextStyle(fontSize: 17,fontWeight: FontWeight.w400),)],),
              trailing: Text(temperatureforcast.isEmpty?'':' ${temperatureforcast[0]} C°',style:  TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.w600,),),),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5,right:10 ),
              child: ListTile(title: Text('${formatter.format(now.add(Duration(days: 2)))}'),
                subtitle: Row(children: [Icon(WeatherIcons.rain_mix,color: Colors.green),Text(rainforcats.isEmpty? '':'  ${rainforcats[1]}',style: TextStyle(fontSize: 17,fontWeight: FontWeight.w400),)],),
                trailing: Text(temperatureforcast.isEmpty?'':' ${temperatureforcast[1]} C°',style:  TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.w600,),),),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5,right:10 ),
              child: ListTile(title: Text('${formatter.format(now.add(Duration(days: 3)))}'),
                subtitle:  Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [Icon(WeatherIcons.rain_mix,color: Colors.green),Text(rainforcats.isEmpty? '':'  ${rainforcats[2]}',style: TextStyle(fontSize: 17,fontWeight: FontWeight.w400),)],),
                trailing: Text(temperatureforcast.isEmpty?'':' ${temperatureforcast[2]} C°',style:  TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.w600,),),),
            )


             ],
           )

      
    );
  }









  Get_current_farmer_details() async {

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
                   return snap.data!.data()!['image']=='' ? Container(height: 400,color: Colors.green.shade700,
                   child: Center(child: Text('${snap.data!.data()!['name']}'.toUpperCase(),style: TextStyle(fontSize: 34,fontWeight: FontWeight.bold,color: Colors.white),)),)

                       : Image.network('${snap.data!.data()!['image']}',fit: BoxFit.fill,);
                 },
               ))),
     )
   );
  }
}












