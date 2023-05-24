import 'package:flutter_modular/flutter_modular.dart';
import 'package:iot/app/modules/home/controller/home_store.dart';
import 'package:iot/app/modules/info_device/controller/info_device_controller.dart';
// import 'package:iot/app/modules/home/home_store.dart';
import 'modules/home/module/home_module.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.lazySingleton((i) => HomeStore()),
        Bind.lazySingleton((i) => InfoDeviceController()),
      ];

  @override
  final List<ModularRoute> routes = [
    ModuleRoute(Modular.initialRoute, module: HomeModule()),
  ];
}
