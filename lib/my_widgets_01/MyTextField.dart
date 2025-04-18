import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({super.key, required String title});

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
            onPressed: () {
              print("b1");
            },
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              print("b2");
            },
            icon: Icon(Icons.abc),
          ),
          IconButton(
            onPressed: () {
              print("b3");
            },
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),

      body:Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 50),
              TextField(
                decoration: InputDecoration(
                  labelText: "Ho va ten",
                  hintText: "Nhap vao ho va ten cua ban",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 30),

              TextField(
                decoration: InputDecoration(
                  labelText: "email",
                  hintText: "Example@gmail.com",
                  helperText: "Nhập vào email cá nhân",
                  prefixIcon: Icon(Icons.email),
                  suffixIcon: Icon(Icons.clear),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  filled: true,
                  fillColor: Colors.grey,
                ),
                keyboardType: TextInputType.emailAddress,
              ),

              SizedBox(height: 30),
              TextField(
                decoration: InputDecoration(
                  labelText: "So dien thoai",
                  hintText: "Nhap vao SDT cua ban",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),

              SizedBox(height: 30),
              TextField(
                decoration: InputDecoration(
                  labelText: "Ngay sinh",
                  hintText: "Nhap vao ngay sinh cua ban",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.datetime,
              ),

              SizedBox(height: 30),
              TextField(
                decoration: InputDecoration(
                  labelText: "Mat khau",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.datetime,
                obscureText: true,
                obscuringCharacter: '*',
              ),

              SizedBox(height: 30),
              TextField(
                onChanged: (value){
                  print("Dang nhap: $value");
                },
                onSubmitted: (value){
                  print("Da hoan thanh noi dung");
                },
                decoration: InputDecoration(
                  labelText: "Cau hoi bi mat",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.datetime,

              ),
            ],
          ),
        ),
      ),



      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("Pressed");
        },
        child: const Icon(Icons.add_ic_call),
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Trang chủ"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Tìm kiếm"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Cá nhân"),
        ],
      ),
    );
  }
}
