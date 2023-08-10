import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class MusicPlayer with ChangeNotifier {
  AudioPlayer _audioPlayer = AudioPlayer(playerId: '1989coffee');
  AudioCache _audioCache = AudioCache();

  AudioPlayer get audioPlayer => _audioPlayer;
  AudioCache get audioCache => _audioCache;

  playSong(String filePath) async {
    await _audioPlayer.stop();
    await _audioPlayer.setSource(AssetSource(filePath));
    await _audioPlayer.resume();
    notifyListeners();
  }
}
