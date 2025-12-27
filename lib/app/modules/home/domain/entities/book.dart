class Book {
  String title;
  List<String> author;
  String publicationYear;
  String coverImage;
  String summary;
  String abstract1;
  List<String> matters;
  List<String> subMatters;
  List<String> tags;
  String address;
  String availability;
  String numberOfPages;
  String isbn;
  String issn;
  String typer;
  String language;
  String publisher;
  int volume;
  String series;
  String edition;
  String reprintUpdate;
  int id;
  String? altText;

  Book({
    required this.title,
    required this.author,
    required this.publicationYear,
    required this.coverImage,
    required this.summary,
    required this.abstract1,
    required this.matters,
    required this.subMatters,
    required this.tags,
    required this.address,
    required this.availability,
    required this.numberOfPages,
    required this.isbn,
    required this.issn,
    required this.typer,
    required this.language,
    required this.publisher,
    required this.volume,
    required this.series,
    required this.edition,
    required this.reprintUpdate,
    required this.id,
    this.altText,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      title: json['title'] ?? '',
      author: _parseStringList(json['author']),
      publicationYear: json['publication_year'] ?? '',
      coverImage: json['cover_image'] ?? '',
      summary: json['summary'] ?? '',
      abstract1: json['abstract'] ?? '',
      matters: _parseStringList(json['matters'] ?? []),
      subMatters: _parseStringList(json['sub_matters'] ?? []),
      tags: _parseStringList(json['tags'] ?? []),
      address: json['address'] ?? '',
      availability: json['availability'] ?? '',
      numberOfPages: json['number_of_pages'] ?? '',
      isbn: json['isbn'] ?? '',
      issn: json['issn'] ?? '',
      typer: json['typer'] ?? '',
      language: json['language'] ?? '',
      publisher: json['publisher'] ?? '',
      volume: json['volume'] ?? 0,
      series: json['series'] ?? '',
      edition: json['edition'] ?? '',
      reprintUpdate: json['reprint_update'] ?? '',
      id: json['id'] ?? 0,
      altText: json['alt_text'],
    );
  }

  static List<String> _parseStringList(dynamic value) {
    if (value is List) {
      // Remove empty strings and trim whitespace from each item
      return value
          .where((item) => item.toString().trim().isNotEmpty)
          .map((item) => item.toString().trim())
          .toList();
    } else if (value is String) {
      // Trim whitespace from the string
      return [value.trim()];
    } else {
      return [];
    }
  }

  //toMap
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'publication_year': publicationYear,
      'cover_image': coverImage,
      'abstract': abstract1,
      'matters': matters,
      'tags': tags,
      'number_of_pages': numberOfPages,
      'isbn': isbn,
      'issn': issn,
      'typer': typer,
      'language': language,
      'publisher': publisher,
      'volume': volume,
      'series': series,
      'edition': edition,
      'reprint_update': reprintUpdate,
      'id': id,
      'alt_text': altText,
    };
  }

  // Method to filter books by all fields
  List<Book> filterByAllFields(String value) {
    return this.title.contains(value) ||
            this.author.any((element) => element.contains(value)) ||
            this.matters.any((element) => element.contains(value)) ||
            this.tags.any((element) => element.contains(value))
        ? [this]
        : [];
  }

  // Method to filter books by title
  List<Book> filterByTitle(String title) {
    return this.title.contains(title) ? [this] : [];
  }

  // Method to filter books by author
  List<Book> filterByAuthor(String authorName) {
    return author
            .map((e) => e.toLowerCase().contains(authorName))
            .toList()
            .contains(true)
        ? [this]
        : [];
  }

  // Method to filter books by matter
  List<Book> filterByMatter(String matter) {
    return matters
            .map((e) => e.toLowerCase().contains(matter))
            .toList()
            .contains(true)
        ? [this]
        : [];
  }

  // Method to filter books by tag
  List<Book> filterByTag(String tag) {
    return tags.map((e) => e.toLowerCase().contains(tag)).toList().contains(true)
        ? [this]
        : [];
  }
}
