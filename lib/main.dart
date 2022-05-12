import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_app/bottom_music_bar.dart';
import 'package:music_app/constants/routes.dart';
import 'package:music_app/homePageWidgets/folder_button.dart';
import 'package:music_app/homePageWidgets/mainmenu_button.dart';
import 'package:music_app/music_view.dart';

// FIRST: read and display music files, playlist names and stuff
// widgets for later use: tabs

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.black87, // navigation bar color
    systemNavigationBarIconBrightness: Brightness.light, //navigation bar icon
    systemNavigationBarDividerColor: Colors.greenAccent, //Navigation bar divider color

    statusBarColor: Colors.transparent, // status bar color
    statusBarIconBrightness: Brightness.light, //status barIcon Brightness
  ));
  runApp(
    MaterialApp(
      title: 'Music player',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromRGBO(16, 16, 16, 1),
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromRGBO(16, 16, 16, 1),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: const Color.fromRGBO(60, 60, 60, 1),
          ),
        ),
        bottomAppBarTheme: const BottomAppBarTheme(
          color: Color.fromRGBO(42, 41, 45, 1),
        ),
      ),
      home: MyHomePage(),
      routes: {
        musicRoute: (context) => const MusicView(),
        musicListViewRoute: (context) => const MusicListView(),
      },
    ),
  );
}

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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            Icon(Icons.search_rounded),
            Text(
              '[Search bar or somethin]',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                // fontFamily: 'Gothic A1',
              ),
            )
          ],
        ),
      ),
      body: ListView(
        children: [
          const MainMenuButton(icon: Icons.music_note_rounded, text: 'All songs'),
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
          const MainMenuButton(icon: Icons.favorite_rounded, text: 'Favorites'),
          const MainMenuButton(icon: Icons.timelapse_rounded, text: 'Recently played'),
        ],
      ),
      bottomNavigationBar: const BottomMusicBar(
        songName: 'Song Name',
        songArtist: 'Artist',
      ),
    );
  }
}

class MusicListView extends StatelessWidget {
  const MusicListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            Icon(Icons.search_rounded),
            Text(
              '[Search bar or somethin]',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                // fontFamily: 'Gothic A1',
              ),
            )
          ],
        ),
      ),
      body: ListView(),
      bottomNavigationBar: const BottomMusicBar(
        songName: 'asdf',
        songArtist: 'asdf',
      ),
    );
  }
}
