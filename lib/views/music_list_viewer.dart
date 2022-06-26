import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:music_app/widgets/alphabet_scroll_page.dart';
import 'package:music_app/widgets/bottom_music_bar.dart';
import 'package:music_app/globals.dart' as globals;

class MusicListViewer extends StatefulWidget {
  const MusicListViewer({Key? key}) : super(key: key);

  @override
  State<MusicListViewer> createState() => _MusicListViewerState();
}

class _MusicListViewerState extends State<MusicListViewer> {
  @override
  void initState() {
    super.initState();
  }

  List items = ['yes', 'no', 'maybe'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
        title: const Text("All Songs"),
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
            child: AlphabetScrollPage(items: globals.allsongs.map((e) => e.title).toList()),
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
            color: Colors.green,
          ),
          confirmDismiss: (direction) async {
            globals.pageManager.addToQueue(mData);
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
        const Divider(
          height: 5,
          thickness: 0.75,
          indent: 10,
          endIndent: 30,
          color: Colors.grey,
        ),
      ],
    );
  }
}
