import 'dart:ui';

import 'package:flutter/material.dart';

class Prediction extends StatelessWidget {
  final String txt;
  final String conception;
  const Prediction({Key? key,required this.txt,required this.conception}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(),
      body:  Center(
        child: Container(
          width: 300,
          height: 300,
          color: Colors.transparent,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Text(txt,style: const TextStyle(color: Colors.green,fontSize: 35),),
                const SizedBox(height: 20,),
                Text('Your on the $conception list!',style: const TextStyle(color: Colors.amber,fontSize: 20),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
