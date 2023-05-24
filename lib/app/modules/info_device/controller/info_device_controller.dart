import 'package:flutter/material.dart';
import 'package:iot/app/service/service.dart';
import 'package:mobx/mobx.dart';
part 'info_device_controller.g.dart';

class InfoDeviceController = _InfoDeviceControllerBase
    with _$InfoDeviceController;

abstract class _InfoDeviceControllerBase with Store {
  @observable
  Service sendService = Service();
  @observable
  TextEditingController writeController = TextEditingController();
}
