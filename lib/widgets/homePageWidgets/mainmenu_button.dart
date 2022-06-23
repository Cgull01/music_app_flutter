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
        decoration: const BoxDecoration(
          border: Border(
            left: BorderSide(width: 4.0, color: Colors.white),
          ),
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: const Color.fromARGB(255, 34, 33, 33),
            minimumSize: const Size(311, 63),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5), // <-- Radius
            ),
            textStyle: const TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.bold,
              // fontFamily: 'Gothic A1',
            ),
          ),
          onPressed: () {
            Navigator.pushNamed(context, routeName);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, size: 27),
                  Text(' $text'),
                ],
              ),
              const Icon(Icons.keyboard_arrow_right, size: 30),
            ],
          ),
        ),
      ),
    );
  }
}
