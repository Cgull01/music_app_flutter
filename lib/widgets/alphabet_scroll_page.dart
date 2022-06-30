import 'dart:developer';
import 'dart:io';

import 'package:azlistview/azlistview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:music_app/globals.dart' as globals;
import 'package:music_app/views/music_list_viewer.dart';

class _AZItem extends ISuspensionBean {
  final String title;
  final String tag;
  _AZItem({required this.title, required this.tag});

  @override
  String getSuspensionTag() => tag;
}

class AlphabetScrollPage extends StatefulWidget {
  final List<globals.MusicData> items;

  const AlphabetScrollPage({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  State<AlphabetScrollPage> createState() => _AlphabetScrollPageState();
}

class _AlphabetScrollPageState extends State<AlphabetScrollPage> {
  List<_AZItem> items = [];
  @override
  void initState() {
    super.initState();

    List<String> titles = widget.items.map((e) => e.title).toList();
    initList(titles);
  }

  void initList(List<String> items) {
    this.items = items.map((e) => _AZItem(title: e.toString(), tag: e[0])).toList();
  }

  void refresh() {
    setState(() {
      items.removeAt(globals.removedSongIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AzListView(
        padding: const EdgeInsets.only(right: 5, left: 5),
        indexBarOptions: IndexBarOptions(
          needRebuild: true,
          selectItemDecoration: BoxDecoration(shape: BoxShape.circle, color: globals.colors['visual']),
        ),
        data: items,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return MusicTile(
            mData: widget.items[index],
            index: index,
            notifyParent: refresh,
          );
        });
  }
}

class MusicTile extends StatelessWidget {
  const MusicTile({
    Key? key,
    required this.mData,
    required this.index,
    required this.notifyParent,
  }) : super(key: key);

  final globals.MusicData mData;
  final int index;
  final Function() notifyParent;

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
          child: ListTile(
            onTap: () async {
              globals.pageManager.playSelectedSong(mData);
            },
            title: Text(mData.title.toString(), overflow: TextOverflow.ellipsis),
            trailing: PopupMenuButton(
              icon: const Icon(Icons.more_vert_rounded),
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                PopupMenuItem(
                  child: Row(
                    children: const [Icon(Icons.delete_outline), Text(' Delete song')],
                  ),
                  onTap: () {
                    File songToDelete = File(mData.songPath.path);
                    globals.activePlaylist.songs.removeAt(index);
                    songToDelete.delete().catchError(
                      (err) {
                        globals.showSnackBar(context, 'Error occured [$err]');
                      },
                    ).then((value) => globals.showSnackBar(context, 'Song deleted $index'));
                    globals.removedSongIndex = index;
                    notifyParent();
                  },
                ),
                PopupMenuItem(
                  child: Row(
                    children: const [Icon(Icons.queue_music_rounded), Text(' Add to queue')],
                  ),
                ),
                PopupMenuItem(
                  child: Row(
                    children: const [Icon(Icons.favorite_rounded), Text(' Add to favorites')],
                  ),
                ),
              ],
            ),
            subtitle: Text('${mData.artist.toString()} - ${mData.album.toString()}', overflow: TextOverflow.ellipsis),
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
