import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:music_app/globals.dart' as globals;
import 'package:music_app/views/music_list_viewer.dart';

class FolderButton extends StatelessWidget {
  const FolderButton({
    required this.playList,
    Key? key,
  }) : super(key: key);

  final globals.Playlist playList;

  @override
  Widget build(BuildContext context) {
    globals.Playlist _playList = playList;

    return Container(
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
          primary: const Color.fromARGB(255, 34, 33, 33),
          minimumSize: const Size(114, 70),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MusicListViewer(
                songList: playList.songs,
                playListTitle: playList.title,
              ),
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _playList.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '${_playList.songs.length} songs',
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
