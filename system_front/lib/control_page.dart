import 'package:flutter/material.dart';

class ControlPage extends StatelessWidget {
  const ControlPage({super.key});

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
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        title: Text(style: textStyle, 'Система мониторинга'),
      ),
      body: Row(
        children: [
          Container(
            alignment: Alignment(0, 1),

            width: MediaQuery.sizeOf(context).width * 0.2,
            color: Theme.of(context).colorScheme.primary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 10.0,
              children: [
                ElevatedButton(
                  style: style,
                  onPressed: () {},
                  child: Text(style: textStyle, 'Dashboard'),
                ),
                ElevatedButton(
                  style: style,
                  onPressed: () {},
                  child: Text(style: textStyle, 'Оборудование'),
                ),
                ElevatedButton(
                  style: style,
                  onPressed: () {},
                  child: Text(style: textStyle, 'Пользователи'),
                ),
                ElevatedButton(
                  style: style,
                  onPressed: () {},
                  child: Text(style: textStyle, 'Журнал'),
                ),
                ElevatedButton(
                  style: style,
                  onPressed: () {},
                  child: Text(style: textStyle, 'Настройки'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
