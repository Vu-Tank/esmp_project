class ApiResponse {
  Object? dataResponse;
  String? message;
  bool? isSuccess;

  ApiResponse({this.dataResponse, this.isSuccess, this.message});

  Object? get DataResponse => dataResponse;

  set Data(Object data) => dataResponse = data;

  String? get Message => message;
  set Message(String? message1)=> message=message1;

  bool? get IsSuccess=> isSuccess;
  set IsSuccess(bool? isSuccess1)=> isSuccess=isSuccess1;

}
