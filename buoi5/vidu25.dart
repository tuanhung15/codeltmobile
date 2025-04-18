//records là một kiểu dữ liệu tổng hợp được giới thiệu trong dart 3.0
//cho phép nhóm nhiều giá trị có kiểu khác nhau thành một đơn vị duy nhất
//records là imutable nghĩa là không thể thay đổi sau khi được tạo
void main() {
  var r = ('first', 'x', a: 2, 5, 10.5); //record
  //định nghĩa record có 2 giá trị
  var point = (123, 456);

  //định nghĩa person
  var person = (name: 'Alice', age: 25);
  //truy cập giá trong record
  //dùng chỉ số
  print(point.$1); //123
  print(point.$2); //456
  print(point.$1); //5
  //dùng tên
  print(person.name);
  print(person.age);
}
