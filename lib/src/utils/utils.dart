import 'package:intl/intl.dart';

class Utils{
  static String convertToFirebase(String value){
    if (value.indexOf('0') == 0) {
      value = value.replaceFirst("0", "+84");
    } else if (value.indexOf("8") == 0) {
      value = value.replaceFirst("8", "+8");
    }
    return value;
  }
  static String convertToDB(String value){
    if(value.indexOf('+')==0){
      value=value.replaceFirst("+", "");
    }
    return value;
  }
  static String convertPriceVND(double value){
    String price="";
    var f = NumberFormat("###,###", "en_US");
    price='đ ${f.format(value)}';
    return price;
  }
  static String createFile(){
    DateTime time= DateTime.now();
    String name=time.toString().trim().replaceAllMapped(new RegExp(r'\D'), (match) {
      return '';});
    return name;
  }
}
