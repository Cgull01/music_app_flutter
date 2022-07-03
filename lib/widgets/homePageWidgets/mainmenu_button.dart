import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
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
  final List<MediaItem> songsList;
  final String playListTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 33,
      ),
      child: Ink(
        height: 60,
        decoration: const BoxDecoration(
          gradient: LinearGradient(stops: [0.02, 0.02], colors: [Colors.white, Color.fromRGBO(42, 41, 45, 1)]),
          borderRadius: BorderRadius.all(
            Radius.circular(6.0),
          ),
        ),
        child: InkWell(
          onTap: () {
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
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Row(
                  children: [
                    Icon(icon, size: 27),
                    Text(
                      ' $text',
                      style: const TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.keyboard_arrow_right, size: 30),
            ],
          ),
        ),
      ),
    );
  }
}
