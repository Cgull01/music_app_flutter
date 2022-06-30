import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:music_app/widgets/bottom_music_bar.dart';
import 'package:music_app/widgets/common.dart';
import 'package:music_app/notifiers/progress_notifier.dart';
import '../globals.dart' as globals;

import 'package:flutter_svg/flutter_svg.dart';

class MusicView extends StatelessWidget {
  const MusicView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: globals.colors['musicViewTop'],
        elevation: 0.0,
        flexibleSpace: GestureDetector(
          onPanUpdate: (details) {
            if (details.delta.dy > 0) {
              Navigator.pop(context);
            }
          },
        ),
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down),
          iconSize: 40,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: globals.pageManager.currentSongTitleNotifier,
        builder: (_, data, __) {
          return Column(
            children: [
              Flexible(
                flex: 5,
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: (MediaQuery.of(context).size.width / 10)),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: const Icon(Icons.favorite_border_rounded),
                          iconSize: 30,
                          onPressed: () {},
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        'assets/images/CenterCircle.svg',
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        color: globals.colors['adaptiveAccents'],
                      ),
                    ),
                    const SongPictureAccent(fileName: 'assets/images/OffsetCircle1.svg'),
                    const SongPictureAccent(fileName: 'assets/images/OffsetCircle2.svg'),
                    const SongPictureAccent(fileName: 'assets/images/OffsetCircle3.svg'),
                    Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: MediaQuery.of(context).size.width / 4,
                        backgroundImage: const AssetImage('assets/images/placeholder.png'),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              child: Marquee(
                                blankSpace: 80,
                                velocity: 70,
                                text: globals.pageManager.getCurrentSongData('title'),
                                pauseAfterRound: const Duration(seconds: 2),
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Gothic A1',
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 13),
                              child: Text(
                                globals.pageManager.getCurrentSongData('artist'),
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Gothic A1',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 4,
                child: Container(
                  decoration: BoxDecoration(
                    color: globals.colors['secondary'],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.only(top: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: const [
                            Expanded(
                              child: AudioProgressBar(),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: const [
                                ShuffleButton(
                                  iconSize: 32,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: const [
                                    PreviousSongButton(
                                      iconSize: 36,
                                    ),
                                    PlayButton(
                                      iconSize: 64,
                                    ),
                                    NextSongButton(
                                      iconSize: 36,
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Column(
                              children: const [
                                QueueButton(),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Divider(
                                height: 5,
                                thickness: 0.45,
                                indent: 20,
                                endIndent: 20,
                                color: globals.colors['accent'],
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            PopupMenuButton(
                              icon: const Icon(Icons.more_vert_rounded),
                              iconSize: 30,
                              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                                PopupMenuItem(
                                  child: Row(
                                    children: const [Icon(Icons.delete_outline), Text(' Delete song')],
                                  ),
                                  onTap: () {
                                    File currentSong = File(globals.pageManager.playlistNotifier.value[globals.pageManager.getIndex()].songPath.path);

                                    currentSong.delete().catchError(
                                      (err) {
                                        globals.showSnackBar(context, 'Error occured [$err]');
                                      },
                                    ).then((value) => globals.showSnackBar(context, 'Song deleted'));
                                    globals.pageManager.onNextSongButtonPressed;
                                  },
                                ),
                              ],
                            ),

                            Flexible(
                              child: ValueListenableBuilder(
                                  valueListenable: globals.pageManager.currentSongTitleNotifier,
                                  builder: (_, __, ___) {
                                    int index = globals.pageManager.getIndex();
                                    String text = globals.pageManager.playlistNotifier.value.length > index + 2
                                        ? 'Next up: ${globals.pageManager.playlistNotifier.value[index + 1].title} and ${globals.pageManager.playlistNotifier.value.length - (index + 2)} more'
                                        : globals.pageManager.playlistNotifier.value.length > index + 1
                                            ? 'Next up: ${globals.pageManager.playlistNotifier.value[index + 1].title} '
                                            : "";
                                    return Text(
                                      text,
                                      overflow: TextOverflow.ellipsis,
                                    );
                                  }),
                            ),

                            // const Text(globals.pageManager.playlistNotifier.length > 0?"Next up: song1 • song 2 • song3 and 3 more")
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class SongPictureAccent extends StatefulWidget {
  final String fileName;

  const SongPictureAccent({Key? key, required this.fileName}) : super(key: key);

  @override
  State<SongPictureAccent> createState() => _SongPictureAccentState();
}

/// AnimationControllers can be created with `vsync: this` because of TickerProviderStateMixin.
class _SongPictureAccentState extends State<SongPictureAccent> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 10),
    vsync: this,
  )..repeat(reverse: false);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.linear,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _animation,
      child: Align(
        alignment: Alignment.center,
        child: SvgPicture.asset(
          widget.fileName,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: globals.colors['animation'],
        ),
      ),
    );
  }
}

class AudioProgressBar extends StatelessWidget {
  const AudioProgressBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ProgressBarState>(
      valueListenable: globals.pageManager.progressNotifier,
      builder: (_, value, __) {
        return SeekBar(
          position: value.current,
          duration: value.total,
          onChangeEnd: globals.pageManager.seek,
        );
      },
    );
  }
}
