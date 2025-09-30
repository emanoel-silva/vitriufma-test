// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AuthStore on _AuthStoreBase, Store {
  late final _$userAtom = Atom(name: '_AuthStoreBase.user', context: context);

  @override
  LoggedUser? get user {
    _$userAtom.reportRead();
    return super.user;
  }

  @override
  set user(LoggedUser? value) {
    _$userAtom.reportWrite(value, super.user, () {
      super.user = value;
    });
  }

  late final _$statusAtom =
      Atom(name: '_AuthStoreBase.status', context: context);

  @override
  AuthStatus? get status {
    _$statusAtom.reportRead();
    return super.status;
  }

  @override
  set status(AuthStatus? value) {
    _$statusAtom.reportWrite(value, super.status, () {
      super.status = value;
    });
  }

  late final _$_AuthStoreBaseActionController =
      ActionController(name: '_AuthStoreBase', context: context);

  @override
  dynamic setUser(LoggedUser? user) {
    final _$actionInfo = _$_AuthStoreBaseActionController.startAction(
        name: '_AuthStoreBase.setUser');
    try {
      return super.setUser(user);
    } finally {
      _$_AuthStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setStatus(AuthStatus value) {
    final _$actionInfo = _$_AuthStoreBaseActionController.startAction(
        name: '_AuthStoreBase.setStatus');
    try {
      return super.setStatus(value);
    } finally {
      _$_AuthStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
user: ${user},
status: ${status}
    ''';
  }
}
