import 'package:flutter/material.dart';
import 'package:music_app/main.dart';
import 'package:music_app/music_view.dart';
import 'package:music_app/notifiers/progress_notifier.dart';
import 'package:music_app/page_panager.dart';
import 'package:music_app/queue_view.dart';
import 'globals.dart' as globals;

class BottomMusicBar extends StatelessWidget {
  const BottomMusicBar({
    Key? key,
    required this.Pm,
  }) : super(key: key);

  final PageManager Pm;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Pm.currentSongTitleNotifier,
      builder: (_, data, __) {
        return BottomAppBar(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              Navigator.push(context, globals.createRoute(MusicView()));
            },
            onPanUpdate: (details) {
              if (details.delta.dy < 0) {
                Navigator.push(context, globals.createRoute(MusicView()));
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
                        color: Color.fromARGB(255, 95, 148, 163),
                        backgroundColor: Color.fromRGBO(42, 41, 45, 1),
                        minHeight: 4,
                        value: getMusicProgress(value), //((value.total.inSeconds - value.current.inSeconds) / value.total.inSeconds),
                      );
                    },
                  ),
                  // const LinearProgressIndicator(
                  //   color: Color.fromARGB(255, 95, 148, 163),
                  //   backgroundColor: Color.fromRGBO(16, 16, 16, 1),
                  //   // value: 0,
                  //   minHeight: 4,
                  //   value: 0.7,
                  // ),
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
                                      // fontFamily: 'Gothic A1',
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
                        children: [
                          QueueShowButton(),
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
