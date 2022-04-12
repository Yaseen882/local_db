import 'package:database_practise_flutter/presentation/my_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

Function? setTheState;

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Phoenix(child: const MyApp()),
    ),
  );
}
