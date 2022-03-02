import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';


class Sound{
  AudioPlayer player = AudioPlayer();

  void play_sound(audioasset)async{
    ByteData bytes = await rootBundle.load(audioasset); //load audio from assets
    Uint8List audiobytes = bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
    int result = await player.playBytes(audiobytes);
    if(result == 1){ //play success
      print("audio is playing.");
    }else{
      print("Error while playing audio.");
    }
  }


}