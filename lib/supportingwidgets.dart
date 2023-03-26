





import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class show_progress_indicator extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
  return
   Center(child: Container(
        color: Colors.white,
        child: SpinKitFoldingCube(
          size: 50.0,
          duration: Duration(milliseconds: 700),
          itemBuilder: ((context, index) {
            var Mycolors=[Colors.green.shade700,Colors.white];
            var Mycol=Mycolors[index%Mycolors.length];
            return DecoratedBox(decoration: BoxDecoration(
                color: Mycol,
                border: Border.all(color: Colors.green,)

            ));
          }),
        ),
      ),

    );

  }

}