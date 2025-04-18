import 'package:flutter/material.dart';

class MyText extends StatelessWidget{
  const MyText({super.key, required String title});

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
          //Tao khoang cach
          const SizedBox( height: 50,),
          //text co ban
          const Text("Nguyen Doan Phuc Tai"),
          const SizedBox( height: 20,),

          const Text(
            "Xin chao cac dang hoc lap trinh Flutter!",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
                letterSpacing: 1.5
            ),
          ),

          const SizedBox( height: 20,),

          const Text(
            "Flutter là một SDK phát triển ứng dụng di động nguồn mở tạo ra bới Google. Nó được sử dụng",
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                letterSpacing: 1.5
            ),
          ),

        ],
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