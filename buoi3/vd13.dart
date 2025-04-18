import 'dart:io';

void main()
{
  //Nhập tên người dùng 
  stdout.write('Enter your name: ');
  String name =stdin.readLineSync()!;//! chắc chắn nhập dữ iệu để không bị null
//Nhập tuổi người dùng 
  stdout.write('Enter your age: ');
  int age =int.parse( stdin.readLineSync()!);

  print("xin chao: $name,Tuổi của bạn là: $age ");
}