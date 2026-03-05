import 'package:flutter/material.dart';
import 'package:pokemon_app/screens/cardListScreen.dart';


void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      theme: ThemeData(primarySwatch: Colors.blue),
      routes: {
        "/": (context) => CardBriefView(),
        "/details": (context) => Text("Test")
      },
      title: "Flutter Pokemon",
    );
  }
}

