import 'package:easyagro/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'Company/Notifiers.dart';

import 'Company/products.dart';
import 'Database/database.dart';




Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
await  Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyDtXYijb9Bwbf24hZZennLwMrIqGIYVRqs",
        appId:  "1:730243418927:android:4bf33755db45595c5cefda",
        messagingSenderId: '730243418927',
        projectId: "easyagro-ed808",
      storageBucket: 'easyagro-ed808.appspot.com'

    )
);

  runApp(MultiProvider(
      providers: [
            ChangeNotifierProvider(create: (context) => GlobalState(),)
          ],
      child: MyApp()));
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return   MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Splashscreen(),
          builder: EasyLoading.init(),

    );
  }

}

