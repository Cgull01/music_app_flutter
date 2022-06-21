import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/main.dart';

import 'notifiers/play_button_notifier.dart';
import 'notifiers/progress_notifier.dart';
import 'notifiers/repeat_button_notifier.dart';

class PageManager {
  final currentSongTitleNotifier = ValueNotifier<String>('');
  final playlistNotifier = ValueNotifier<List<musicData>>([]);
  final progressNotifier = ProgressNotifier();
  final repeatButtonNotifier = RepeatButtonNotifier();
  final isFirstSongNotifier = ValueNotifier<bool>(true);
  final playButtonNotifier = PlayButtonNotifier();
  final isLastSongNotifier = ValueNotifier<bool>(true);
  final isShuffleModeEnabledNotifier = ValueNotifier<bool>(false);

  final currentSongDataNotifier = ValueNotifier<Map>({'title': "-", 'artist': "-", 'album': "-"});

  late AudioPlayer _audioPlayer;
  late ConcatenatingAudioSource _playlist;

  PageManager() {
    _init();
  }

  void _init() async {
    _audioPlayer = AudioPlayer();
    _playlist = ConcatenatingAudioSource(children: []);
    //_setInitialPlaylist();
    _listenForChangesInPlayerState();
    _listenForChangesInPlayerPosition();
    _listenForChangesInBufferedPosition();
    _listenForChangesInTotalDuration();
    _listenForChangesInSequenceState();
  }

  void AddToQueue(musicData m) {
    print("added ${m.Title} to queue");

    var index;
    if (_audioPlayer.currentIndex == null) {
      index = _playlist.length;
    } else {
      index = _audioPlayer.currentIndex! + 1;
    }
    _playlist.insert(
        _playlist.length,
        AudioSource.uri(
          m.songPath.uri,
          tag: musicData(songPath: m.songPath, Album: m.Album ?? "", Title: m.Title ?? "", Artist: m.Artist ?? ''),
        ));

    //_audioPlayer.setAudioSource(_playlist);
  }

  int GetIndex() {
    return _audioPlayer.currentIndex ?? -1;
  }

  void PlaySelectedSong(musicData m) async {
    print("playing ${m.Title}");
    //_playlist.add(AudioSource.uri(m.songPath.uri));
    var index;
    if (_audioPlayer.currentIndex == null) {
      index = _playlist.length;
    } else {
      index = _audioPlayer.currentIndex! + 1;
    }
    _playlist.insert(
        index,
        AudioSource.uri(
          m.songPath.uri,
          tag: musicData(songPath: m.songPath, Album: m.Album ?? "", Title: m.Title ?? "", Artist: m.Artist ?? ''),
        ));

    await _audioPlayer.setAudioSource(_playlist);
    await _audioPlayer.seek(Duration.zero, index: index);

    if (_audioPlayer.playing == false) {
      play();
    }
  }

  void setPlaylist(List<musicData> P) async {
    _playlist = ConcatenatingAudioSource(
      children: P
          .map(
            (item) => AudioSource.uri(
              item.songPath.uri,
              tag: musicData(songPath: item.songPath, Album: item.Album ?? "", Title: item.Title ?? "", Artist: item.Artist ?? ''),
            ),
          )
          .toList(),
    );

    for (int i = 0; i < P.length; i++) {
      print('$i : ${P[i].Title}');
    }

    await _audioPlayer.setAudioSource(_playlist);
  }

  void _listenForChangesInPlayerState() {
    _audioPlayer.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;
      if (processingState == ProcessingState.loading || processingState == ProcessingState.buffering) {
        playButtonNotifier.value = ButtonState.loading;
      } else if (!isPlaying) {
        playButtonNotifier.value = ButtonState.paused;
      } else if (processingState != ProcessingState.completed) {
        playButtonNotifier.value = ButtonState.playing;
      } else {
        _audioPlayer.seek(Duration.zero);
        _audioPlayer.pause();
      }
    });
  }

  void _listenForChangesInPlayerPosition() {
    _audioPlayer.positionStream.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });
  }

  void _listenForChangesInBufferedPosition() {
    _audioPlayer.bufferedPositionStream.listen((bufferedPosition) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: bufferedPosition,
        total: oldState.total,
      );
    });
  }

  void _listenForChangesInTotalDuration() {
    _audioPlayer.durationStream.listen((totalDuration) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: totalDuration ?? Duration.zero,
      );
    });
  }

  void _listenForChangesInSequenceState() {
    _audioPlayer.sequenceStateStream.listen((sequenceState) {
      if (sequenceState == null) return;

      // update current song title
      final currentItem = sequenceState.currentSource;
      final t = currentItem?.tag as musicData;
      currentSongTitleNotifier.value = t.Title.toString();

      currentSongDataNotifier.value = {
        'title': t.Title.toString(),
        'artist': t.Artist.toString(),
        'album': t.Album.toString(),
      };

      // update playlist
      final playlist = sequenceState.effectiveSequence;

      List<musicData> titles = [];
      for (int i = 0; i < playlist.length; i++) {
        var p = playlist[i];
        if (p.tag != null) {
          var c = p.tag as musicData;

          if (i >= GetIndex()) {
            titles.add(c);
          }
        }
      }

      //final titles = playlist.map((item) => item.tag as musicData).toList();

      playlistNotifier.value = titles;

      // update shuffle mode
      isShuffleModeEnabledNotifier.value = sequenceState.shuffleModeEnabled;

      // update previous and next buttons
      if (playlist.isEmpty || currentItem == null) {
        isFirstSongNotifier.value = true;
        isLastSongNotifier.value = true;
      } else {
        isFirstSongNotifier.value = playlist.first == currentItem;
        isLastSongNotifier.value = playlist.last == currentItem;
      }
    });
  }

  void play() async {
    _audioPlayer.play();
  }

  void pause() {
    _audioPlayer.pause();
  }

  void seek(Duration position) {
    _audioPlayer.seek(position);
  }

  void dispose() {
    _audioPlayer.dispose();
  }

  void onRepeatButtonPressed() {
    repeatButtonNotifier.nextState();
    switch (repeatButtonNotifier.value) {
      case RepeatState.off:
        _audioPlayer.setLoopMode(LoopMode.off);
        break;
      case RepeatState.repeatSong:
        _audioPlayer.setLoopMode(LoopMode.one);
        break;
      case RepeatState.repeatPlaylist:
        _audioPlayer.setLoopMode(LoopMode.all);
    }
  }

  void onPreviousSongButtonPressed() {
    _audioPlayer.seekToPrevious();
  }

  void onNextSongButtonPressed() {
    _audioPlayer.seekToNext();
  }

  void onShuffleButtonPressed() async {
    final enable = !_audioPlayer.shuffleModeEnabled;
    if (enable) {
      await _audioPlayer.shuffle();
    }
    await _audioPlayer.setShuffleModeEnabled(enable);
  }

  String getCurrentSongData(String key) {
    if (currentSongDataNotifier.value['title'] == null) {
      return "ERROR: missing key: {$key}";
    } else {
      return currentSongDataNotifier.value[key];
    }
  }

  // void addSong() {
  //   final songNumber = _playlist.length + 1;
  //   const prefix = 'https://www.soundhelix.com/examples/mp3';
  //   final song = Uri.parse('$prefix/SoundHelix-Song-$songNumber.mp3');
  //   _playlist.add(AudioSource.uri(song, tag: AudioMetadata(album: "", title: "Song ${songNumber}", artwork: '')));
  // }

  void removeSong() {
    final index = _playlist.length - 1;
    if (index < 0) return;
    _playlist.removeAt(index);
  }
}
