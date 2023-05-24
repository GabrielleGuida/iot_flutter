import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:iot/app/modules/home/controller/home_store.dart';
import 'package:iot/app/modules/info_device/view/info_device.dart';

class HomePage extends StatefulWidget {
  final FlutterBluePlus bluePlus = FlutterBluePlus.instance;
  final List<BluetoothDevice> devicesList = <BluetoothDevice>[];
  HomePage({
    Key? key,
  }) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final controller = Modular.get<HomeStore>();

  _newListDevice(final BluetoothDevice device) {
    if (!widget.devicesList.contains(device)) {
      setState(() {
        widget.devicesList.add(device);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    widget.bluePlus.connectedDevices
        .asStream()
        .listen((List<BluetoothDevice> devices) {
      for (BluetoothDevice device in devices) {
        _newListDevice(device);
        debugPrint(device.toString());
      }
    });
    widget.bluePlus.scanResults.listen((List<ScanResult> results) {
      for (ScanResult result in results) {
        _newListDevice(result.device);
      }
    });

    widget.bluePlus.startScan();
  }

  ListView _buildViewDevices() {
    List<Widget> containers = <Widget>[];
    for (BluetoothDevice device in widget.devicesList) {
      containers.add(
        SizedBox(
          height: 90,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Icon(
                    Icons.bluetooth,
                    color: Colors.black,
                    size: 24.0,
                    semanticLabel: 'Bluetooth',
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Text(device.name == '' ? 'Unknown' : device.name),
                        Text(device.id.toString()),
                      ],
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Color(0xFFE8154A),
                    ),
                    child: const Text(
                      'Connect',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () async {
                      widget.bluePlus.stopScan();
                      try {
                        await device.connect();
                      } on PlatformException catch (e) {
                        if (e.code != 'already_connected') {
                          rethrow;
                        }
                      } finally {
                        controller.services = await device.discoverServices();
                      }
                      setState(() {
                        controller.connectedDevice = device;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => InfoDevicePage(
                                      device: controller.connectedDevice,
                                      services: controller.services,
                                    ))));
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        ...containers,
      ],
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Bluetooth Data Capture"),
              IconButton(
                icon: const Icon(Icons.refresh_rounded),
                onPressed: () {},
              ),
            ],
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Color(0xFFE8154A),
                        ),
                        onPressed: () {},
                        child: const Text(
                          "Scan",
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
              child: Text(
                "Available devices",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: _buildViewDevices(),
            )
          ],
        ),
      );
}
