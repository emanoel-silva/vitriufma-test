class LoginAppleEntity {
  String email;
  String imgUrl;
  String password;
  String name;
  String phone;
  LoginAppleEntity({
    required this.email,
    required this.imgUrl,
    required this.password,
    required this.name,
    required this.phone,
  });

  factory LoginAppleEntity.emptty() => LoginAppleEntity(
      email: '', password: '', name: '', phone: '', imgUrl: '');
}
