// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'info_device_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$InfoDeviceController on _InfoDeviceControllerBase, Store {
  late final _$sendServiceAtom =
      Atom(name: '_InfoDeviceControllerBase.sendService', context: context);

  @override
  Service get sendService {
    _$sendServiceAtom.reportRead();
    return super.sendService;
  }

  @override
  set sendService(Service value) {
    _$sendServiceAtom.reportWrite(value, super.sendService, () {
      super.sendService = value;
    });
  }

  late final _$writeControllerAtom =
      Atom(name: '_InfoDeviceControllerBase.writeController', context: context);

  @override
  TextEditingController get writeController {
    _$writeControllerAtom.reportRead();
    return super.writeController;
  }

  @override
  set writeController(TextEditingController value) {
    _$writeControllerAtom.reportWrite(value, super.writeController, () {
      super.writeController = value;
    });
  }

  @override
  String toString() {
    return '''
sendService: ${sendService},
writeController: ${writeController}
    ''';
  }
}
