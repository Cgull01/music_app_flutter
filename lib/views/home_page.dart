import 'package:flutter/material.dart';
import 'package:music_app/widgets/bottom_music_bar.dart';
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
      body: Column(
        children: [
          MainMenuButton(
            songsList: globals.allsongs,
            icon: Icons.music_note_rounded,
            text: 'All songs',
            playListTitle: 'All songs',
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
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
                  height: MediaQuery.of(context).size.height / 2.8,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    reverse: false,
                    itemCount: globals.playLists.length,
                    itemBuilder: (context, index) {
                      globals.playLists[index].songs.sort((a, b) => a.title.compareTo(b.title));

                      return FolderButton(
                        playList: globals.playLists[index],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const MainMenuButton(
            songsList: [],
            icon: Icons.favorite_rounded,
            text: 'Favorites',
            playListTitle: "",
          ),
        ],
      ),
      bottomNavigationBar: const BottomMusicBar(),
    );
  }
}
