import 'package:flutter_modular/flutter_modular.dart';
import 'package:iot/app/modules/home/controller/home_store.dart';
import '../view/home_page.dart';

class HomeModule extends Module {
  @override
  List<Bind<Object>> get binds => [Bind.lazySingleton((i) => HomeStore())];

  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (_, __) => HomePage()),
      ];
}
