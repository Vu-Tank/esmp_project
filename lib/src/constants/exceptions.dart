class ConstantError {
  Map<String, String> _ERROR_MAP = const {
    'ERR_001': 'Nhập số điện thoại',
    'ERR_002': 'Vui lòng nhập số điện thoại di động hợp lệ',
    'ERR_003': 'Vui lòng Nhập mật khẩu',
  };

  String? getErrorMessage(String errorCode) {
    String? result=null;
    if (!errorCode.isEmpty && errorCode != null) {
      _ERROR_MAP.forEach((key, value) {
        if (key.compareTo(errorCode) == 0) {
          result=value;
        }
      });
    }
    return result;
  }
}
