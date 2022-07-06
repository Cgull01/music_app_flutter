import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_app/page_manager.dart';
import 'package:music_app/service_locator.dart';
import 'package:music_app/widgets/bottom_music_bar.dart';
import 'package:music_app/notifiers/queue_button_notifier.dart';
import '../globals.dart' as globals;

class QueueView extends StatelessWidget {
  const QueueView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();
    return WillPopScope(
      onWillPop: () async {
        pageManager.queueButtonNotifier.value = QueueState.inactive;
        return true;
      },
      child: Scaffold(
        backgroundColor: globals.colors['secondary'],
        appBar: AppBar(
          backgroundColor: globals.colors['secondary'],
          elevation: 0.0,
          flexibleSpace: GestureDetector(
            onPanUpdate: (details) {
              if (details.delta.dy > 0) {
                pageManager.queueButtonNotifier.value = QueueState.inactive;

                Navigator.pop(context);
              }
            },
          ),
          leading: IconButton(
            icon: const Icon(Icons.keyboard_arrow_down),
            iconSize: 40,
            onPressed: () {
              pageManager.queueButtonNotifier.value = QueueState.inactive;
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
    final pageManager = getIt<PageManager>();

    return Expanded(
      child: ValueListenableBuilder<List<MediaItem>>(
        valueListenable: pageManager.playlistNotifier,
        builder: (context, playlistTitles, _) {
          return ReorderableListView.builder(
            reverse: false,
            itemCount: playlistTitles.length,
            itemBuilder: (context, index) {
              if (/*index < pageManager.getIndex()*/ false) {
                return Divider(
                  key: Key('$index'),
                  height: 0,
                  thickness: 0,
                  indent: 10,
                  endIndent: 30,
                  color: globals.colors['accent'],
                );
              } else if (index == pageManager.getIndex()) {
                return ListTile(
                  tileColor: globals.colors['primary'],
                  key: Key('$index'),
                  title: Text(pageManager.currentSongDataNotifier.value['title'], overflow: TextOverflow.ellipsis),
                  subtitle: Text('${pageManager.currentSongDataNotifier.value['artist']} - ${pageManager.currentSongDataNotifier.value['album']}',
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

  final MediaItem mData;
  final int index;
  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();

    return Column(
      children: [
        Dismissible(
          direction: DismissDirection.endToStart,
          background: Container(
            color: globals.colors['primary'],
            padding: const EdgeInsets.only(right: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Icon(Icons.keyboard_double_arrow_left_sharp),
                Icon(Icons.delete_outline_outlined),
              ],
            ),
          ),
          confirmDismiss: (direction) async {
            globals.showSnackBar(context, 'Removed from queue');
            pageManager.removeFromQueue(index);
            return false;
          },
          key: const ValueKey<int>(0),
          child: InkWell(
            onTap: (() async {
              pageManager.bringSongToQueueTop(index, mData);
            }),
            child: ListTile(
              title: Text(mData.title.toString(), overflow: TextOverflow.ellipsis),
              subtitle: Text('${mData.artist.toString()} - ${mData.album.toString()}', overflow: TextOverflow.ellipsis),
              trailing: const Icon(Icons.drag_handle),
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
