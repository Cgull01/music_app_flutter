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
      alignment: Alignment.centerLeft,
      width: MediaQuery.of(context).size.width / 2,
      margin: const EdgeInsets.only(top: 6),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            width: 1.5,
            color: Color.fromARGB(255, 130, 130, 130),
          ),
        ),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Color.fromARGB(255, 34, 33, 33),
          minimumSize: const Size(114, 70),
        ),
        onPressed: () {},
        child: Container(
          padding: const EdgeInsets.only(top: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                '$songCount songs',
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
