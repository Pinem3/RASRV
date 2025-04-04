import 'package:flutter/material.dart';
import 'package:system_front/src/equipment.dart';

// ignore: must_be_immutable
class Dashboard extends StatelessWidget {
  Dashboard({super.key});
  List<bool> equipmentStatus = EquipmentPage.workList;
  List<String> equipmentList = EquipmentPage.equipmentList;
  List<String> dataname = [
    'Всего произведено',
    "Активное оборудование",
    "Качество",
    "Эффективность",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            dataContainer(context, dataname: dataname[0]),
            dataContainer(context, dataname: dataname[1]),
            dataContainer(context, dataname: dataname[2]),
            dataContainer(context, dataname: dataname[3]),
          ],
        ),
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              width: MediaQuery.of(context).size.width * 0.4,
              child: Text(
                'Состояние оборудования',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Журнал логов',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.height * 0.7,
                child: Container(
                  decoration: BoxDecoration(color: Colors.white),
                  child:
                  // SizedBox(
                  //   height: 40,
                  //   child: Text('Состояние оборудования', style: TextStyle(fontSize: 20)),
                  // ),
                  ListView.builder(
                    itemCount: equipmentStatus.length,
                    itemBuilder: (context, index) {
                      return equipmentContainer(index);
                    },
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width * 0.4,
              height: MediaQuery.of(context).size.height * 0.7,
              child: Container(decoration: BoxDecoration(color: Colors.white)),
            ),
          ],
        ),
      ],
    );
  }

  Widget dataContainer(BuildContext context, {required String dataname}) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.2,
      height: MediaQuery.of(context).size.height * 0.2,
      padding: EdgeInsets.all(10),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text(dataname), SelectableText('0', style: TextStyle(fontSize: 40))],
        ),
      ),
    );
  }

  Widget equipmentContainer(int index) {
    return Container(
      height: 70,
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(equipmentList[index], style: TextStyle(fontSize: 20)),
          equipmentStatus[index]
              ? Text(
                'Работает',
                style: TextStyle(
                  backgroundColor: Colors.lightGreen,
                  color: Colors.white,
                  fontSize: 16,
                ),
              )
              : Text(
                'Не работает',
                style: TextStyle(backgroundColor: Colors.red, color: Colors.white, fontSize: 16),
              ),
        ],
      ),
    );
  }
}
