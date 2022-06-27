import 'package:flutter/material.dart';
import 'package:music_app/globals.dart' as globals;
import 'package:music_app/views/music_list_viewer.dart';

class MainMenuButton extends StatelessWidget {
  const MainMenuButton({
    Key? key,
    required this.icon,
    required this.text,
    required this.songsList,
    required this.playListTitle,
  }) : super(key: key);

  final IconData icon;
  final String text;
  final List<globals.MusicData> songsList;
  final String playListTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MusicListViewer(
                  songList: songsList,
                  playListTitle: playListTitle,
                ),
              ),
            );
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
