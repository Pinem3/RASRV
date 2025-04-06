import 'package:flutter/material.dart';
import 'package:system_front/control_page.dart';
import 'dart:io';

import 'package:system_front/src/equipment.dart';

// ignore: must_be_immutable
class OptionsPage extends StatefulWidget {
  bool connected;
  static Socket? socket;
  OptionsPage({super.key, required this.connected});

  @override
  State<OptionsPage> createState() => _OptionsPageState();
}

class _OptionsPageState extends State<OptionsPage> {
  bool connected = false;
  Socket? socket;
  String val = 'подключиться к серверу';
  List<bool> workList = EquipmentPage.workList;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          child: Container(
            padding: EdgeInsets.all(20),
            width: 300.0,
            height: 84.0,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(),
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 20,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      ControlPage.isOn = !ControlPage.isOn!;
                      for (int i = 0; i < workList.length; i++) {
                        workList[i] = ControlPage.isOn;
                      }
                    });
                  },
                  icon:
                      ControlPage.isOn
                          ? Icon(Icons.check_circle, color: Colors.lightGreen)
                          : Icon(Icons.cancel, color: Colors.red),
                ),
                Text(
                  ControlPage.isOn
                      ? 'Остановить производство'
                      : 'Запустить производство',
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          child: Container(
            padding: EdgeInsets.all(20),
            width: 300.0,
            height: 84.0,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(),
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 20,
              children: [
                IconButton(
                  onPressed:
                      connected
                          ? null
                          : () async {
                            try {
                              socket = await Socket.connect(
                                '127.0.0.1',
                                228,
                                timeout: Duration(seconds: 5),
                              );
                              setState(() {
                                val = 'подключено';
                                connected = true;
                              });
                            } catch (e) {
                              setState(() {
                                connected = false;
                                val = 'Ошибка подключения';
                              });
                            }
                          },
                  icon:
                      connected
                          ? Icon(Icons.check_circle, color: Colors.lightGreen)
                          : Icon(Icons.cancel, color: Colors.red),
                ),
                Text(val),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
