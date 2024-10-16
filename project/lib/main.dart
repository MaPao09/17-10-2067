import 'package:flutter/material.dart';
import 'package:project/providers/user_provider.dart';
import 'package:project/pages/main_page.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      //ครอบด้วยProvider
      create: (context) =>
          UserProvider(), //กำลังจะสร้างProviderตัวใหม่ ให้ติดตามUserProvider
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Homepage(),
      ),
    );
  }
}
