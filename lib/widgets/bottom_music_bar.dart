import 'package:flutter/material.dart';
import 'package:music_app/widgets/common.dart' show PlayButton, NextSongButton;
import 'package:music_app/views/music_view.dart';
import 'package:music_app/notifiers/progress_notifier.dart';
import 'package:music_app/notifiers/queue_button_notifier.dart';
import 'package:music_app/views/queue_view.dart';
import '../globals.dart' as globals;

class BottomMusicBar extends StatelessWidget {
  const BottomMusicBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: globals.pageManager.currentSongTitleNotifier,
      builder: (_, data, __) {
        return BottomAppBar(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              Navigator.push(context, globals.createRoute(const MusicView()));
            },
            onPanUpdate: (details) {
              if (details.delta.dy < 0) {
                Navigator.push(context, globals.createRoute(const MusicView()));
              }
            },
            child: SizedBox(
              height: 69,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  ValueListenableBuilder<ProgressBarState>(
                    valueListenable: globals.pageManager.progressNotifier,
                    builder: (_, value, __) {
                      return LinearProgressIndicator(
                        color: globals.colors['visual'],
                        backgroundColor: globals.colors['secondary'],
                        minHeight: 4,
                        value: getMusicProgress(value), //((value.
                      );
                    },
                  ),
                  Row(
                    children: [
                      Column(
                        children: const [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 47,
                              width: 47,
                              child: DecoratedBox(
                                decoration: BoxDecoration(color: Colors.red),
                              ),
                            ),
                          )
                        ],
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    globals.pageManager.getCurrentSongData('title'),
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  globals.pageManager.getCurrentSongData('artist'),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          QueueButton(),
                          PlayButton(
                            iconSize: 30,
                          ),
                          NextSongButton(
                            iconSize: 30,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  double getMusicProgress(ProgressBarState value) {
    if ((value.current.inSeconds / value.total.inSeconds) > 1 || (value.current.inSeconds / value.total.inSeconds).isNaN) {
      return 0;
    } else {
      return value.current.inSeconds / value.total.inSeconds;
    }
  }
}

class QueueButton extends StatelessWidget {
  const QueueButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<QueueState>(
        valueListenable: globals.pageManager.queueButtonNotifier,
        builder: (_, isActive, __) {
          switch (isActive) {
            case QueueState.active:
              return IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                color: globals.colors['toggle'],
                onPressed: () {
                  globals.pageManager.queueButtonNotifier.value = QueueState.inactive;
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.queue_music_rounded),
                iconSize: 30,
              );

            case QueueState.inactive:
              return IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: () {
                  globals.pageManager.queueButtonNotifier.value = QueueState.active;
                  Navigator.push(context, globals.createRoute(const QueueView()));
                },
                icon: const Icon(Icons.queue_music_rounded),
                iconSize: 30,
              );
          }
        });
  }
}
