
import 'package:easyagro/selection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:proste_bezier_curve/proste_bezier_curve.dart';

import 'splash.dart';

class forgotpassword extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Stack(
            children: [

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
                      top: Offset(size.width / 4 * 3, 100),
                      end: Offset(size.width, 150),
                    ),
                  ],
                ),
                child: Container(
                  height: size.height*0.72,
                  width: size.width,
                  color: Colors.green.shade900,
                  child: Opacity(opacity: 0.4,child: Image.asset('images/back.jpg',fit: BoxFit.cover,),),
                ),
              ),


              Positioned(
                top: size.height*0.05,
                left: size.width*0.04,
                child: Container(
                    height: 48,
                    width: 40,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle
                    ),child:  IconButton(onPressed: (){
                  Navigator.pushReplacement(context, Myroute(Selection()));
                },icon: Icon(Icons.arrow_back_ios,color: Colors.green,size: 30,),)),
              ),

              Positioned(
                top: size.height*0.07,
                left: size.width*0.1,
                right:size.width*0.1 ,
                child: Container(
                  width: size.width*0.8,
                  child: Column(
                    children: [
                      Text('Forgotpassword',style: TextStyle(fontSize: 34,fontWeight: FontWeight.bold,color: Colors.white),)
                      ,
                      Text('Create new password\n',style: TextStyle(fontSize: 17,color: Colors.white),)
                      ,
                      Text('\n \n \n'),
                      TextField(
                        cursorColor: Colors.green.shade700,
                        decoration: InputDecoration(
                            hintText: 'Email',
                            prefixIcon: Icon(Icons.mail,color: Colors.green,size: 28,),
                          suffix: ElevatedButton(onPressed: (){},child: Text('Get OTP'),   style:ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.green.shade700),
                          ))

                        ),

                      ),
                      Text(''),
                      TextField(
                        cursorColor: Colors.green.shade700,
                        decoration: InputDecoration(
                            hintText: 'OTP',
                            prefixIcon: Icon(Icons.https,color: Colors.green,size: 28,)
                        ),
                      ),
                      Text(''),
                      TextField(
                        cursorColor: Colors.green.shade700,
                        decoration: InputDecoration(
                            hintText: 'New Password',
                            prefixIcon: Icon(Icons.https,color: Colors.green,size: 28,)
                        ),
                      ),

                      Container(
                        width: size.width*0.7,
                        child: ElevatedButton(onPressed: (){}, child: Text('Update')   ,style:ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.green.shade700),
    )),
                      )

                    ],
                  ),
                ),
              ),




            ],)


        ],
      ),
    );
  }



}