import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_app/bottom_music_bar.dart';
import 'package:music_app/constants/routes.dart';
import 'package:music_app/homePageWidgets/folder_button.dart';
import 'package:music_app/homePageWidgets/mainmenu_button.dart';
import 'package:music_app/music_view.dart';
import 'package:permission_handler/permission_handler.dart';

// FIRST: read and display music files, playlist names and stuff
// Look into filemanager it uses permission_handler
// look into sample code and maybe try it
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
      home: const MyHomePage(),
      routes: {
        musicRoute: (context) => const MusicView(),
        musicListViewRoute: (context) => const MusicListViewer(),
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
          const MainMenuButton(
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
          const MainMenuButton(
            icon: Icons.favorite_rounded,
            text: 'Favorites',
            routeName: "",
          ),
          const MainMenuButton(
            icon: Icons.timelapse_rounded,
            text: 'Recently played',
            routeName: "",
          ),
        ],
      ),
      bottomNavigationBar: const BottomMusicBar(
        songName: 'Song Name',
        songArtist: 'Artist',
      ),
    );
  }
}

class MusicListViewer extends StatefulWidget {
  const MusicListViewer({Key? key}) : super(key: key);

  @override
  State<MusicListViewer> createState() => _MusicListViewerState();
}

class _MusicListViewerState extends State<MusicListViewer> {
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
        children: const [
          MusicTile(
            title: 'Song1',
            artist: 'Artist1',
            album: 'Album1',
          ),
          MusicTile(
            title: 'Song2',
            artist: 'Artist2',
            album: 'Album2',
          ),
          MusicTile(
            title: 'Song2',
            artist: 'Artist2',
            album: 'Album2',
          ),
        ],
      ),
      bottomNavigationBar: const BottomMusicBar(
        songName: 'asdf',
        songArtist: 'asdf',
      ),
    );
  }
}

class MusicTile extends StatelessWidget {
  const MusicTile({
    Key? key,
    required this.title,
    required this.artist,
    required this.album,
  }) : super(key: key);

  final String title;
  final String artist;
  final String album;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Dismissible(
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.green,
          ),
          confirmDismiss: (direction) async {
            return false;
          },
          key: ValueKey<int>(0),
          child: ListTile(
            title: Text(title),
            trailing: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert_rounded),
            ),
            // visualDensity: VisualDensity(vertical: -4),
            subtitle: Text('$artist - $album'),
          ),
        ),
        const Divider(
          height: 5,
          thickness: 0.75,
          indent: 10,
          endIndent: 30,
          color: Colors.grey,
        ),
      ],
    );
  }
}
