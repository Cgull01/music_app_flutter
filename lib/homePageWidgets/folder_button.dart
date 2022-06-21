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
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.white.withOpacity(0.05),
          spreadRadius: 1,
          blurRadius: 2,
          offset: const Offset(-2, -2), // changes position of shadow
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.8),
          spreadRadius: 1,
          blurRadius: 2,
          offset: const Offset(2.5, 3), // changes position of shadow
        ),
      ]),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: const Color.fromRGBO(16, 16, 16, 1),
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
