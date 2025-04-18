import 'package:flutter/material.dart';

class MyButton extends StatelessWidget{
  const MyButton({super.key, required String title});

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


      body: Center(child: Column(
          children: [
            SizedBox(height: 50,),
            ElevatedButton(onPressed: (){print("ElevatedButton");},
                child: Text("ElevatedButton", style: TextStyle(fontSize: 24),)),

            SizedBox(height: 20),
            TextButton(
                onPressed: (){print("TextButton");},
                child: Text("TextButton", style: TextStyle(fontSize: 24),)),

            SizedBox(height: 20),
            OutlinedButton(onPressed:
                (){print("OutlineButton");},
                child: Text("OutlineButton", style: TextStyle(fontSize: 24),)),

            SizedBox(height: 20),
            IconButton(onPressed:
                (){print("IconButton");},
                icon: Icon(Icons.favorite)),

            SizedBox(height: 20),
            FloatingActionButton(onPressed:
                (){print("FloatingActionButton");},
              child: Icon(Icons.add),
            )

          ]
      ),),

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