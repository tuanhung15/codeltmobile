import 'dart:ffi';

void main()
{
  //int: là kiểu số nguyên
  int x = 100;
  //double: là kiểu số thực
  double y = 100.5;

  //num: có thể chứ số nguyên hoặc số thực 
  num z = 10;
  num t = 10.75;
  //Chuyển sang số nguyên
  var one = int.parse('1');
  print(one==1?'TRUE':'FALSE');
  //Chuyển sang số thực
  var onepointone = double.parse('1.1');
  print(onepointone ==1.1);
    //số nguyên sang chuỗi
  String oneAsString = 1.toString();
  print(oneAsString);
   //số thực sang chuỗi
  String piAsString = 3.14159.toStringAsFixed(2);
  print(piAsString);
}