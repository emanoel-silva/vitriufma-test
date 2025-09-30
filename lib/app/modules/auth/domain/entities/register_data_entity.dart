// ignore_for_file: public_member_api_docs, sort_constructors_first

class RegisterData {
  String email;
  String image;
  String password;
  String name;
  String code;
  String phone;
  String document;

  RegisterData({
    required this.email,
    required this.image,
    required this.password,
    required this.name,
    required this.code,
    required this.phone,
    required this.document,
  });

  factory RegisterData.empty() => RegisterData(
        email: '',
        password: '',
        name: '',
        code: '',
        phone: '',
        document: '',
        image: '',
      );
}
