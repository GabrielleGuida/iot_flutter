import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:iot/app/modules/info_device/controller/info_device_controller.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class InfoDevicePage extends StatefulWidget {
  final List<BluetoothService>? services;
  final BluetoothDevice? device;
  InfoDevicePage({super.key, this.device, this.services});

  final Map<Guid, List<int>> readValues = <Guid, List<int>>{};

  @override
  State<InfoDevicePage> createState() => _InfoDeviceState();
}

class _InfoDeviceState extends State<InfoDevicePage> {
  final controller = Modular.get<InfoDeviceController>();

  List<Widget> characteristicsWidgetBPM = <Widget>[];
  List<ButtonTheme> _buildButton(
      BluetoothCharacteristic characteristic) {
    List<ButtonTheme> buttons = <ButtonTheme>[];

    if (characteristic.properties.read) {
      buttons.add(
        ButtonTheme(
          minWidth: 10,
          height: 20,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: TextButton(
              child: const Text('READ', style: TextStyle(color: Colors.black)),
              onPressed: () async {
                var sub = characteristic.value.listen((value) {
                  setState(() {
                    widget.readValues[characteristic.uuid] = value;
                  });
                });
                await characteristic.read();
                sub.cancel();
              },
            ),
          ),
        ),
      );
    }
    if (characteristic.properties.write) {
      buttons.add(
        ButtonTheme(
          minWidth: 10,
          height: 20,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ElevatedButton(
              child: const Text('WRITE', style: TextStyle(color: Colors.black)),
              onPressed: () async {
                await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Write"),
                        content: Row(
                          children: <Widget>[
                            Observer(builder: (_) {
                              return Expanded(
                                child: TextField(
                                  controller: controller.writeController,
                                ),
                              );
                            }),
                          ],
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text("Send"),
                            onPressed: () {
                              characteristic.write(utf8.encode(
                                  controller.writeController.value.text));
                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                            child: const Text("Cancel"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    });
              },
            ),
          ),
        ),
      );
    }
    if (characteristic.properties.notify) {
      buttons.add(
        ButtonTheme(
          minWidth: 10,
          height: 20,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ElevatedButton(
              child:
                  const Text('NOTIFY', style: TextStyle(color: Colors.black)),
              onPressed: () async {
                characteristic.value.listen((value) {
                  setState(() {
                    widget.readValues[characteristic.uuid] = value;
                  });
                });
                await characteristic.setNotifyValue(true);
              },
            ),
          ),
        ),
      );
    }

    return buttons;
  }

  _bpm(characteristic) {
    return Column(
      children: [
        Card(
          color: Color(0xFFE8154A),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                const Row(
                  children: [
                    Icon(Icons.monitor_heart_rounded,
                        color: Colors.white, size: 20),
                    SizedBox(
                      width: 5,
                    ),
                    Text("Monitoring Heartbeat",
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Column(
                        children: [
                          Icon(Icons.favorite, color: Colors.white, size: 80),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                              widget.readValues[characteristic.uuid] != null
                                  ? '${widget.readValues[characteristic.uuid].toString().replaceAll("[", "").replaceAll("]", "").split(",").last}'
                                  : '0',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold)),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("bpm",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20))
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: ButtonTheme(
                minWidth: 10,
                height: 20,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ElevatedButton(
                    child: const Text('NOTIFY',
                        style: TextStyle(color: Colors.black)),
                    onPressed: () async {
                      characteristic.value.listen((value) {
                        setState(() {
                          widget.readValues[characteristic.uuid] = value;
                        });
                      });
                      await characteristic.setNotifyValue(true);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  ListView _buildConnect() {
    List<Widget> containers = <Widget>[];

    Widget bpm = SizedBox.shrink();

    for (BluetoothService service in widget.services!) {
      List<Widget> characteristicsWidget = <Widget>[];

      for (BluetoothCharacteristic characteristic in service.characteristics) {
        controller.sendService.send(characteristic.toString());

        if (characteristic.properties.notify) {
          characteristicsWidget.add(
            service.uuid.toString() == "0000180d-0000-1000-8000-00805f9b34fb"
                ? _bpm(characteristic)
                : Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                                child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 0),
                                    child: Text(
                                        "characteristic uuid: ${characteristic.uuid}",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: const TextStyle(
                                            color: Colors.black))))
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            ..._buildButton(characteristic),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 0),
                                child: Text(
                                  'characteristic value: ${widget.readValues[characteristic.uuid]}',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(color: Colors.black),
                                )),
                          ],
                        ),
                        const Divider(),
                      ],
                    ),
                  ),
          );
        }
      }
      if (service.uuid.toString() == "0000180d-0000-1000-8000-00805f9b34fb") {
        bpm = Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...characteristicsWidget,
            Card(
              color: Colors.white,
              // elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  "ATTENTION: Your device is using BPM through the feature ${service.uuid}",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        );
      } else {
        containers.add(
          ExpansionTile(
              title: Text("Service UUID: " + service.uuid.toString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14)),
              children: characteristicsWidget),
        );
      }
    }

    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        bpm,
        ExpansionTile(
            title: const Text("See more device features"),
            children: <Widget>[...containers]),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.device!.name.toString()),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              widget.device!.disconnect();
              Navigator.pop(context);
            },
          )),
      body: Column(
        children: <Widget>[Expanded(child: _buildConnect())],
      ),
    );
  }
}
