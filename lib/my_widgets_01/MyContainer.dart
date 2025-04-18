import 'package:flutter/material.dart';

class MyContainer extends StatelessWidget{
  const MyContainer({super.key, required String title});

  @override
  Widget build(BuildContext context) {
    // tra ve Scaffold - widget cung cap bo cuc material design co ban
    //Man hinh
    return Scaffold(
      //Tieu de cua ung dung
      appBar: AppBar(
        //Tieu de
        title: Text("App 02"),

        //Mau nen
        backgroundColor: Colors.blue,

        //Do nang / do bong cua nen
        elevation: 4,

        actions: [
          IconButton(
            onPressed: (){print("b1");},
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: (){print("b2");},
            icon: Icon(Icons.abc),
          ),
          IconButton(
            onPressed: (){print("b3");},
            icon: Icon(Icons.more_vert),
          )
        ],

      ),


      body: Center(child: Container(
        width: 200,
        height: 200,
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.lightBlueAccent,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.greenAccent.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ]
        ),

        child: Align(
          alignment: Alignment.center,
          child: const Text("Nguyen Doan Phuc Tai",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
      )
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: (){print("Pressed");},
        child: const Icon(Icons.add_ic_call),
      ),

      bottomNavigationBar: BottomNavigationBar(items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Trang chủ"),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: "Tìm kiếm"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Cá nhân"),
      ]),

    );
  }


}