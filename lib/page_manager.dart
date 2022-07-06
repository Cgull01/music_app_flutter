import 'dart:developer';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_app/playlist_repository.dart';
import 'package:music_app/service_locator.dart';
import 'notifiers/play_button_notifier.dart';
import 'notifiers/progress_notifier.dart';
import 'notifiers/repeat_button_notifier.dart';
import 'notifiers/queue_button_notifier.dart';
import 'dart:developer' as dev_tools show log;
import 'package:get_it/get_it.dart';

// class PageManager {
//   final currentSongTitleNotifier = ValueNotifier<String>('');
//   final playlistNotifier = ValueNotifier<List<MediaItem>>([]);
//   final progressNotifier = ProgressNotifier();
//   final repeatButtonNotifier = RepeatButtonNotifier();
//   final isFirstSongNotifier = ValueNotifier<bool>(true);

//   final playButtonNotifier = PlayButtonNotifier();
//   final queueButtonNotifier = QueueButtonNotifier();

//   final isLastSongNotifier = ValueNotifier<bool>(true);
//   final isShuffleModeEnabledNotifier = ValueNotifier<bool>(false);

//   final currentSongDataNotifier = ValueNotifier<Map>({'title': "-", 'artist': "-", 'album': "-"});

//   late AudioPlayer _audioPlayer;
//   late ConcatenatingAudioSource _playlist;

//   final _audiohandler = getIt<AudioHandler>();

//   PageManager() {
//     _init();
//   }

//   void _init() async {
//     //_setInitialPlaylist();
//     _listenForChangesInPlayerState();
//     _listenForChangesInPlayerPosition();
//     _listenForChangesInBufferedPosition();
//     _listenForChangesInTotalDuration();
//     _listenForChangesInSequenceState();
//   }

//   void stop() {
//     _audioPlayer.stop();
//   }

//   void addToQueue(MediaItem m) {
//     dev_tools.log("added ${m.title} to queue");

//     _playlist.insert(
//         _playlist.length,
//         AudioSource.uri(
//           Uri.parse(m.id),
//           tag: MediaItem(id: m.id, title: m.title, artist: m.artist, album: m.album),
//         ));
//   }

//   int getIndex() {
//     return _audioPlayer.currentIndex ?? -1;
//   }

//   void playSelectedSong(MediaItem m) async {
//     dev_tools.log("playing ${m.title} index: ${getIndex()}");
//     //_playlist.add(AudioSource.uri(m.songPath.uri));
//     int index;
//     if (_audioPlayer.currentIndex == null) {
//       index = _playlist.length;
//     } else {
//       index = _audioPlayer.currentIndex! + 1;
//     }
//     _playlist.insert(
//         index,
//         AudioSource.uri(
//           Uri.parse(m.id),
//           tag: MediaItem(id: m.id, title: m.title, artist: m.artist, album: m.album),
//         ));

//     await _audioPlayer.setAudioSource(_playlist);
//     await _audioPlayer.seek(Duration.zero, index: index);

//     if (_audioPlayer.playing == false && _playlist.length == 1) {
//       play();
//     }
//   }

//   void setPlaylist(List<MediaItem> P) async {
//     _playlist = ConcatenatingAudioSource(
//       children: P
//           .map(
//             (item) => AudioSource.uri(
//               Uri.parse(item.id),
//               tag: MediaItem(id: item.id, title: item.title, artist: item.artist, album: item.album),
//             ),
//           )
//           .toList(),
//     );

//     await _audioPlayer.setAudioSource(_playlist);
//   }

//   void _listenForChangesInPlayerState() {
//     _audioPlayer.playerStateStream.listen((playerState) {
//       final isPlaying = playerState.playing;
//       final processingState = playerState.processingState;
//       if (processingState == ProcessingState.loading || processingState == ProcessingState.buffering) {
//         playButtonNotifier.value = ButtonState.loading;
//       } else if (!isPlaying) {
//         playButtonNotifier.value = ButtonState.paused;
//       } else if (processingState != ProcessingState.completed) {
//         playButtonNotifier.value = ButtonState.playing;
//       } else {
//         _audioPlayer.seek(Duration.zero);
//         _audioPlayer.pause();
//       }
//     });
//   }

//   void _listenForChangesInPlayerPosition() {
//     _audioPlayer.positionStream.listen((position) {
//       final oldState = progressNotifier.value;
//       progressNotifier.value = ProgressBarState(
//         current: position,
//         buffered: oldState.buffered,
//         total: oldState.total,
//       );
//     });
//   }

//   void _listenForChangesInBufferedPosition() {
//     _audioPlayer.bufferedPositionStream.listen((bufferedPosition) {
//       final oldState = progressNotifier.value;
//       progressNotifier.value = ProgressBarState(
//         current: oldState.current,
//         buffered: bufferedPosition,
//         total: oldState.total,
//       );
//     });
//   }

//   void _listenForChangesInTotalDuration() {
//     _audioPlayer.durationStream.listen((totalDuration) {
//       final oldState = progressNotifier.value;
//       progressNotifier.value = ProgressBarState(
//         current: oldState.current,
//         buffered: oldState.buffered,
//         total: totalDuration ?? Duration.zero,
//       );
//     });
//   }

//   void _listenForChangesInSequenceState() {
//     _audioPlayer.sequenceStateStream.listen((sequenceState) {
//       if (sequenceState == null) return;

//       dev_tools.log('Sequence state changed');

//       // update current song title
//       final currentItem = sequenceState.currentSource;
//       final t = currentItem?.tag as MediaItem;
//       currentSongTitleNotifier.value = t.title.toString();

//       currentSongDataNotifier.value = {
//         'title': t.title.toString(),
//         'artist': t.artist.toString(),
//         'album': t.album.toString(),
//       };

//       // update playlist
//       final playlist = sequenceState.effectiveSequence;
//       List<MediaItem> titles = [];
//       for (int i = 0; i < playlist.length; i++) {
//         var p = playlist[i];
//         if (p.tag != null) {
//           var c = p.tag as MediaItem;

//           // if (i >= GetIndex()) {
//           //   titles.add(c);
//           // }
//           titles.add(c);
//         }
//       }

//       // songs added in queue, i think
//       playlistNotifier.value = titles;

//       // update shuffle mode
//       isShuffleModeEnabledNotifier.value = sequenceState.shuffleModeEnabled;

//       // update previous and next buttons
//       if (playlist.isEmpty || currentItem == null) {
//         isFirstSongNotifier.value = true;
//         isLastSongNotifier.value = true;
//       } else {
//         isFirstSongNotifier.value = playlist.first == currentItem;
//         isLastSongNotifier.value = playlist.last == currentItem;
//       }
//     });
//   }

//   void play() async {
//     _audioPlayer.play();
//     log("${playButtonNotifier.value}");
//   }

//   void pause() {
//     _audioPlayer.pause();
//     log("${playButtonNotifier.value}");
//   }

//   void seek(Duration position) {
//     _audioPlayer.seek(position);
//   }

//   void dispose() {
//     _audioPlayer.dispose();
//   }

//   void onRepeatButtonPressed() {
//     repeatButtonNotifier.nextState();
//     switch (repeatButtonNotifier.value) {
//       case RepeatState.off:
//         _audioPlayer.setLoopMode(LoopMode.off);
//         break;
//       case RepeatState.repeatSong:
//         _audioPlayer.setLoopMode(LoopMode.one);
//         break;
//       case RepeatState.repeatPlaylist:
//         _audioPlayer.setLoopMode(LoopMode.all);
//     }
//   }

//   void onPreviousSongButtonPressed() {
//     _audioPlayer.seekToPrevious();
//   }

//   void onNextSongButtonPressed() {
//     _audioPlayer.seekToNext();
//   }

//   void onShuffleButtonPressed() async {
//     final enable = !_audioPlayer.shuffleModeEnabled;
//     if (enable) {
//       await _audioPlayer.shuffle();
//     }
//     await _audioPlayer.setShuffleModeEnabled(enable);
//   }

//   void bringSongToQueueTop(int index, MediaItem m) {
//     dev_tools.log("moved ${m.title} to the top");

//     _playlist.removeAt(index);

//     playSelectedSong(m);
//   }

//   String getCurrentSongData(String key) {
//     if (currentSongDataNotifier.value['title'] == null) {
//       return "ERROR: missing key: {$key}";
//     } else {
//       return currentSongDataNotifier.value[key];
//     }
//   }

//   // void addSong() {
//   //   final songNumber = _playlist.length + 1;
//   //   const prefix = 'https://www.soundhelix.com/examples/mp3';
//   //   final song = Uri.parse('$prefix/SoundHelix-Song-$songNumber.mp3');
//   //   _playlist.add(AudioSource.uri(song, tag: AudioMetadata(album: "", title: "Song ${songNumber}", artwork: '')));
//   // }

//   void removeFromQueue(int index) {
//     dev_tools.log('Removed song from the queue');

//     _playlist.removeAt(index);
//   }
// }

class PageManager {
  // Listeners: Updates going to the UI
  final currentSongTitleNotifier = ValueNotifier<String>('');

  final queueButtonNotifier = QueueButtonNotifier();

  final currentSongDataNotifier = ValueNotifier<Map>({'title': '', 'artist': '', 'album': ''});

  final playlistNotifier = ValueNotifier<List<MediaItem>>([]);
  final progressNotifier = ProgressNotifier();
  final repeatButtonNotifier = RepeatButtonNotifier();
  final isFirstSongNotifier = ValueNotifier<bool>(true);
  final playButtonNotifier = PlayButtonNotifier();
  final isLastSongNotifier = ValueNotifier<bool>(true);
  final isShuffleModeEnabledNotifier = ValueNotifier<bool>(false);

  final _audioHandler = getIt<AudioHandler>();

  PageManager() {
    init();
  }
  // Events: Calls coming from the UI
  void init() async {
    // await _loadPlaylist();
    _listenToChangesInPlaylist();
    _listenToPlaybackState();
    _listenToCurrentPosition();
    _listenToBufferedPosition();
    _listenToTotalDuration();
    _listenToChangesInSong();
  }

  Future<void> _loadPlaylist() async {
    final songRepository = getIt<PlaylistRepository>();
    final playlist = await songRepository.fetchInitialPlaylist();
    final mediaItems = playlist
        .map((song) => MediaItem(
              id: song['id'] ?? '',
              album: song['album'] ?? '',
              title: song['title'] ?? '',
            ))
        .toList();
    _audioHandler.addQueueItems(mediaItems);
  }

  void _listenToChangesInPlaylist() {
    _audioHandler.queue.listen((playlist) {
      if (playlist.isEmpty) {
        playlistNotifier.value = [];
        currentSongTitleNotifier.value = '';
        currentSongDataNotifier.value = {'title': '', 'artist': '', 'album': ''};
        log('updated queue 1:${playlist.length}');
      } else {
        // final newList = playlist.map((item) => item.title).toList();
        final newList = playlist
            .map((item) => MediaItem(
                  id: item.id,
                  album: item.album,
                  title: item.title,
                ))
            .toList();

        log('updated queue 2:${playlist.length}');
        playlistNotifier.value = newList;
      }
      _updateSkipButtons();
    });
  }

  void _listenToPlaybackState() {
    _audioHandler.playbackState.listen((playbackState) {
      final isPlaying = playbackState.playing;
      final processingState = playbackState.processingState;
      if (processingState == AudioProcessingState.loading || processingState == AudioProcessingState.buffering) {
        playButtonNotifier.value = ButtonState.loading;
      } else if (!isPlaying) {
        playButtonNotifier.value = ButtonState.paused;
      } else if (processingState != AudioProcessingState.completed) {
        playButtonNotifier.value = ButtonState.playing;
      } else {
        _audioHandler.seek(Duration.zero);
        _audioHandler.pause();
      }
    });
  }

  void _listenToCurrentPosition() {
    AudioService.position.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });
  }

  void _listenToBufferedPosition() {
    _audioHandler.playbackState.listen((playbackState) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: playbackState.bufferedPosition,
        total: oldState.total,
      );
    });
  }

  void _listenToTotalDuration() {
    _audioHandler.mediaItem.listen((mediaItem) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: mediaItem?.duration ?? Duration.zero,
      );
    });
  }

  void _listenToChangesInSong() {
    _audioHandler.mediaItem.listen((mediaItem) {
      currentSongTitleNotifier.value = mediaItem?.title ?? '';
      currentSongDataNotifier.value = {'title': mediaItem?.title ?? '', 'artist': mediaItem?.artist ?? '', 'album': mediaItem?.album ?? ''};

      _updateSkipButtons();
    });
  }

  void _updateSkipButtons() {
    final mediaItem = _audioHandler.mediaItem.value;
    final playlist = _audioHandler.queue.value;
    if (playlist.length < 2 || mediaItem == null) {
      isFirstSongNotifier.value = true;
      isLastSongNotifier.value = true;
    } else {
      isFirstSongNotifier.value = playlist.first == mediaItem;
      isLastSongNotifier.value = playlist.last == mediaItem;
    }
  }

  void play() => _audioHandler.play();
  void pause() => _audioHandler.pause();

  void seek(Duration position) => _audioHandler.seek(position);

  void previous() => _audioHandler.skipToPrevious();
  void next() => _audioHandler.skipToNext();

  void repeat() {
    repeatButtonNotifier.nextState();
    final repeatMode = repeatButtonNotifier.value;
    switch (repeatMode) {
      case RepeatState.off:
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.none);
        break;
      case RepeatState.repeatSong:
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.one);
        break;
      case RepeatState.repeatPlaylist:
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.all);
        break;
    }
  }

  void shuffle() {
    final enable = !isShuffleModeEnabledNotifier.value;
    isShuffleModeEnabledNotifier.value = enable;
    if (enable) {
      _audioHandler.setShuffleMode(AudioServiceShuffleMode.all);
    } else {
      _audioHandler.setShuffleMode(AudioServiceShuffleMode.none);
    }
  }

  Future<void> add() async {
    final songRepository = getIt<PlaylistRepository>();
    final song = await songRepository.fetchAnotherSong();
    final mediaItem = MediaItem(
      id: song['id'] ?? '',
      album: song['album'] ?? '',
      title: song['title'] ?? '',
    );
    _audioHandler.addQueueItem(mediaItem);
  }

  void remove() {
    final lastIndex = _audioHandler.queue.value.length - 1;
    if (lastIndex < 0) return;
    _audioHandler.removeQueueItemAt(lastIndex);
  }

  void dispose() {
    _audioHandler.customAction('dispose');
  }

  void stop() {
    _audioHandler.stop();
  }

  void playSelectedSong(MediaItem m) async {
    _audioHandler.playMediaItem(m);
    log('clicked play');
  }

  void addToQueue(MediaItem m) async {
    _audioHandler.addQueueItem(m);
  }

// ! need fixing
  void setPlaylist(List<MediaItem> P) async {
    _audioHandler.addQueueItems(P);
    log('playing all songs');
  }

  int getIndex() {
    return _audioHandler.playbackState.value.queueIndex ?? 0;
  }

  void removeFromQueue(int index) {
    dev_tools.log('Removed song from the queue');

    _audioHandler.removeQueueItemAt(index);
  }

  void bringSongToQueueTop(int index, MediaItem m) {
    dev_tools.log("moved ${m.title} to the top");

    _audioHandler.insertQueueItem(index, m);

    playSelectedSong(m);
  }
}
