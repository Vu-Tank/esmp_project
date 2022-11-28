class AppUrl{
  //hotting
  static const String baseUrl="http://esmpfree-001-site1.etempurl.com";
  //local
  // static const String baseUrl="https://10.0.2.2:7026";
  static const String login="$baseUrl/api/user/customersign_in";
  static const String checkExistPhone="$baseUrl/api/user/check_user";
  static const String register="$baseUrl/api/user/user_register";
  static const String editImage="$baseUrl/api/user/edit_image";
  static const String editUserName="$baseUrl/api/user/edit_name";
  static const String editEmail="$baseUrl/api/user/edit_email";
  static const String editGender="$baseUrl/api/user/edit_gender";
  static const String editDOB="$baseUrl/api/user/edit_birth";
  static const String editAddress="$baseUrl/api/user/edt_address";
  static const String createAddress="$baseUrl/api/user/add_address";
  static const String deleteAddress="$baseUrl/api/user/remove_address";
  static const String createOrder="$baseUrl/api/Order";
  static const String refeshtoken="$baseUrl/api/user/refeshtoken";// sai quy tac lạc đà
  static const String getItem="$baseUrl/api/Item";
  static const String getItemDetail="$baseUrl/api/Item/item_detail";
  static const String getCarts="$baseUrl/api/Order";
  static const String getCartInfo="$baseUrl/api/Order/order_info";
  static const String updateAddressOrder="$baseUrl/api/Order/update_address";
  static const String updateAmountSubItem="$baseUrl/api/Order/update_amount";
  static const String removeSubItem="$baseUrl/api/Order/remove_orderdetail";// sai quy tac lạc đà
  static const String removeOrder="$baseUrl/api/Order";
  static const String getCategory="$baseUrl/api/Category";
  static const String getBrandModel="$baseUrl/api/Brand";
  static const String searchItem="$baseUrl/api/Item/search";
  static const String getOldOrder="$baseUrl/api/Order/get_order_status";
  static const String getOrder="$baseUrl/api/Order/order_info";
  static const String payment="$baseUrl/api/Payment/momopay";
  static const String checkPayment="$baseUrl/api/Order/check_pay";
  static const String cancelOrder="$baseUrl/api/Payment/cancel_order";
  static const String feedbackOrder="$baseUrl/api/Order/feedback";
  static const String reportItem="$baseUrl/api/Report/item_report";
  static const String reportStore="$baseUrl/api/Report/store_report";
  static const String reportFeedback="$baseUrl/api/Report/feedback_report";
  static const String getFeedbacks="$baseUrl/api/Order/get_list_feedback";
  static const String getAdminContact="$baseUrl/api/user/AdminContact";
  static const String logout="$baseUrl/api/user/logout";
  static const String checkStore="$baseUrl/api/Store/check_store";

  static const String defaultAvatar='https://firebasestorage.googleapis.com/v0/b/esmp-4b85e.appspot.com/o/images%2F16-1c8843e5-4dd0-4fb7-b061-3a9fcbd68c0d?alt=media&token=0c8838a5-d3c4-4c31-82ed-d9b91d8c11d9-3a9fcbd68c0d%3Falt%3Dmedia%26token%3D0c8838a5-d3c4-4c31-82ed-d9b91d8c11d9%26fbclid%3DIwAR0v68PcVs-E38YszRIZPyNy4PaYRZU59b21d-iyQ8NTyBrvXYp3YBqKclQ&h=AT0F7Fm4W02bljIiOCCdNFraaSuuADp6xPHlwhoYbjufje1E8RgzWN2FGd6VMBRyqTf3FUfZTqL06dMVX9L_KUFIKX3uDnn11IbTYz6Sy3S1K3bJYBxQeouYAqKg8loyuiQ4dg';
}