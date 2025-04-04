import 'package:flutter/material.dart';

class EquipmentPage extends StatefulWidget {
  static List<bool> workList = [false, false, false, false];
  static List<String> equipmentList = [
    'Электросито',
    'Смеситель',
    'Упаковочная машина',
    'Ленточные конвейеры',
  ];

  const EquipmentPage({super.key});

  @override
  State<EquipmentPage> createState() => _EquipmentPageState();
}

class _EquipmentPageState extends State<EquipmentPage> {
  List<bool> workList = EquipmentPage.workList;
  List<String> equipmentList = EquipmentPage.equipmentList;

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
                          ? Icon(Icons.check_circle, color: Colors.lightGreen, size: 40)
                          : Icon(Icons.cancel, color: Colors.red, size: 40),
                ),
                Text(
                  equipmentList[index],
                  style: TextStyle(fontSize: 18, color: Colors.black, fontStyle: FontStyle.normal),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              workList[index] ? 'Работает' : 'Не работает',
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
