// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detail_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$DetailStore on _DetailStoreBase, Store {
  late final _$loadingAtom =
      Atom(name: '_DetailStoreBase.loading', context: context);

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

  late final _$readingListAtom =
      Atom(name: '_DetailStoreBase.readingList', context: context);

  @override
  ObservableList<dynamic> get readingList {
    _$readingListAtom.reportRead();
    return super.readingList;
  }

  @override
  set readingList(ObservableList<dynamic> value) {
    _$readingListAtom.reportWrite(value, super.readingList, () {
      super.readingList = value;
    });
  }

  late final _$publicAtom =
      Atom(name: '_DetailStoreBase.public', context: context);

  @override
  bool get public {
    _$publicAtom.reportRead();
    return super.public;
  }

  @override
  set public(bool value) {
    _$publicAtom.reportWrite(value, super.public, () {
      super.public = value;
    });
  }

  late final _$filterAtom =
      Atom(name: '_DetailStoreBase.filter', context: context);

  @override
  ObservableMap<String, dynamic> get filter {
    _$filterAtom.reportRead();
    return super.filter;
  }

  @override
  set filter(ObservableMap<String, dynamic> value) {
    _$filterAtom.reportWrite(value, super.filter, () {
      super.filter = value;
    });
  }

  late final _$bookAtom = Atom(name: '_DetailStoreBase.book', context: context);

  @override
  Book get book {
    _$bookAtom.reportRead();
    return super.book;
  }

  bool _bookIsInitialized = false;

  @override
  set book(Book value) {
    _$bookAtom.reportWrite(value, _bookIsInitialized ? super.book : null, () {
      super.book = value;
      _bookIsInitialized = true;
    });
  }

  late final _$mostAccessedMaterialsAtom =
      Atom(name: '_DetailStoreBase.mostAccessedMaterials', context: context);

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
      name: '_DetailStoreBase.isLoadingMostAccessedMaterials',
      context: context);

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

  late final _$relatedBooksAtom =
      Atom(name: '_DetailStoreBase.relatedBooks', context: context);

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
      Atom(name: '_DetailStoreBase.relatedBooksMap', context: context);

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

  late final _$getBookByIdAsyncAction =
      AsyncAction('_DetailStoreBase.getBookById', context: context);

  @override
  Future<void> getBookById(int id) {
    return _$getBookByIdAsyncAction.run(() => super.getBookById(id));
  }

  late final _$getMaterialListAsyncAction =
      AsyncAction('_DetailStoreBase.getMaterialList', context: context);

  @override
  Future<void> getMaterialList() {
    return _$getMaterialListAsyncAction.run(() => super.getMaterialList());
  }

  late final _$getMostAccessedMaterialsAsyncAction = AsyncAction(
      '_DetailStoreBase.getMostAccessedMaterials',
      context: context);

  @override
  Future<void> getMostAccessedMaterials(int limit) {
    return _$getMostAccessedMaterialsAsyncAction
        .run(() => super.getMostAccessedMaterials(limit));
  }

  late final _$getRelatedInfoMaterialAsyncAction =
      AsyncAction('_DetailStoreBase.getRelatedInfoMaterial', context: context);

  @override
  Future<void> getRelatedInfoMaterial(List<String> keywords) {
    return _$getRelatedInfoMaterialAsyncAction
        .run(() => super.getRelatedInfoMaterial(keywords));
  }

  late final _$fetchRelatedBooksAsyncAction =
      AsyncAction('_DetailStoreBase.fetchRelatedBooks', context: context);

  @override
  Future<void> fetchRelatedBooks(String keyword) {
    return _$fetchRelatedBooksAsyncAction
        .run(() => super.fetchRelatedBooks(keyword));
  }

  late final _$addFavoriteAsyncAction =
      AsyncAction('_DetailStoreBase.addFavorite', context: context);

  @override
  Future<void> addFavorite(int id) {
    return _$addFavoriteAsyncAction.run(() => super.addFavorite(id));
  }

  late final _$addItemsToListAsyncAction =
      AsyncAction('_DetailStoreBase.addItemsToList', context: context);

  @override
  Future<void> addItemsToList({required int id, required int idList}) {
    return _$addItemsToListAsyncAction
        .run(() => super.addItemsToList(id: id, idList: idList));
  }

  late final _$removeItemFromListAsyncAction =
      AsyncAction('_DetailStoreBase.removeItemFromList', context: context);

  @override
  Future<void> removeItemFromList({required int id, required int idList}) {
    return _$removeItemFromListAsyncAction
        .run(() => super.removeItemFromList(id: id, idList: idList));
  }

  late final _$addTagToMaterialAsyncAction =
      AsyncAction('_DetailStoreBase.addTagToMaterial', context: context);

  @override
  Future<void> addTagToMaterial(
      {required int bookId, required List<String> tags}) {
    return _$addTagToMaterialAsyncAction
        .run(() => super.addTagToMaterial(bookId: bookId, tags: tags));
  }

  late final _$removeTagFromMaterialAsyncAction =
      AsyncAction('_DetailStoreBase.removeTagFromMaterial', context: context);

  @override
  Future<void> removeTagFromMaterial(
      {required int bookId,
      required String tagToRemove,
      required List<String> currentTags}) {
    return _$removeTagFromMaterialAsyncAction.run(() => super
        .removeTagFromMaterial(
            bookId: bookId,
            tagToRemove: tagToRemove,
            currentTags: currentTags));
  }

  late final _$createListInfoMatAsyncAction =
      AsyncAction('_DetailStoreBase.createListInfoMat', context: context);

  @override
  Future<void> createListInfoMat(
      {required String name, bool public = true, required List<int> ids}) {
    return _$createListInfoMatAsyncAction.run(
        () => super.createListInfoMat(name: name, public: public, ids: ids));
  }

  late final _$deleteListInfoMatAsyncAction =
      AsyncAction('_DetailStoreBase.deleteListInfoMat', context: context);

  @override
  Future<void> deleteListInfoMat({required int idList}) {
    return _$deleteListInfoMatAsyncAction
        .run(() => super.deleteListInfoMat(idList: idList));
  }

  late final _$setReviewAsyncAction =
      AsyncAction('_DetailStoreBase.setReview', context: context);

  @override
  Future<void> setReview({required int bookId, required double rating}) {
    return _$setReviewAsyncAction
        .run(() => super.setReview(bookId: bookId, rating: rating));
  }

  late final _$deleteReviewAsyncAction =
      AsyncAction('_DetailStoreBase.deleteReview', context: context);

  @override
  Future<void> deleteReview({required int bookId}) {
    return _$deleteReviewAsyncAction
        .run(() => super.deleteReview(bookId: bookId));
  }

  late final _$_DetailStoreBaseActionController =
      ActionController(name: '_DetailStoreBase', context: context);

  @override
  void setPublic(bool value) {
    final _$actionInfo = _$_DetailStoreBaseActionController.startAction(
        name: '_DetailStoreBase.setPublic');
    try {
      return super.setPublic(value);
    } finally {
      _$_DetailStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void applyFilter(Map<String, dynamic> newFilter) {
    final _$actionInfo = _$_DetailStoreBaseActionController.startAction(
        name: '_DetailStoreBase.applyFilter');
    try {
      return super.applyFilter(newFilter);
    } finally {
      _$_DetailStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
loading: ${loading},
readingList: ${readingList},
public: ${public},
filter: ${filter},
book: ${book},
mostAccessedMaterials: ${mostAccessedMaterials},
isLoadingMostAccessedMaterials: ${isLoadingMostAccessedMaterials},
relatedBooks: ${relatedBooks},
relatedBooksMap: ${relatedBooksMap}
    ''';
  }
}
