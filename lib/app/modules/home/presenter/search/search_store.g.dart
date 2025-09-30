// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SearchStore on _SearchStoreBase, Store {
  late final _$booksFilteredAtom =
      Atom(name: '_SearchStoreBase.booksFiltered', context: context);

  @override
  List<Book> get booksFiltered {
    _$booksFilteredAtom.reportRead();
    return super.booksFiltered;
  }

  @override
  set booksFiltered(List<Book> value) {
    _$booksFilteredAtom.reportWrite(value, super.booksFiltered, () {
      super.booksFiltered = value;
    });
  }

  late final _$loadingAtom =
      Atom(name: '_SearchStoreBase.loading', context: context);

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

  late final _$filterAtom =
      Atom(name: '_SearchStoreBase.filter', context: context);

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

  late final _$searchWithFiltersAsyncAction =
      AsyncAction('_SearchStoreBase.searchWithFilters', context: context);

  @override
  Future<void> searchWithFilters() {
    return _$searchWithFiltersAsyncAction.run(() => super.searchWithFilters());
  }

  late final _$searchAsyncAction =
      AsyncAction('_SearchStoreBase.search', context: context);

  @override
  Future<void> search(String search) {
    return _$searchAsyncAction.run(() => super.search(search));
  }

  late final _$advancedSearchMethodAsyncAction =
      AsyncAction('_SearchStoreBase.advancedSearchMethod', context: context);

  @override
  Future<void> advancedSearchMethod(Map<String, dynamic> query) {
    return _$advancedSearchMethodAsyncAction
        .run(() => super.advancedSearchMethod(query));
  }

  late final _$_SearchStoreBaseActionController =
      ActionController(name: '_SearchStoreBase', context: context);

  @override
  void applyFilter(Map<String, dynamic> newFilter) {
    final _$actionInfo = _$_SearchStoreBaseActionController.startAction(
        name: '_SearchStoreBase.applyFilter');
    try {
      return super.applyFilter(newFilter);
    } finally {
      _$_SearchStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearSearch() {
    final _$actionInfo = _$_SearchStoreBaseActionController.startAction(
        name: '_SearchStoreBase.clearSearch');
    try {
      return super.clearSearch();
    } finally {
      _$_SearchStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
booksFiltered: ${booksFiltered},
loading: ${loading},
filter: ${filter}
    ''';
  }
}
