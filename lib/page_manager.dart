import 'dart:developer';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'notifiers/play_button_notifier.dart';
import 'notifiers/progress_notifier.dart';
import 'notifiers/repeat_button_notifier.dart';
import 'notifiers/queue_button_notifier.dart';
import 'dart:developer' as dev_tools show log;
import 'package:get_it/get_it.dart';

class PageManager {
  final currentSongTitleNotifier = ValueNotifier<String>('');
  final playlistNotifier = ValueNotifier<List<MediaItem>>([]);
  final progressNotifier = ProgressNotifier();
  final repeatButtonNotifier = RepeatButtonNotifier();
  final isFirstSongNotifier = ValueNotifier<bool>(true);

  final playButtonNotifier = PlayButtonNotifier();
  final queueButtonNotifier = QueueButtonNotifier();

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

    _audioPlayer.playbackEventStream.listen((event) {}, onError: (Object e, StackTrace stackTrace) {
      log("Error occured: $e");
    });
    //_setInitialPlaylist();
    _listenForChangesInPlayerState();
    _listenForChangesInPlayerPosition();
    _listenForChangesInBufferedPosition();
    _listenForChangesInTotalDuration();
    _listenForChangesInSequenceState();
  }

  void stop() {
    _audioPlayer.stop();
  }

  void addToQueue(MediaItem m) {
    dev_tools.log("added ${m.title} to queue");

    _playlist.insert(
        _playlist.length,
        AudioSource.uri(
          Uri.parse(m.id),
          tag: MediaItem(id: m.id, title: m.title, artist: m.artist, album: m.album),
        ));
  }

  int getIndex() {
    return _audioPlayer.currentIndex ?? -1;
  }

  void playSelectedSong(MediaItem m) async {
    dev_tools.log("playing ${m.title} index: ${getIndex()}");
    //_playlist.add(AudioSource.uri(m.songPath.uri));
    int index;
    if (_audioPlayer.currentIndex == null) {
      index = _playlist.length;
    } else {
      index = _audioPlayer.currentIndex! + 1;
    }
    _playlist.insert(
        index,
        AudioSource.uri(
          Uri.parse(m.id),
          tag: MediaItem(id: m.id, title: m.title, artist: m.artist, album: m.album),
        ));

    await _audioPlayer.setAudioSource(_playlist);
    await _audioPlayer.seek(Duration.zero, index: index);

    if (_audioPlayer.playing == false && _playlist.length == 1) {
      play();
    }
  }

  void setPlaylist(List<MediaItem> P) async {
    _playlist = ConcatenatingAudioSource(
      children: P
          .map(
            (item) => AudioSource.uri(
              Uri.parse(item.id),
              tag: MediaItem(id: item.id, title: item.title, artist: item.artist, album: item.album),
            ),
          )
          .toList(),
    );

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

      dev_tools.log('Sequence state changed');

      // update current song title
      final currentItem = sequenceState.currentSource;
      final t = currentItem?.tag as MediaItem;
      currentSongTitleNotifier.value = t.title.toString();

      currentSongDataNotifier.value = {
        'title': t.title.toString(),
        'artist': t.artist.toString(),
        'album': t.album.toString(),
      };

      // update playlist
      final playlist = sequenceState.effectiveSequence;
      List<MediaItem> titles = [];
      for (int i = 0; i < playlist.length; i++) {
        var p = playlist[i];
        if (p.tag != null) {
          var c = p.tag as MediaItem;

          // if (i >= GetIndex()) {
          //   titles.add(c);
          // }
          titles.add(c);
        }
      }

      // songs added in queue, i think
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
    log("${playButtonNotifier.value}");
  }

  void pause() {
    _audioPlayer.pause();
    log("${playButtonNotifier.value}");
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

  void bringSongToQueueTop(int index, MediaItem m) {
    dev_tools.log("moved ${m.title} to the top");

    _playlist.removeAt(index);

    playSelectedSong(m);
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

  void removeFromQueue(int index) {
    dev_tools.log('Removed song from the queue');

    _playlist.removeAt(index);
  }
}
