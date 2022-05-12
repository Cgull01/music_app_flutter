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
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
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
    );
  }
}
