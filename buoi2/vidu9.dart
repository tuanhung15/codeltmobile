void main()
{
  Object obj ='hello';
  //kiem tra obj co phai la string
  if(obj is String){
    print('obj la mot string');
  }
   //kiem tra obj co phai la so nguyen
  if(obj is! int){
    print('khong phai la 1 so nguyen');
    
  }
  
}