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
        left: 10,
        right: 30,
        top: 33,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            minimumSize: const Size(311, 63),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15), // <-- Radius
            ),
            textStyle: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              // fontFamily: 'Gothic A1',
            )),
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
    );
  }
}
