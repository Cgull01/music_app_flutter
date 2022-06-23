import 'package:flutter/material.dart';
import 'package:music_app/widgets/bottom_music_bar.dart';
import 'package:music_app/constants/routes.dart';
import 'package:music_app/globals.dart' as globals;

import '../widgets/homePageWidgets/folder_button.dart';
import '../widgets/homePageWidgets/mainmenu_button.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            labelText: "Search for songs",
            prefixIcon: const Icon(Icons.search_rounded),
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {},
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          MainMenuButton(
            icon: Icons.music_note_rounded,
            text: 'All songs',
            routeName: musicListViewRoute,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, top: 33),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.folder,
                        size: 20,
                      ),
                      Text(
                        ' Folders:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 60,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: const [
                      FolderButton(
                        title: 'folder1',
                        songCount: '123',
                      ),
                      SizedBox(
                        width: 18,
                      ),
                      FolderButton(
                        title: 'folder2',
                        songCount: '312',
                      ),
                      SizedBox(
                        width: 18,
                      ),
                      FolderButton(
                        title: 'folder3',
                        songCount: '123',
                      ),
                      SizedBox(
                        width: 18,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          MainMenuButton(
            icon: Icons.favorite_rounded,
            text: 'Favorites',
            routeName: "",
          ),
          MainMenuButton(
            icon: Icons.timelapse_rounded,
            text: 'Recently played',
            routeName: "",
          ),
        ],
      ),
      bottomNavigationBar: const BottomMusicBar(),
    );
  }
}
