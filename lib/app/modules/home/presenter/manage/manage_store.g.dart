// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manage_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ManageStore on _ManageStoreBase, Store {
  late final _$loadingAtom =
      Atom(name: '_ManageStoreBase.loading', context: context);

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

  late final _$loadingReportsAtom =
      Atom(name: '_ManageStoreBase.loadingReports', context: context);

  @override
  bool get loadingReports {
    _$loadingReportsAtom.reportRead();
    return super.loadingReports;
  }

  @override
  set loadingReports(bool value) {
    _$loadingReportsAtom.reportWrite(value, super.loadingReports, () {
      super.loadingReports = value;
    });
  }

  late final _$mostAccessedBooksAtom =
      Atom(name: '_ManageStoreBase.mostAccessedBooks', context: context);

  @override
  ObservableList<Book> get mostAccessedBooks {
    _$mostAccessedBooksAtom.reportRead();
    return super.mostAccessedBooks;
  }

  @override
  set mostAccessedBooks(ObservableList<Book> value) {
    _$mostAccessedBooksAtom.reportWrite(value, super.mostAccessedBooks, () {
      super.mostAccessedBooks = value;
    });
  }

  late final _$bestRatedBooksAtom =
      Atom(name: '_ManageStoreBase.bestRatedBooks', context: context);

  @override
  ObservableList<Book> get bestRatedBooks {
    _$bestRatedBooksAtom.reportRead();
    return super.bestRatedBooks;
  }

  @override
  set bestRatedBooks(ObservableList<Book> value) {
    _$bestRatedBooksAtom.reportWrite(value, super.bestRatedBooks, () {
      super.bestRatedBooks = value;
    });
  }

  late final _$bookAccessCountsAtom =
      Atom(name: '_ManageStoreBase.bookAccessCounts', context: context);

  @override
  ObservableMap<int, int> get bookAccessCounts {
    _$bookAccessCountsAtom.reportRead();
    return super.bookAccessCounts;
  }

  @override
  set bookAccessCounts(ObservableMap<int, int> value) {
    _$bookAccessCountsAtom.reportWrite(value, super.bookAccessCounts, () {
      super.bookAccessCounts = value;
    });
  }

  late final _$bookRatingsAtom =
      Atom(name: '_ManageStoreBase.bookRatings', context: context);

  @override
  ObservableMap<int, double> get bookRatings {
    _$bookRatingsAtom.reportRead();
    return super.bookRatings;
  }

  @override
  set bookRatings(ObservableMap<int, double> value) {
    _$bookRatingsAtom.reportWrite(value, super.bookRatings, () {
      super.bookRatings = value;
    });
  }

  late final _$totalBooksCountAtom =
      Atom(name: '_ManageStoreBase.totalBooksCount', context: context);

  @override
  int get totalBooksCount {
    _$totalBooksCountAtom.reportRead();
    return super.totalBooksCount;
  }

  @override
  set totalBooksCount(int value) {
    _$totalBooksCountAtom.reportWrite(value, super.totalBooksCount, () {
      super.totalBooksCount = value;
    });
  }

  late final _$setPermissionAsyncAction =
      AsyncAction('_ManageStoreBase.setPermission', context: context);

  @override
  Future<void> setPermission(
      {required String email,
      required int days,
      required String permissionType}) {
    return _$setPermissionAsyncAction.run(() => super.setPermission(
        email: email, days: days, permissionType: permissionType));
  }

  late final _$enableOrDisableUserAsyncAction =
      AsyncAction('_ManageStoreBase.enableOrDisableUser', context: context);

  @override
  Future<void> enableOrDisableUser(
      {required String email, required bool enable}) {
    return _$enableOrDisableUserAsyncAction
        .run(() => super.enableOrDisableUser(email: email, enable: enable));
  }

  late final _$loadReportsDataAsyncAction =
      AsyncAction('_ManageStoreBase.loadReportsData', context: context);

  @override
  Future<void> loadReportsData() {
    return _$loadReportsDataAsyncAction.run(() => super.loadReportsData());
  }

  late final _$_loadMostAccessedBooksAsyncAction =
      AsyncAction('_ManageStoreBase._loadMostAccessedBooks', context: context);

  @override
  Future<void> _loadMostAccessedBooks() {
    return _$_loadMostAccessedBooksAsyncAction
        .run(() => super._loadMostAccessedBooks());
  }

  late final _$_loadBestRatedBooksAsyncAction =
      AsyncAction('_ManageStoreBase._loadBestRatedBooks', context: context);

  @override
  Future<void> _loadBestRatedBooks() {
    return _$_loadBestRatedBooksAsyncAction
        .run(() => super._loadBestRatedBooks());
  }

   late final _$_loadTotalBooksCountAsyncAction =
      AsyncAction('_ManageStoreBase._loadTotalBooksCount', context: context);

  @override
  Future<void> _loadTotalBooksCount() {
    return _$_loadTotalBooksCountAsyncAction
        .run(() => super._loadTotalBooksCount());
  }

  @override
  String toString() {
    return '''
loading: ${loading},
loadingReports: ${loadingReports},
mostAccessedBooks: ${mostAccessedBooks},
bestRatedBooks: ${bestRatedBooks},
bookAccessCounts: ${bookAccessCounts},
bookRatings: ${bookRatings},
totalBooksCount: ${totalBooksCount}
    ''';
  }
}
