import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  String? userLogin;
  String? userPassword;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: AlignmentDirectional(0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: [
            Container(
              height: 100,
              width: 370,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 10,
                children: [
                  Container(
                    height: 56,
                    alignment: AlignmentDirectional(0, -1),
                    child: Text('Логин:'),
                  ),
                  SizedBox(
                    width: 300,
                    height: 84,
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Введите логин',
                      ),
                      onChanged: (value) => userLogin = value,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 100,
              width: 370,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 10,
                children: [
                  Container(
                    height: 56,
                    alignment: AlignmentDirectional(0, -1),
                    child: Text('Пароль:'),
                  ),
                  SizedBox(
                    width: 300,
                    height: 84,
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Введите логин',
                      ),
                      onChanged: (value) => userPassword = value,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
