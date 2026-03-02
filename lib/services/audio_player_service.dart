import 'dart:typed_data';
import 'package:just_audio/just_audio.dart';

class AudioPlayerService {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> playBytes(List<int> bytes) async {
    try {
      // Stop any currently playing audio
      await _player.stop();

      // Clear previous source completely
      await _player.setAudioSource(
        AudioSource.uri(
          Uri.dataFromBytes(
            Uint8List.fromList(bytes),
            mimeType: 'audio/mpeg',
          ),
        ),
      );

      // Seek to beginning
      await _player.seek(Duration.zero);

      // Play fresh audio
      await _player.play();

    } catch (e) {
      print("Audio playback error: $e");
    }
  }

  static Future<void> stop() async {
    await _player.stop();
  }
}