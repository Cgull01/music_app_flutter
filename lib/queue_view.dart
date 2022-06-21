import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:music_app/page_panager.dart';
import 'package:music_app/main.dart';
import 'globals.dart' as globals;

class QueueView extends StatelessWidget {
  const QueueView({Key? key}) : super(key: key);

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
            icon: const Icon(Icons.keyboard_arrow_down),
            iconSize: 40,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(
          children: [
            PlaylistWidget(),
          ],
        ));
  }
}
