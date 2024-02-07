import 'dart:io';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:uri_to_file/uri_to_file.dart';
class PlaylistProvider extends ChangeNotifier {

  bool _isLoading = true;
  bool _isFav = false;
  bool _isRepeat = false;
  bool _isShuffle = false;
  int tempIndex = 0;

  //playlist of songs
  late final List<SongModel> _playlist;

  int? _currentSongIndex;

  // A U D I O P L A Y E R
  final AudioPlayer _audioPlayer = AudioPlayer();
  final Random random = Random();

  // durations
  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;

  // constructor
  PlaylistProvider() {
    listenToDuration();
  }
  // initially not playing 
  bool _isPlaying = false;

  void setAudioList(List<SongModel> audioList) {
    _playlist = audioList;
    _isLoading = false;
    notifyListeners();
  }

  //toggling fav icon
  void toggleFav(){
    _isFav = !_isFav;
    notifyListeners();
  }

  // Shuffling songs
  void shuffle(){
    _isShuffle = !_isShuffle;
    notifyListeners();
  }

  // Looping the current song
  void loop() {
    _isRepeat = !_isRepeat;
    notifyListeners();
    }

  // play the song
  void play() async {
    await _audioPlayer.stop();
    // Get current song path
    String path =_playlist[currentSongIndex!].uri!;
    File file = await toFile(path);
    await _audioPlayer.play(DeviceFileSource(file.path),);
    _isPlaying = true;
    notifyListeners();
  }
  // pause current song
  void pause() async{
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  // resume playing 
  void resume() async{
    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  // pause or resume
  void pauseOrResume() {
    if(_isPlaying) {
      pause();
    }
    else {
      resume();
    }
    notifyListeners();
  }//play
  // seek to a specific position
  void seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  // play next song 
  void playNextSong() {
    if (_currentSongIndex != null){
      if(_isShuffle){
      _currentSongIndex = random.nextInt(_playlist.length);
      tempIndex = _currentSongIndex!;
      play();
      }
      else {
        if (_currentSongIndex! < _playlist.length-1){
        currentSongIndex = _currentSongIndex! + 1;
      }
      else{
        currentSongIndex = 0;
      }
      }
    }
    notifyListeners();
  }

  // play previous song
  void playPreviousSong() async {
      if(_currentSongIndex! > 0){
        currentSongIndex = _currentSongIndex! - 1;
      }
      else {
        currentSongIndex = _playlist.length - 1;
      }
    notifyListeners();
  }

  // listen to duration
  void listenToDuration(){

    // total duration
    _audioPlayer.onDurationChanged.listen((newDuration) {
      _totalDuration = newDuration;
      notifyListeners();
    });

    // current duration
    _audioPlayer.onPositionChanged.listen((newPosition) {
      _currentDuration = newPosition;
      notifyListeners();
    });

    // listen for song completion
    _audioPlayer.onPlayerComplete.listen((event) {
      if(_isRepeat){
        seek(Durations.short1);
        play();
      } else {
      playNextSong();
      }
      }
    );
  }
  

  // G E T T E R S
  List<SongModel> get playlist => _playlist;
  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;
  bool get isLoading => _isLoading;
  bool get isFav => _isFav;
  bool get isRepeat => _isRepeat;
  bool get isShuffle => _isShuffle;
  AudioPlayer get audioPlayer => _audioPlayer;

  //S E T T E R S
  set currentSongIndex(int? newIndex) {

    //update current song index
    _currentSongIndex = newIndex;
    if(newIndex != null) {
      play();
    }
    //update UI
    notifyListeners();
  }
}
