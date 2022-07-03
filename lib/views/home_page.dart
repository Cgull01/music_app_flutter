import 'dart:core';

import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_app/widgets/alphabet_scroll_page.dart';
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
        backgroundColor: globals.colors['secondary'],
        title: InkWell(
          onTap: () {
            showSearch(context: context, delegate: MySearchDelegate());
          },
          child: const Text(
            'Search for songs',
            style: TextStyle(fontWeight: FontWeight.normal),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: MySearchDelegate());
            },
            icon: const Icon(Icons.search_rounded),
            iconSize: 30,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 18),
            child: MainMenuButton(
              songsList: globals.allsongs,
              icon: Icons.music_note_rounded,
              text: 'All songs',
              playListTitle: 'All songs',
            ),
          ),
          const MainMenuButton(
            songsList: [],
            icon: Icons.favorite_rounded,
            text: 'Favorites',
            playListTitle: "",
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
        ],
      ),
      bottomNavigationBar: const BottomMusicBar(),
    );
  }
}

class MySearchDelegate extends SearchDelegate {
  // List<String> searchResults = ['asdf', 'aaaaa', 'lorema'];

  List<MediaItem> searchResults2 = globals.allsongs;

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          onPressed: () {
            if (query.isEmpty) {
              close(context, null);
            } else {
              query = '';
            }
          },
          icon: const Icon(Icons.clear),
        )
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        onPressed: () => close(context, null),
        icon: const Icon(Icons.arrow_back),
      );

  @override
  Widget buildResults(BuildContext context) => Center(
        child: Text(
          query,
          style: const TextStyle(
            fontSize: 30,
          ),
        ),
      );

  @override
  Widget buildSuggestions(BuildContext context) {
    List<MediaItem> suggestions2 = searchResults2.where((searchResult) {
      final title = searchResult.title.toLowerCase();
      final artist = searchResult.artist?.toLowerCase() ?? "";
      final album = searchResult.album?.toLowerCase() ?? "";

      final input = query.toLowerCase();

      return title.contains(input) || artist.contains(input) || album.contains(input);
    }).toList();

    return ListView.builder(
      itemCount: suggestions2.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions2[index];
        return MusicTile(mData: suggestion, index: index, notifyParent: () {});
      },
    );
  }
}
