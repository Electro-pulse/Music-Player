import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:music_player/components/neumorphic_box.dart';
import 'package:music_player/models/playlist_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class SongPage extends StatelessWidget {
  const SongPage({super.key});

  String formatTime (Duration duration){
    String twoDigitSeconds = duration.inSeconds.remainder(60).toString().padLeft(2,'0');
    String formattedTime = "${duration.inMinutes}:$twoDigitSeconds";
    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaylistProvider> (
      builder: (context,value,child) {
        // Get Playlist
        final playlist = value.playlist;
        // Get current song index
        final currentSong = playlist[value.currentSongIndex ?? 0];

        //return scaffold UI
        return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 25,bottom: 25,right: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    // Custom app bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: (){
                            Navigator.pop(context);
                          }, 
                          icon: const Icon(Icons.arrow_back),
                        ),
                        const Text("P L A Y E R",style: TextStyle(fontSize: 18),),
                        IconButton(
                          onPressed: (){}, 
                          icon: const Icon(Icons.menu),
                        ),
                        ],
                      ),
                  ],
                ),
                Column(
                  children: [
                      //album artwork
                      SizedBox(
                        height: 400,
                        width: 400,
                        child: GestureDetector(
                          child: NeuBox(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                // artist image
                                SizedBox(
                                  height: 280,
                                  width: 280,
                                  child: QueryArtworkWidget(
                                    nullArtworkWidget: Lottie.asset("assets/lottie_icons/player.json"),
                                    keepOldArtwork: true,
                                    artworkQuality: FilterQuality.high,
                                    artworkBorder: BorderRadius.circular(8),
                                    id: currentSong.id,
                                    type: ArtworkType.AUDIO),
                                ),
                          
                                //song, artist name and fav icon
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 250,
                                          child: Text(currentSong.title.split(RegExp(r'[-([]'))[0],
                                          style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
                                          maxLines: 2,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 250,
                                          child: Text(currentSong.artist != null ? currentSong.artist!.split(RegExp(r'[-([]'))[0] : "Unknown",
                                          maxLines: 2,
                                          ),
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                      icon :value.isFav ?
                                      const Icon(Icons.favorite,color: Colors.green) :
                                      const Icon(Icons.favorite_border),
                                      onPressed: () => value.toggleFav(),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                
                      const SizedBox(height: 30,),
                
                      //song duration progress
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // start time
                                Text(formatTime(value.currentDuration)),
                                // shuffle icon
                                IconButton(
                                    icon :Icon(Icons.shuffle,
                                    color: value.isShuffle ? Colors.green : null),
                                    onPressed: () => value.shuffle(),
                                  ),
                                // repeat icon
                                IconButton(
                                    icon :Icon(Icons.repeat,
                                    color: value.isRepeat ? Colors.green : null),
                                    onPressed: () => value.loop(),
                                  ),
                                // end time
                                Text(formatTime(value.totalDuration)),
                              ],
                            ),
                
                            // customizing the slider
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 0),
                              ),
                              child: Slider(
                                min: 0,
                                max: value.totalDuration.inSeconds.toDouble() + 0.1,
                                value: value.currentDuration.inSeconds.toDouble(),
                                activeColor: Colors.green,
                                onChanged: (double double){},
                                onChangeEnd: (double double) => value.seek(Duration(seconds: double.toInt())),
                              ),
                            )
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 25),
                      
                      //playback controls
                      Row(
                        children: [
                          // skip previous 
                          Expanded(
                            child: GestureDetector(
                              onTap: value.playPreviousSong,
                              child: const NeuBox(child: Icon(Icons.skip_previous),
                              ),
                            )
                          ),
                
                          const SizedBox(width: 20,),
                
                          // play and pause
                          Expanded(
                          flex: 2,
                          child: GestureDetector(
                            onTap: value.pauseOrResume,
                            child: NeuBox(child: value.isPlaying?const Icon(Icons.pause):const Icon(Icons.play_arrow),
                            ),
                          ),
                          ),
                
                          const SizedBox(width: 25,),
                          
                          // skip forward
                          Expanded(child: GestureDetector(
                            onTap: value.playNextSong,
                            child: const NeuBox(child: Icon(Icons.skip_next),
                            ),
                          )
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20,)
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
