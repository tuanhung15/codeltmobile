import 'package:flutter/material.dart';

class MyScaffold extends StatelessWidget{
  const MyScaffold({super.key, required String title});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Tieu de cua ung dung
        title: Text("App 02"),
      ),
      backgroundColor: Colors.lightBlueAccent,

      body: Center(child: Text("Noi dung chinh"),),

      floatingActionButton: FloatingActionButton(
        onPressed: (){print("pressed");},
        child: const Icon(Icons.ice_skating_outlined),
      ),
      bottomNavigationBar: BottomNavigationBar(items: [
        BottomNavigationBarItem(icon: Icon(Icons.home),label: "trang chu"),
        BottomNavigationBarItem(icon: Icon(Icons.search),label: "tim kiem"),
        BottomNavigationBarItem(icon: Icon(Icons.person),label: "ca nhan")
      ]),
    );
  }
}