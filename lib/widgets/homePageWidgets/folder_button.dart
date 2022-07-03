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
      padding: const EdgeInsets.only(bottom: 8),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(6.0)),

        // border: Border(
        //   top: BorderSide(
        //     width: 1.5,
        //     color: globals.colors['accent'] ?? Colors.grey,
        //   ),
        // ),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: globals.colors['secondary'],
          minimumSize: const Size(114, 70),
        ),
        onPressed: () {
          globals.activePlaylist = playList;
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
