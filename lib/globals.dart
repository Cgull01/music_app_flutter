library Globals;

import 'package:flutter/material.dart';
import 'package:music_app/page_panager.dart';

PageManager pageManager = PageManager();

Route createRoute(var View) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => View,
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
