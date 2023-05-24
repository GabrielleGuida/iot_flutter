import 'package:iot/app/modules/home/view/home_page.dart';
import 'package:flutter/material.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.pink, useMaterial3: true),
      title: 'IoT',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
