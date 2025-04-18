
// expr1 ? expr2 ? expr3
//nếu expr1 đúng, trả về expr2 ngược lại, trả về expr3
//expr1 ?? expr2;
//nếu exp1 không null. trả về giá trị của nó;
//ngược lại

void main(){
  var kiemtra = (100%2==0)?"100 là số chẵn": "100 là số lẻ";
  print(kiemtra);
}
