import 'package:just_audio/just_audio.dart';

class AudioUtil {
  static final AudioPlayer audioPlayer = AudioPlayer();

  static Future<void> loadAssetAudio() async {
    await audioPlayer.setAsset('assets/music/bg.mp3');
  }

  static void playBackgroundMusic() async {
    await audioPlayer.play();
  }

  static void stopBackgroundMusic() async {
    await audioPlayer.stop();
  }
}
