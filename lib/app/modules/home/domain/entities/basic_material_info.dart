class BasicMaterialInfo {
  int id;
  String title;
  List<String> author;
  String coverImage;
  double rating;

  BasicMaterialInfo({
    required this.id,
    required this.title,
    required this.author,
    required this.coverImage,
    required this.rating,
  });

  // Funções get para retornar os campos
  int get getId => id;
  String get getTitle => title;
  List<String> get getAuthor => author;
  String get getCoverImage => coverImage;
  double get getRating => rating;

  // Método fromJson para criar uma instância a partir de um JSON
  factory BasicMaterialInfo.fromJson(Map<String, dynamic> json) {
    return BasicMaterialInfo(
      id: json['id'],
      title: json['title'],
      author: List<String>.from(json['author']),
      coverImage: json['cover_image'],
      rating: json['rating'].toDouble(),
    );
  }

  // Método toMap para converter a instância em um mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'cover_image': coverImage,
      'rating': rating,
    };
  }
}
