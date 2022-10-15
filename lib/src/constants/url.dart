class AppUrl{
  //hotting
  // static const String baseUrl="http://52.172.254.105";
  //local
  static const String baseUrl="https://10.0.2.2:7026";
  static const String login="$baseUrl/api/user/customersign_in";
  static const String checkExistPhone="$baseUrl/api/user/check_user";
  static const String register="$baseUrl/api/user/user_register";
  static const String editImage="$baseUrl/api/user/edit_image";
  static const String refeshtoken="$baseUrl/api/user/refeshtoken";
  static const String getItem="$baseUrl/api/Item";
  static const String getItemDetail="$baseUrl/api/Item/item_detail";

  static const String defaultAvatar='https://firebasestorage.googleapis.com/v0/b/esmp-4b85e.appspot.com/o/images%2FdefaultAvatar.png?alt=media&token=f7d821ad-8881-448d-8c4a-c82b64103c03';
}