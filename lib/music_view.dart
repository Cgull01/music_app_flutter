import 'package:flutter/material.dart';

class MusicView extends StatelessWidget {
  const MusicView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(42, 41, 45, 1),
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
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SizedBox(
                height: 250,
                width: 250,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.all(Radius.circular(46))),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: const [
                      Text(
                        'Song name',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          // fontFamily: 'Gothic A1',
                        ),
                      )
                    ]),
                    Row(children: const [
                      Padding(
                        padding: EdgeInsets.only(top: 13),
                        child: Text(
                          'Artist name',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,

                            // fontFamily: 'Gothic A1',
                          ),
                        ),
                      )
                    ]),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.favorite_border_rounded),
                      iconSize: 40,
                      onPressed: () {},
                    )
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 114),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(left: 12),
                          child: Text(
                            '00:07',
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(right: 12),
                          child: Text(
                            '02:37',
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      ],
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Slider(
                        activeColor: const Color.fromARGB(255, 196, 196, 196),
                        inactiveColor: const Color.fromARGB(255, 75, 74, 74),
                        value: 20,
                        onChanged: (double value) {},
                        max: 100,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shuffle_rounded),
                      iconSize: 30,
                      onPressed: () {},
                    )
                  ],
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.skip_previous_rounded),
                          iconSize: 50,
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.play_circle_fill_rounded),
                          iconSize: 70,
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.skip_next_rounded),
                          iconSize: 50,
                          onPressed: () {},
                        ),
                      ],
                    )
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.queue_music_rounded),
                      iconSize: 30,
                      onPressed: () {},
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
