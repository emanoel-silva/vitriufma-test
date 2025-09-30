class LoginGoogleEntity {
  String email;
  String imgUrl;
  String password;
  String name;
  String phone;
  LoginGoogleEntity({
    required this.email,
    required this.imgUrl,
    required this.password,
    required this.name,
    required this.phone,
  });

  factory LoginGoogleEntity.emptty() => LoginGoogleEntity(
      email: '', password: '', name: '', phone: '', imgUrl: '');
}
