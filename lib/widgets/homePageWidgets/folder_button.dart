import 'package:flutter/material.dart';

class FolderButton extends StatelessWidget {
  const FolderButton({
    required this.title,
    required this.songCount,
    Key? key,
  }) : super(key: key);

  final String title;
  final String songCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 6, bottom: 6, left: 6),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(width: 1.5, color: Color.fromARGB(255, 130, 130, 130)),
        ),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Color.fromARGB(255, 34, 33, 33),
          minimumSize: const Size(114, 70),
        ),
        onPressed: () {},
        child: Container(
          margin: const EdgeInsets.only(right: 22.0),
          padding: const EdgeInsets.only(top: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                '$songCount songs',
                style: const TextStyle(
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
