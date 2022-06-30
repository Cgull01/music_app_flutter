import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:music_app/widgets/alphabet_scroll_page.dart';
import 'package:music_app/widgets/bottom_music_bar.dart';
import 'package:music_app/globals.dart' as globals;
import 'dart:io';

class MusicListViewer extends StatefulWidget {
  const MusicListViewer({Key? key, required this.songList, required this.playListTitle}) : super(key: key);

  final List<globals.MusicData> songList;
  final String playListTitle;

  @override
  State<MusicListViewer> createState() => _MusicListViewerState();
}

class _MusicListViewerState extends State<MusicListViewer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<globals.MusicData> _songList = widget.songList;
    String _playListTitle = widget.playListTitle;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: globals.colors['secondary'],
        elevation: 0.0,
        flexibleSpace: GestureDetector(
          onPanUpdate: (details) {
            if (details.delta.dy > 0) {
              Navigator.pop(context);
            }
          },
        ),
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_left),
          iconSize: 40,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(_playListTitle),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: InkWell(
              onTap: () {
                globals.pageManager.setPlaylist(_songList);
              },
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.play_circle_fill_rounded),
                    iconSize: 40,
                  ),
                  Text(
                    "Play all (${_songList.length})",
                    style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: AlphabetScrollPage(items: _songList),
          )
        ],
      ),
      bottomNavigationBar: const BottomMusicBar(),
    );
  }
}
