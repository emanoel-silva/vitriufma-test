class LoggedUser {
  String id;
  String image;
  String application;
  String? lastLogin;
  String email;
  String name;
  String key;
  Map<String, String>? token;

  LoggedUser(
      {required this.id,
      required this.image,
      required this.application,
      this.lastLogin,
      required this.email,
      required this.name,
      required this.key,
      this.token
      });
}
