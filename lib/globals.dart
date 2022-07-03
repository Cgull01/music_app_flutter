library globals;

import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
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

List<MediaItem> allsongs = [];

List<Playlist> playLists = [];

late Playlist activePlaylist;

final isLoading = ValueNotifier<bool>(true);

late int removedSongIndex;

// class MusicData {
//   final FileSystemEntity songPath;
//   final String title;
//   final String? artist;
//   final String? album;
//   final String? artwork;

//   MusicData({
//     required this.songPath,
//     required this.title,
//     this.artist,
//     this.album,
//     this.artwork,
//   });
// }

class Playlist {
  final List<MediaItem> songs;
  String title;
  Playlist({
    required this.title,
    required this.songs,
  });
}

void showSnackBar(context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: const Color.fromRGBO(42, 41, 45, 1),
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white),
      ),
      duration: const Duration(milliseconds: 500),
      width: 180.0, // Width of the SnackBar.
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0, // Inner padding for SnackBar content.
        vertical: 8,
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
    ),
  );
}

const colors = {
  'primary': Color.fromRGBO(16, 16, 16, 1),
  'secondary': Color.fromRGBO(42, 41, 45, 1),
  'accent': Color.fromRGBO(158, 158, 158, 1),
  'musicViewTop': Colors.transparent,
  'adaptiveAccents': Color.fromARGB(30, 236, 132, 21),
  'animation': Color.fromARGB(45, 144, 121, 95),
  'visual': Color.fromARGB(255, 95, 148, 163),
  'toggle': Colors.red,
};
