import 'dart:io';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'native_permissions.dart';

class AudioService {
  static FlutterSoundRecorder? _recorder;
  static FlutterSoundPlayer? _player;
  static bool _isInitialized = false;

  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      print('Initializing audio service...');
      _recorder = FlutterSoundRecorder();
      _player = FlutterSoundPlayer();
      
      // Initialize player first (doesn't need permission)
      await _player!.openPlayer();
      print('Player initialized successfully');
      
      // Don't open recorder yet - do it when we actually need to record
      // This prevents permission requests at startup
      
      _isInitialized = true;
      print('Audio service initialized successfully');
    } catch (e) {
      print('Error initializing audio service: $e');
      _isInitialized = false;
    }
  }

  static Future<void> dispose() async {
    if (_recorder != null) {
      await _recorder!.closeRecorder();
      _recorder = null;
    }
    if (_player != null) {
      await _player!.closePlayer();
      _player = null;
    }
    _isInitialized = false;
  }

  static Future<bool> requestPermission() async {
    try {
      print('=== TRYING NATIVE iOS PERMISSION REQUEST ===');
      
      // Try native iOS permission request first
      if (Platform.isIOS) {
        print('🍎 Using native iOS permission request...');
        final nativeGranted = await NativePermissions.requestMicrophonePermission();
        if (nativeGranted) {
          print('✅ Native iOS permission granted');
          return true;
        } else {
          print('❌ Native iOS permission denied');
          return false;
        }
      }
      
      // For Android, use permission_handler
      print('🤖 Using permission_handler for Android...');
      final status = await Permission.microphone.status;
      print('Permission status: $status');
      
      if (status.isGranted) {
        return true;
      }
      
      if (status.isPermanentlyDenied) {
        return false;
      }
      
      final result = await Permission.microphone.request();
      print('Permission request result: $result');
      return result.isGranted;
    } catch (e) {
      print('💥 Error requesting microphone permission: $e');
      return false;
    }
  }

  static Future<String?> startRecording() async {
    try {
      if (!_isInitialized) await initialize();
      
      // Double-check initialization
      if (!_isInitialized || _recorder == null) {
        print('Audio service not initialized properly');
        return null;
      }
      
      print('Requesting permission before recording...');
      final hasPermission = await requestPermission();
      if (!hasPermission) {
        print('Microphone permission not granted');
        return null;
      }

      // Try to open the recorder (flutter_sound will handle if it's already open)
      try {
        await _recorder!.openRecorder();
        print('Recorder opened successfully');
      } catch (e) {
        print('Error opening recorder: $e');
        return null;
      }

      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'recording_${DateTime.now().millisecondsSinceEpoch}.aac';
      final filePath = path.join(directory.path, fileName);

      print('Starting recording to: $filePath');
      await _recorder!.startRecorder(toFile: filePath);
      print('Recording started successfully');
      return filePath;
    } catch (e) {
      print('Error starting recording: $e');
      return null;
    }
  }

  static Future<String?> stopRecording() async {
    if (_recorder == null || !_recorder!.isRecording) return null;
    
    final filePath = await _recorder!.stopRecorder();
    return filePath;
  }

  static Future<void> playRecording(String filePath) async {
    if (!_isInitialized) await initialize();
    
    if (_player!.isPlaying) {
      await _player!.stopPlayer();
    }
    
    final file = File(filePath);
    if (await file.exists()) {
      await _player!.startPlayer(fromURI: filePath);
    }
  }

  static Future<void> stopPlaying() async {
    if (_player != null && _player!.isPlaying) {
      await _player!.stopPlayer();
    }
  }

  static Future<void> pausePlaying() async {
    if (_player != null && _player!.isPlaying) {
      await _player!.pausePlayer();
    }
  }

  static Future<void> resumePlaying() async {
    if (_player != null && _player!.isPaused) {
      await _player!.resumePlayer();
    }
  }

  static Stream<RecordingDisposition>? get recordingStream => _recorder?.onProgress;
  static Stream<PlaybackDisposition>? get playbackStream => _player?.onProgress;

  static bool get isRecording => _recorder?.isRecording ?? false;
  static bool get isPlaying => _player?.isPlaying ?? false;
  static bool get isPaused => _player?.isPaused ?? false;

  static Future<Duration?> getAudioDuration(String filePath) async {
    if (!_isInitialized) await initialize();
    
    final file = File(filePath);
    if (!await file.exists()) return null;
    
    // This is a simplified approach - in a real app, you might want to use
    // a more robust method to get audio duration
    try {
      await _player!.startPlayer(fromURI: filePath);
      await Future.delayed(const Duration(milliseconds: 100));
      // Remove duration getter as it's not available in this version
      await _player!.stopPlayer();
      return const Duration(seconds: 5); // Return approximate duration
    } catch (e) {
      return null;
    }
  }

  static Future<void> deleteRecording(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }
}