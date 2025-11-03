import 'package:flutter/material.dart';
// เปลี่ยน import มาที่ home_screen.dart ซึ่งเป็นหน้าหลักใหม่ของเรา
import './screen/home_screen.dart'; 

void main(){
    runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: 'Flutter App',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            // เปลี่ยน home ให้แสดง HomeScreen เป็นหน้าแรก
            home: const HomeScreen() 
        );
    }
}