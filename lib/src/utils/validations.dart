import 'package:esmp_project/src/models/validation_item.dart';

class Validations{
  static ValidationItem validUserName(String? value){
    ValidationItem validationItem= ValidationItem(null, null);
    if(value==null|| value.isEmpty){
      validationItem= ValidationItem(null, 'Không được bỏ trống');
    }else if(value.length<=5){
      validationItem=ValidationItem(null, 'Họ và tên phải nhiều hơn 5 ký tụ');
    }else if(value.length>50){
      validationItem=ValidationItem(null, 'Tên quá dài (50 ký tự)');
    }else{
      validationItem=ValidationItem(value, null);
    }
    return validationItem;
  }
  static ValidationItem valEmail(String? value){
    ValidationItem validationItem= ValidationItem(null, null);
    if(value==null|| value.isEmpty){
      validationItem= ValidationItem(null, 'Không được bỏ trống');
    }else{
      String pattern = r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
      RegExp regExp = RegExp(pattern);
      if (!regExp.hasMatch(value)) {
        validationItem=ValidationItem(null, "Email Không hợp lệ");
      }else{
        validationItem=ValidationItem(value, null);
      }
    }
    return validationItem;
  }
  static ValidationItem valPhoneNumber(String? value){
    ValidationItem validationItem= ValidationItem(null, null);
    String pattern = r'^(0|84|\+84){1}([3|5|7|8|9]){1}([0-9]{8})\b';
    RegExp regExp = RegExp(pattern);
    if(value==null || value.isEmpty){
      validationItem= ValidationItem(null, "Vui lòng Nhập số điện thoại");
    }else if(!regExp.hasMatch(value)){
      validationItem=ValidationItem(null, "Số điện thoại không chính xác");
    }else{
      validationItem=ValidationItem(value, null);
    }
    return validationItem;
  }
  static ValidationItem valAddressContex(String? value){
    ValidationItem validationItem= ValidationItem(null, null);
    if(value==null|| value.isEmpty){
      validationItem= ValidationItem(null, "Vui lòng nhập địa chỉ của bạn");
    }else if(value.length>100){
      validationItem= ValidationItem(null, "Địa chỉ quá dài (Tối đa 100 ký tự)");
    }else{
      validationItem=ValidationItem(value, null);
    }
    return validationItem;
  }
}