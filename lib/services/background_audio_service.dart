import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackgroundAudioService {
  BackgroundAudioService._();
  static final BackgroundAudioService instance = BackgroundAudioService._();

  late final AudioPlayer _player;
  bool _initialized = false;
  bool _musicEnabled = true;
  bool _voiceEnabled = true;

  bool get musicEnabled => _musicEnabled;
  bool get voiceEnabled => _voiceEnabled;

  Future<void> init() async {
    if (_initialized) return;
    final prefs = await SharedPreferences.getInstance();
    _musicEnabled = prefs.getBool('enable_background_music') ?? true;
    _voiceEnabled = prefs.getBool('enable_voice_instructions') ?? true;

    _player = AudioPlayer();
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());

    try {
      await _player.setAsset('MindPause_backround_music.mp3');
      _player.setLoopMode(LoopMode.one);
      if (_musicEnabled) {
        await _player.setVolume(0.7);
        await _player.play();
      } else {
        await _player.pause();
      }
    } catch (_) {
      // Ignore asset loading issues in debug flow.
    }

    _initialized = true;
  }

  Future<void> setMusicEnabled(bool enabled) async {
    _musicEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('enable_background_music', enabled);

    if (!_initialized) return;
    try {
      if (enabled) {
        if (_player.audioSource == null) {
          await _player.setAsset('MindPause_backround_music.mp3');
          _player.setLoopMode(LoopMode.one);
        }
        await _player.seek(Duration.zero);
        await _player.setVolume(0.7);
        await _player.play();
      } else {
        await _player.pause();
      }
    } catch (_) {
      // Ignore any player state errors
    }
  }

  Future<void> setVoiceEnabled(bool enabled) async {
    _voiceEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('enable_voice_instructions', enabled);
  }

  Future<void> duckForVoice() async {
    if (!_musicEnabled || !_initialized) return;
    await _player.setVolume(0.18);
  }

  Future<void> restoreVolumeAfterVoice() async {
    if (!_musicEnabled || !_initialized) return;
    await _player.setVolume(0.7);
  }
}
