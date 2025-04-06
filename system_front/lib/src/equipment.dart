import 'package:flutter/material.dart';

class EquipmentPage extends StatefulWidget {
  static List<bool> workList = [false, false, false, false];
  static List<String> equipmentList = [
    'Электросито',
    'Смеситель',
    'Упаковочная машина',
    'Ленточные конвейеры',
  ];
  static List<String> classList = ['Хранение', 'Обработка'];

  const EquipmentPage({super.key});

  @override
  State<EquipmentPage> createState() => _EquipmentPageState();
}

class _EquipmentPageState extends State<EquipmentPage> {
  List<bool> workList = EquipmentPage.workList;
  List<String> equipmentList = EquipmentPage.equipmentList;
  List<double> masterData = [1, 180, 50, 20];
  List<String> masterparam = ['мм', 'сек', 'кг', 'км/ч'];
  List<String> classList = EquipmentPage.classList;

  var dropdownValue = EquipmentPage.classList[0].toString();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height,
      width: MediaQuery.sizeOf(context).width * 0.8,
      child: Wrap(
        children: [
          equipmentContainer(0),
          equipmentContainer(1),
          equipmentContainer(2),
          equipmentContainer(3),
        ],
      ),
    );
  }

  Widget equipmentContainer(int index) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Container(
        width: 300,
        height: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(width: 0.5),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      workList[index] = !workList[index];
                    });
                  },
                  icon:
                      workList[index]
                          ? Icon(
                            Icons.check_circle,
                            color: Colors.lightGreen,
                            size: 40,
                          )
                          : Icon(Icons.cancel, color: Colors.red, size: 40),
                ),
                Text(
                  equipmentList[index],
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  workList[index] ? 'Работает' : 'Не работает',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
                ElevatedButton(
                  onPressed:
                      () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) {
                          final paramNameController = TextEditingController();
                          final paramValueController = TextEditingController();
                          return AlertDialog(
                            title: const Text('Редактировать устройство'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('название устройства'),
                                TextField(
                                  controller: paramNameController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: equipmentList[index],
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text('Класс устройства'),
                                DropdownButton<String>(
                                  value: dropdownValue,
                                  icon: const Icon(Icons.arrow_downward),
                                  elevation: 16,
                                  onChanged: (String? value) {
                                    // This is called when the user selects an item.
                                    setState(() {
                                      dropdownValue = value!;
                                    });
                                  },
                                  items:
                                      classList.map<DropdownMenuItem<String>>((
                                        String value,
                                      ) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                ),
                                SizedBox(height: 20),
                                Text('Эталонные параметры'),
                                TextField(
                                  controller: paramValueController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText:
                                        '${masterData[index]} ${masterparam[index]}',
                                  ),
                                ),
                              ],
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'OK'),
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      ),

                  child: Text('Edit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget alarmWidget(int index) {
    return AlertDialog(
      title: Text('Редактировать устройство'),
      content: Text('Диалог'),
      //  Column(
      //   children: [
      //     SizedBox(
      //       width: 300,
      //       height: 84,
      //       child: TextField(
      //         decoration: InputDecoration(
      //           border: OutlineInputBorder(),
      //           hintText: equipmentList[index],
      //         ),
      //         onChanged: (value) {},
      //       ),
      //     ),
      //   ],
      // ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
