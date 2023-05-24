// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HomeStore on HomeStoreBase, Store {
  late final _$connectedDeviceAtom =
      Atom(name: 'HomeStoreBase.connectedDevice', context: context);

  @override
  BluetoothDevice? get connectedDevice {
    _$connectedDeviceAtom.reportRead();
    return super.connectedDevice;
  }

  @override
  set connectedDevice(BluetoothDevice? value) {
    _$connectedDeviceAtom.reportWrite(value, super.connectedDevice, () {
      super.connectedDevice = value;
    });
  }

  late final _$servicesAtom =
      Atom(name: 'HomeStoreBase.services', context: context);

  @override
  List<BluetoothService> get services {
    _$servicesAtom.reportRead();
    return super.services;
  }

  @override
  set services(List<BluetoothService> value) {
    _$servicesAtom.reportWrite(value, super.services, () {
      super.services = value;
    });
  }

  @override
  String toString() {
    return '''
connectedDevice: ${connectedDevice},
services: ${services}
    ''';
  }
}
