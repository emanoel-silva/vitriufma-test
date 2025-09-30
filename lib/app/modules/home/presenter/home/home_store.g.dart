// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HomeStore on _HomeStoreBase, Store {
  Computed<List<Book>>? _$filteredBooksComputed;

  @override
  List<Book> get filteredBooks => (_$filteredBooksComputed ??=
          Computed<List<Book>>(() => super.filteredBooks,
              name: '_HomeStoreBase.filteredBooks'))
      .value;

  late final _$booksAtom = Atom(name: '_HomeStoreBase.books', context: context);

  @override
  ObservableList<Book> get books {
    _$booksAtom.reportRead();
    return super.books;
  }

  @override
  set books(ObservableList<Book> value) {
    _$booksAtom.reportWrite(value, super.books, () {
      super.books = value;
    });
  }

  late final _$selectedBookAtom =
      Atom(name: '_HomeStoreBase.selectedBook', context: context);

  @override
  Book? get selectedBook {
    _$selectedBookAtom.reportRead();
    return super.selectedBook;
  }

  @override
  set selectedBook(Book? value) {
    _$selectedBookAtom.reportWrite(value, super.selectedBook, () {
      super.selectedBook = value;
    });
  }

  late final _$searchQueryAtom =
      Atom(name: '_HomeStoreBase.searchQuery', context: context);

  @override
  String get searchQuery {
    _$searchQueryAtom.reportRead();
    return super.searchQuery;
  }

  @override
  set searchQuery(String value) {
    _$searchQueryAtom.reportWrite(value, super.searchQuery, () {
      super.searchQuery = value;
    });
  }

  late final _$loadingAtom =
      Atom(name: '_HomeStoreBase.loading', context: context);

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  late final _$relatedBooksAtom =
      Atom(name: '_HomeStoreBase.relatedBooks', context: context);

  @override
  ObservableList<dynamic> get relatedBooks {
    _$relatedBooksAtom.reportRead();
    return super.relatedBooks;
  }

  @override
  set relatedBooks(ObservableList<dynamic> value) {
    _$relatedBooksAtom.reportWrite(value, super.relatedBooks, () {
      super.relatedBooks = value;
    });
  }

  late final _$relatedBooksMapAtom =
      Atom(name: '_HomeStoreBase.relatedBooksMap', context: context);

  @override
  ObservableMap<String, ObservableList<Book>> get relatedBooksMap {
    _$relatedBooksMapAtom.reportRead();
    return super.relatedBooksMap;
  }

  @override
  set relatedBooksMap(ObservableMap<String, ObservableList<Book>> value) {
    _$relatedBooksMapAtom.reportWrite(value, super.relatedBooksMap, () {
      super.relatedBooksMap = value;
    });
  }

  late final _$mostAccessedMaterialsAtom =
      Atom(name: '_HomeStoreBase.mostAccessedMaterials', context: context);

  @override
  ObservableList<dynamic> get mostAccessedMaterials {
    _$mostAccessedMaterialsAtom.reportRead();
    return super.mostAccessedMaterials;
  }

  @override
  set mostAccessedMaterials(ObservableList<dynamic> value) {
    _$mostAccessedMaterialsAtom.reportWrite(value, super.mostAccessedMaterials,
        () {
      super.mostAccessedMaterials = value;
    });
  }

  late final _$isLoadingMostAccessedMaterialsAtom = Atom(
      name: '_HomeStoreBase.isLoadingMostAccessedMaterials', context: context);

  @override
  bool get isLoadingMostAccessedMaterials {
    _$isLoadingMostAccessedMaterialsAtom.reportRead();
    return super.isLoadingMostAccessedMaterials;
  }

  @override
  set isLoadingMostAccessedMaterials(bool value) {
    _$isLoadingMostAccessedMaterialsAtom
        .reportWrite(value, super.isLoadingMostAccessedMaterials, () {
      super.isLoadingMostAccessedMaterials = value;
    });
  }

  late final _$topRatedMaterialsAtom =
      Atom(name: '_HomeStoreBase.topRatedMaterials', context: context);

  @override
  ObservableList<dynamic> get topRatedMaterials {
    _$topRatedMaterialsAtom.reportRead();
    return super.topRatedMaterials;
  }

  @override
  set topRatedMaterials(ObservableList<dynamic> value) {
    _$topRatedMaterialsAtom.reportWrite(value, super.topRatedMaterials, () {
      super.topRatedMaterials = value;
    });
  }

  late final _$isLoadingTopRatedMaterialsAtom =
      Atom(name: '_HomeStoreBase.isLoadingTopRatedMaterials', context: context);

  @override
  bool get isLoadingTopRatedMaterials {
    _$isLoadingTopRatedMaterialsAtom.reportRead();
    return super.isLoadingTopRatedMaterials;
  }

  @override
  set isLoadingTopRatedMaterials(bool value) {
    _$isLoadingTopRatedMaterialsAtom
        .reportWrite(value, super.isLoadingTopRatedMaterials, () {
      super.isLoadingTopRatedMaterials = value;
    });
  }

  late final _$getRelatedInfoMaterialAsyncAction =
      AsyncAction('_HomeStoreBase.getRelatedInfoMaterial', context: context);

  @override
  Future<void> getRelatedInfoMaterial(List<String> keywords) {
    return _$getRelatedInfoMaterialAsyncAction
        .run(() => super.getRelatedInfoMaterial(keywords));
  }

  late final _$fetchRelatedBooksAsyncAction =
      AsyncAction('_HomeStoreBase.fetchRelatedBooks', context: context);

  @override
  Future<void> fetchRelatedBooks(String keyword) {
    return _$fetchRelatedBooksAsyncAction
        .run(() => super.fetchRelatedBooks(keyword));
  }

  late final _$getMostAccessedMaterialsAsyncAction =
      AsyncAction('_HomeStoreBase.getMostAccessedMaterials', context: context);

  @override
  Future<void> getMostAccessedMaterials(int limit) {
    return _$getMostAccessedMaterialsAsyncAction
        .run(() => super.getMostAccessedMaterials(limit));
  }

  late final _$getTopRatedMaterialsAsyncAction =
      AsyncAction('_HomeStoreBase.getTopRatedMaterials', context: context);

  @override
  Future<void> getTopRatedMaterials(int limit) {
    return _$getTopRatedMaterialsAsyncAction
        .run(() => super.getTopRatedMaterials(limit));
  }

  late final _$_HomeStoreBaseActionController =
      ActionController(name: '_HomeStoreBase', context: context);

  @override
  void setSelectedBook(Book value) {
    final _$actionInfo = _$_HomeStoreBaseActionController.startAction(
        name: '_HomeStoreBase.setSelectedBook');
    try {
      return super.setSelectedBook(value);
    } finally {
      _$_HomeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSearchQuery(String query) {
    final _$actionInfo = _$_HomeStoreBaseActionController.startAction(
        name: '_HomeStoreBase.setSearchQuery');
    try {
      return super.setSearchQuery(query);
    } finally {
      _$_HomeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setbooks(List<Book> newbooks) {
    final _$actionInfo = _$_HomeStoreBaseActionController.startAction(
        name: '_HomeStoreBase.setbooks');
    try {
      return super.setbooks(newbooks);
    } finally {
      _$_HomeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void selectBook(String? id) {
    final _$actionInfo = _$_HomeStoreBaseActionController.startAction(
        name: '_HomeStoreBase.selectBook');
    try {
      return super.selectBook(id);
    } finally {
      _$_HomeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
books: ${books},
selectedBook: ${selectedBook},
searchQuery: ${searchQuery},
loading: ${loading},
relatedBooks: ${relatedBooks},
relatedBooksMap: ${relatedBooksMap},
mostAccessedMaterials: ${mostAccessedMaterials},
isLoadingMostAccessedMaterials: ${isLoadingMostAccessedMaterials},
topRatedMaterials: ${topRatedMaterials},
isLoadingTopRatedMaterials: ${isLoadingTopRatedMaterials},
filteredBooks: ${filteredBooks}
    ''';
  }
}
