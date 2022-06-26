library globals;

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:music_app/page_manager.dart';

PageManager pageManager = PageManager();

Route createRoute(var view) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => view,
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

List<MusicData> allsongs = [];

List<Playlist> playLists = [];

int selectedPlaylistIndex = 0;

final allPlaylistsNotifier = ValueNotifier<List<Playlist>>([]);
final testingBool = ValueNotifier<bool>(true);

class MusicData {
  final FileSystemEntity songPath;
  final String title;
  final String? artist;
  final String? album;
  final String? artwork;

  MusicData({
    required this.songPath,
    required this.title,
    this.artist,
    this.album,
    this.artwork,
  });
}

class Playlist {
  final List<MusicData> songs;
  String title;
  Playlist({
    required this.title,
    required this.songs,
  });
}
