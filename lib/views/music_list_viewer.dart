import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:music_app/widgets/alphabet_scroll_page.dart';
import 'package:music_app/widgets/bottom_music_bar.dart';
import 'package:music_app/globals.dart' as globals;

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
        backgroundColor: globals.colors['primary'],
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
          // Expanded(
          //   child: ListView.builder(
          //     itemCount: globals.allsongs.length,
          //     itemBuilder: ((context, index) {
          //       return MusicTile(mData: globals.allsongs[index], index: index);
          //     }),
          //   ),
          // ),
          Expanded(
            child: AlphabetScrollPage(items: _songList),
          )
        ],
      ),
      bottomNavigationBar: const BottomMusicBar(),
    );
  }
}

class MusicTile extends StatelessWidget {
  const MusicTile({
    Key? key,
    required this.mData,
    required this.index,
  }) : super(key: key);

  final globals.MusicData mData;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Dismissible(
          direction: DismissDirection.endToStart,
          background: Container(
            color: globals.colors['secondary'],
            padding: const EdgeInsets.only(right: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Icon(Icons.keyboard_double_arrow_left_sharp),
                Text(
                  '          +',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Icon(Icons.queue_music_sharp),
              ],
            ),
          ),
          confirmDismiss: (direction) async {
            globals.pageManager.addToQueue(mData);
            globals.showSnackBar(context, 'Added to queue');
            return false;
          },
          key: const ValueKey<int>(0),
          child: InkWell(
            onTap: (() async {
              globals.pageManager.playSelectedSong(mData);
            }),
            child: ListTile(
              title: Text(mData.title.toString(), overflow: TextOverflow.ellipsis),
              trailing: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert_rounded),
              ),
              subtitle: Text('${mData.artist.toString()} - ${mData.album.toString()}', overflow: TextOverflow.ellipsis),
            ),
          ),
        ),
        Divider(
          height: 5,
          thickness: 0.75,
          indent: 10,
          endIndent: 30,
          color: globals.colors['accent'],
        ),
      ],
    );
  }
}
