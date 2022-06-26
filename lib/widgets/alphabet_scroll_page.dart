import 'dart:developer';

import 'package:azlistview/azlistview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:music_app/globals.dart' as globals;
import 'package:music_app/views/music_list_viewer.dart';

class _AZItem extends ISuspensionBean {
  final String title;
  final String tag;
  _AZItem({required this.title, required this.tag});

  @override
  String getSuspensionTag() => tag;
}

class AlphabetScrollPage extends StatefulWidget {
  final List<String> items;

  const AlphabetScrollPage({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  State<AlphabetScrollPage> createState() => _AlphabetScrollPageState();
}

class _AlphabetScrollPageState extends State<AlphabetScrollPage> {
  List<_AZItem> items = [];
  @override
  void initState() {
    super.initState();

    initList(widget.items);
  }

  void initList(List<String> items) {
    this.items = items.map((e) => _AZItem(title: e.toString(), tag: e[0])).toList();
  }

  @override
  Widget build(BuildContext context) {
    return AzListView(
        indexBarOptions: const IndexBarOptions(
          needRebuild: true,
          selectItemDecoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
        ),
        data: items,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return MusicTile(mData: globals.allsongs[index], index: index);
        });
  }
}
