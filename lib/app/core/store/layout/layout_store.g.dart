// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'layout_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LayoutStore on _LayoutStoreBase, Store {
  late final _$permissionsAtom =
      Atom(name: '_LayoutStoreBase.permissions', context: context);

  @override
  ObservableList<dynamic> get permissions {
    _$permissionsAtom.reportRead();
    return super.permissions;
  }

  @override
  set permissions(ObservableList<dynamic> value) {
    _$permissionsAtom.reportWrite(value, super.permissions, () {
      super.permissions = value;
    });
  }

  late final _$getPemissionAsyncAction =
      AsyncAction('_LayoutStoreBase.getPemission', context: context);

  @override
  Future<void> getPemission() {
    return _$getPemissionAsyncAction.run(() => super.getPemission());
  }

  late final _$setPermissionAsyncAction =
      AsyncAction('_LayoutStoreBase.setPermission', context: context);

  @override
  Future<void> setPermission(
      {required String email,
      required int days,
      required String permissionType}) {
    return _$setPermissionAsyncAction.run(() => super.setPermission(
        email: email, days: days, permissionType: permissionType));
  }

  @override
  String toString() {
    return '''
permissions: ${permissions}
    ''';
  }
}
