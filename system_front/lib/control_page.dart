import 'package:flutter/material.dart';
import 'package:system_front/src/dashboard.dart';
import 'package:system_front/src/equipment.dart';
import 'package:system_front/src/logs.dart';
import 'package:system_front/src/options.dart';
import 'package:system_front/src/users.dart';

class ControlPage extends StatefulWidget {
  const ControlPage({super.key});
  static bool isOn = false;
  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  bool isDashboard = true;
  bool isEquipment = false;
  bool isUsers = false;
  bool isLogs = false;
  bool isOptions = false;
  bool connectd = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final style = ElevatedButton.styleFrom(
      backgroundColor: Theme.of(context).colorScheme.primary,
      elevation: 0,
      fixedSize: Size.fromWidth(MediaQuery.sizeOf(context).width * 0.18),
    );
    final textStyle = TextStyle(
      color: Color.fromARGB(255, 255, 255, 255),
      fontSize: 24.0,
      fontStyle: FontStyle.normal,
    );
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).colorScheme.primary,
      //   centerTitle: true,
      //   title: Text(style: textStyle, 'Система мониторинга'),
      // ),
      body: Row(
        children: [
          Container(
            alignment: Alignment(0, 0),
            width: MediaQuery.sizeOf(context).width * 0.2,
            color: Theme.of(context).colorScheme.primary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 10.0,
              children: [
                SizedBox(height: 10),
                ElevatedButton(
                  style: style,
                  onPressed: () {
                    setState(() {
                      isDashboard = true;
                      isEquipment = false;
                      isUsers = false;
                      isLogs = false;
                      isOptions = false;
                    });
                  },
                  child: Text(style: textStyle, 'Dashboard'),
                ),
                ElevatedButton(
                  style: style,
                  onPressed: () {
                    setState(() {
                      isDashboard = false;
                      isEquipment = true;
                      isUsers = false;
                      isLogs = false;
                      isOptions = false;
                    });
                  },
                  child: Text(style: textStyle, 'Оборудование'),
                ),
                ElevatedButton(
                  style: style,
                  onPressed: () {
                    setState(() {
                      isDashboard = false;
                      isEquipment = false;
                      isUsers = true;
                      isLogs = false;
                      isOptions = false;
                    });
                  },
                  child: Text(style: textStyle, 'Пользователи'),
                ),
                ElevatedButton(
                  style: style,
                  onPressed: () {
                    setState(() {
                      isDashboard = false;
                      isEquipment = false;
                      isUsers = false;
                      isLogs = true;
                      isOptions = false;
                    });
                  },
                  child: Text(style: textStyle, 'Журнал'),
                ),
                ElevatedButton(
                  style: style,
                  onPressed: () {
                    setState(() {
                      isDashboard = false;
                      isEquipment = false;
                      isUsers = false;
                      isLogs = false;
                      isOptions = true;
                    });
                  },
                  child: Text(style: textStyle, 'Настройки'),
                ),
              ],
            ),
          ),
          informationWidget(),
        ],
      ),
    );
  }

  Widget informationWidget() {
    if (isOptions) {
      return OptionsPage(connected: connectd);
    }
    if (isUsers) {
      return UserPage();
    }
    if (isLogs) {
      return LogsPage();
    }
    if (isEquipment) {
      return EquipmentPage();
    }
    return Dashboard();
  }
}
