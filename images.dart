import 'package:flutter/material.dart';

class Images extends StatelessWidget {
  const Images({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("App 02"),
        backgroundColor: Colors.blue,
        elevation: 4,


      ),

      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Image.asset('assets/images/z6537465507031_051bf625c3b39543aad1feb27ff8a614.jpg'),
            ),
            Expanded(
              child: Image.asset('assets/images/z6537553007474_92beab26a7c6aefadd414ab6c899c3d0.jpg'),
            ),
            Expanded(
              child: Image.asset('assets/images/z6537556515697_5d402614c950f773995e6e7ff9ed0ec8.jpg'),
            ),
          ],
        ),
      ),
    );
  }
}