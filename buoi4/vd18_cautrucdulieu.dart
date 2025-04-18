import 'dart:math';

void main()
{
  //Định nghĩa:
  //-list là tập hợp các phần tử có thứ tự và trùng lặp

  List<String> list1 = ['A','B','C'];
  var list2 = [1,2,3];//su dung var
  List<String> list3 = [];//list rỗng
  var list4 = List<int>.filled(3,0);//list có kích thước cô định
//1.them phần tử
list1.add('D');
list1.addAll(['A','B']);
list1.insert(0, 'z');
list1.insertAll(1, ['1','0']);
//2 xóa phần tử bên trong list
list1.remove('A');
list1.removeAt(0);//xóa vị trí 0
list1.removeLast;
list1.removeWhere((e)=>e=='B');//xóa theo dieu kien
list1.clear();
//3.truy cập phần tử
print(list2[0]);// lấy phần tử ở vị trí 0 
print(list2.first);
print(list2.last);
print(list2.length);
//4 kiểm tra
print(list2.isEmpty);
print('list 3:${list3.isNotEmpty?'Không rỗng':'rỗng'}');
print(list4.contains(0));
print(list4.indexOf(0));
print(list4.lastIndexOf(0));
//biến đổi
list4=[1,53,5,2,4];
list4.sort();//sắp xếp tăng dần
print(list4);
list4.reversed;//đảo ngược
list4=list4.reversed.toList( );
//7 cắt và nối
var sublist = list4.sublist(1,3);
var str_joined = list4.join(",");
//8 duyệt các phần tử trong list
list4.forEach((element){
print(element);
});
}