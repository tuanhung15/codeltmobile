/*
Chuỗi là một tập hợp ký tự UFT-16

*/
void main()
{
  var s1 ='tuan hung';
  var s2 = 'TITV.vn';


  //chèn giá trị của một biểu thức biến vào trong chuỗi: ${....}
  double diemtoan = 9;
    double diemvan = 6;
  var s3 ='xin chào $s1,bạn đa đạt điểm tổng là: ${diemvan+diemtoan}';
  print(s3);

  //Tạo ra chuỗi nằm ở nhiều dòng
  var s4 ="""
Dòng 1
Dòng 2
Dòng 3
""";

  var s5 ="""
Dòng 1
Dòng 2
Dòng 3
""";

  var s6 ='Đây là một đoạn \n văn bản!';
print(s6);
var s7 = r'Đây là một đoạn \n văn bản!';//raw dữ liệu thô
print(s7);
var s8 = "Chuỗi 1"+"Chuỗi 2";//raw dữ liệu thô
print(s8);
var s9 ='chuỗi'
        "này"
        "Là"
        "một "
        "Chuỗi";
print(s9);
}