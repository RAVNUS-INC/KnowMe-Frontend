class LoginModel {
  String userId;
  String password;
  bool rememberAccount;

  LoginModel({
    this.userId = '',
    this.password = '',
    this.rememberAccount = false,
  });
}
