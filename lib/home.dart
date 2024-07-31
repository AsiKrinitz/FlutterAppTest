import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink.withOpacity(0.5),
        centerTitle: true,
        title: Text(
          "Home Page",
          style: TextStyle(
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.w700),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Text("Welcome To The Home Page!"),
          ],
        ),
      ),
    ));
  }
}
