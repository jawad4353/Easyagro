

import 'package:easyagro/supportingwidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class diseases extends StatefulWidget {
  @override
  State<diseases> createState() => _diseasesState();
}

class _diseasesState extends State<diseases> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('Active Diseases'),centerTitle: true,),
      body: Padding(
        padding: EdgeInsets.only(left: 10,right: 10,top: 5),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('diseases').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

            if (!snapshot.hasData) {
              return show_progress_indicator();
            }

            return snapshot.data!.docs.length==0 ? Column(
              children: [
                Icon(Icons.no_drinks),
                Text('No diseases')
              ],
            ) : ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                String name = data['name'];
                String description = data['description'];
                String youtubeLink = data['youtubelink'];
                String affectingCrops = data['affectingcrops'];

                return ListTile(
                  title: Text('\n$name',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(description,style: TextStyle(fontSize: 16),),
                      SizedBox(height: 8),
                      YoutubePlayer(

                        controller: YoutubePlayerController(

                          initialVideoId: YoutubePlayer.convertUrlToId(youtubeLink)!,

                          flags: YoutubePlayerFlags(
                            autoPlay: false,
                            mute: false,
                          ),
                        ),
                        showVideoProgressIndicator: true,
                      ),
                      SizedBox(height: 8),

                      RichText(text: TextSpan(text: 'Affecting Crops : ',
                      style:TextStyle(fontSize: 17,fontWeight: FontWeight.w500,color: Colors.black) ,
                      children: [
                        TextSpan(text: '$affectingCrops\n \n')
                      ]
                      ))
                    ],
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
