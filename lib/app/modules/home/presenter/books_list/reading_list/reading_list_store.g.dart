// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reading_list_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ReadingListStore on _ReadingListStoreBase, Store {
  late final _$loadingAtom =
      Atom(name: '_ReadingListStoreBase.loading', context: context);

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
      Atom(name: '_ReadingListStoreBase.readingList', context: context);

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

  late final _$listBooksAtom =
      Atom(name: '_ReadingListStoreBase.listBooks', context: context);

  @override
  List<Book> get listBooks {
    _$listBooksAtom.reportRead();
    return super.listBooks;
  }

  @override
  set listBooks(List<Book> value) {
    _$listBooksAtom.reportWrite(value, super.listBooks, () {
      super.listBooks = value;
    });
  }

  late final _$getMaterialListAsyncAction =
      AsyncAction('_ReadingListStoreBase.getMaterialList', context: context);

  @override
  Future<void> getMaterialList() {
    return _$getMaterialListAsyncAction.run(() => super.getMaterialList());
  }

  late final _$getMaterialFromListAsyncAction = AsyncAction(
      '_ReadingListStoreBase.getMaterialFromList',
      context: context);

  @override
  Future<void> getMaterialFromList(int listId) {
    return _$getMaterialFromListAsyncAction
        .run(() => super.getMaterialFromList(listId));
  }

  late final _$getSharedListAsyncAction =
      AsyncAction('_ReadingListStoreBase.getSharedList', context: context);

  @override
  Future<void> getSharedList(int id) {
    return _$getSharedListAsyncAction.run(() => super.getSharedList(id));
  }

  late final _$deleteListInfoMatAsyncAction =
      AsyncAction('_ReadingListStoreBase.deleteListInfoMat', context: context);

  @override
  Future<void> deleteListInfoMat({required int idList}) {
    return _$deleteListInfoMatAsyncAction
        .run(() => super.deleteListInfoMat(idList: idList));
  }

  late final _$removeItemFromListAsyncAction =
      AsyncAction('_ReadingListStoreBase.removeItemFromList', context: context);

  @override
  Future<void> removeItemFromList({required int id, required int idList}) {
    return _$removeItemFromListAsyncAction
        .run(() => super.removeItemFromList(id: id, idList: idList));
  }

  @override
  String toString() {
    return '''
loading: ${loading},
readingList: ${readingList},
listBooks: ${listBooks}
    ''';
  }
}
