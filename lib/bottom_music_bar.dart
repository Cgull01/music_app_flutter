import 'package:flutter/material.dart';
import 'package:music_app/music_view.dart';

class BottomMusicBar extends StatelessWidget {
  const BottomMusicBar({
    Key? key,
    required this.songName,
    required this.songArtist,
  }) : super(key: key);

  final String songName;
  final String songArtist;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          Navigator.push(context, _createRoute());
        },
        onPanUpdate: (details) {
          if (details.delta.dy < 0) {
            Navigator.push(context, _createRoute());
          }
        },
        child: SizedBox(
          height: 69,
          child: Column(
            children: [
              const LinearProgressIndicator(
                color: Color.fromARGB(255, 95, 148, 163),
                backgroundColor: Color.fromRGBO(16, 16, 16, 1),
                // value: 0,
                minHeight: 4,
                value: 0.7,
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
                                songName,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  // fontFamily: 'Gothic A1',
                                ),
                              ),
                            ),
                            Text(songArtist),
                          ],
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onPressed: () {},
                        icon: const Icon(Icons.queue_music_rounded),
                        iconSize: 30,
                      ),
                      IconButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onPressed: () {},
                        icon: const Icon(Icons.play_arrow_rounded),
                        iconSize: 40,
                      ),
                      IconButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onPressed: () {},
                        icon: const Icon(Icons.skip_next_rounded),
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
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const MusicView(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 0.75);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
