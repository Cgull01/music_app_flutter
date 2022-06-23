import 'package:flutter/material.dart';
import 'package:music_app/widgets/bottom_music_bar.dart';
import 'package:music_app/globals.dart';
import 'package:music_app/notifiers/queue_button_notifier.dart';
import '../globals.dart' as globals;

class QueueView extends StatelessWidget {
  const QueueView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        globals.pageManager.queueButtonNotifier.value = QueueState.inactive;
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(42, 41, 45, 1),
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(42, 41, 45, 1),
          elevation: 0.0,
          flexibleSpace: GestureDetector(
            onPanUpdate: (details) {
              if (details.delta.dy > 0) {
                globals.pageManager.queueButtonNotifier.value = QueueState.inactive;

                Navigator.pop(context);
              }
            },
          ),
          leading: IconButton(
            icon: const Icon(Icons.keyboard_arrow_down),
            iconSize: 40,
            onPressed: () {
              globals.pageManager.queueButtonNotifier.value = QueueState.inactive;
              Navigator.pop(context);
            },
          ),
          title: const Text("Queue"),
        ),
        body: Column(
          children: const [
            PlaylistWidget(),
          ],
        ),
        bottomNavigationBar: const BottomMusicBar(),
      ),
    );
  }
}

class PlaylistWidget extends StatelessWidget {
  const PlaylistWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ValueListenableBuilder<List<MusicData>>(
        valueListenable: globals.pageManager.playlistNotifier,
        builder: (context, playlistTitles, _) {
          return ReorderableListView.builder(
            reverse: false,
            itemCount: playlistTitles.length,
            itemBuilder: (context, index) {
              if (index < globals.pageManager.getIndex()) {
                return Divider(
                  key: Key('$index'),
                  height: 0,
                  thickness: 0,
                  indent: 10,
                  endIndent: 30,
                  color: Colors.grey,
                );
              } else if (index == 0) {
                return ListTile(
                  key: Key('$index'),
                  title: Text(globals.pageManager.currentSongDataNotifier.value['title'], overflow: TextOverflow.ellipsis),
                  subtitle: Text(
                      '${globals.pageManager.currentSongDataNotifier.value['artist']} - ${globals.pageManager.currentSongDataNotifier.value['album']}',
                      overflow: TextOverflow.ellipsis),
                );
              } else {
                return QueueTile(key: Key('$index'), mData: playlistTitles[index], index: index);
              }
            },
            onReorder: (int oldIndex, int newIndex) {},
          );
        },
      ),
    );
  }
}

class QueueTile extends StatelessWidget {
  const QueueTile({
    Key? key,
    required this.mData,
    required this.index,
  }) : super(key: key);

  final MusicData mData;
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
            globals.pageManager.removeFromQueue(index);
            return false;
          },
          key: const ValueKey<int>(0),
          child: InkWell(
            onTap: (() async {
              globals.pageManager.bringSongToQueueTop(index, mData);
            }),
            child: ListTile(
              title: Text(mData.title.toString(), overflow: TextOverflow.ellipsis),
              subtitle: Text('${mData.artist.toString()} - ${mData.album.toString()}', overflow: TextOverflow.ellipsis),
              trailing: const Icon(Icons.drag_handle),
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
