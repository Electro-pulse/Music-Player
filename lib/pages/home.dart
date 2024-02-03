// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:music_player/components/custom_drawer.dart';
import 'package:music_player/components/neumorphic_box.dart';
import 'package:music_player/models/playlist_provider.dart';
import 'package:music_player/pages/song.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  // Indicate if application has permission to the library.
  bool _hasPermission = false;

  // getting playlist provider
  late final dynamic playlistProvider;
  
  @override
  void initState() {
    super.initState();
    checkAndRequestPermissions();
    // get playlist provider
    playlistProvider = Provider.of<PlaylistProvider>(context,listen: false);
  }

  // Getting storage access
  checkAndRequestPermissions({bool retry = false}) async {
    // The param 'retryRequest' is false, by default.
    _hasPermission = await _audioQuery.checkAndRequest(
      retryRequest: retry,
    );

    // Only call update the UI if application has all required permissions.
    _hasPermission ? setState(() {}) : null;
  }
  //goToSong function
    void goToSong(int songIndex){

      //update current song index
      playlistProvider.currentSongIndex = songIndex;

      //navigate to song page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SongPage(),
        )
        );
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text("P L A Y L I S T"),
      ),
      drawer: const CustomDrawer(),
      body: !_hasPermission
            ? noAccessToLibraryWidget()
            : FutureBuilder(
              future: fetchAudioData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Display a loading indicator while fetching data
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  // Handle error state
                  return Text('Error: ${snapshot.error}');
                } else {
                  // Data has been successfully fetched, build your widgets
                  return Consumer<PlaylistProvider>(
                    builder: (context,value,child) {
                      //get the playlist
                      final List<SongModel> playlist = value.playlist;

                      if(playlist.isEmpty) return const Center(child: Text("Nothing Found"));
                      //returning list view UI
                      return ListView.builder(
                        itemCount: playlist.length,
                        itemBuilder: (context,index){
                        
                        //get individual song
                        final SongModel song = playlist[index];

                        // return list tile UI
                        return ListTile(
                          title: Text(song.title.split(RegExp(r'[-([]'))[0],style: const TextStyle(fontWeight: FontWeight.bold),),
                          subtitle: Text(song.artist ?? "Unknown"),
                          leading: QueryArtworkWidget(
                            nullArtworkWidget: const Icon(Icons.music_note),
                            keepOldArtwork: true,
                            artworkFit: BoxFit.fill,
                            id: song.id,
                            type: ArtworkType.AUDIO,
                            ),
                          onTap: () => goToSong(index),
                        );
                      }
                    );
                  }
          );
        }
      },
    ),
  ); 
}

  Future<void> fetchAudioData() async {
    final playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
    try {
      List<SongModel> audioList = await OnAudioQuery().querySongs();
      playlistProvider.setAudioList(audioList);
    } catch (e) {
        // Handle error, e.g., display an error message
        print('Error fetching audio data: $e');
    }
  }

  Widget noAccessToLibraryWidget() {
    return Center(
      child: NeuBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Application doesn't have access to the library...",
            style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => checkAndRequestPermissions(retry: true),
              child: const Text("Allow",style: TextStyle(fontSize: 16),),
            ),
          ],
        ),
      ),
    );
  }
}

