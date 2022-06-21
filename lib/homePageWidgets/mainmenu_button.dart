import 'package:flutter/material.dart';

class MainMenuButton extends StatelessWidget {
  const MainMenuButton({
    Key? key,
    required this.icon,
    required this.text,
    required this.routeName,
  }) : super(key: key);

  final IconData icon;
  final String text;
  final String routeName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 30,
        top: 33,
      ),
      child: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(-2, -3), // changes position of shadow
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.8),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(2.5, 3), // changes position of shadow
          ),
        ]),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Color.fromRGBO(16, 16, 16, 1),
            minimumSize: const Size(311, 63),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5), // <-- Radius
            ),
            textStyle: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              // fontFamily: 'Gothic A1',
            ),
          ),
          onPressed: () {
            Navigator.pushNamed(context, routeName);
          },
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Icon(icon, size: 30),
                Text(text),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
