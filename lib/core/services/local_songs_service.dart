import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class LocalSongsService {
  static const _channel = MethodChannel('com.auralis.app/local_songs');

  static final LocalSongsService _instance = LocalSongsService._();
  factory LocalSongsService() => _instance;
  LocalSongsService._();

  Future<List<Map<String, dynamic>>> querySongs() async {
    if (Platform.isAndroid) {
      final permission = await Permission.audio.status;
      if (!permission.isGranted) {
        final requested = await Permission.audio.request();
        if (!requested.isGranted) {
          return [];
        }
      }
    }

    final result = await _channel.invokeMethod<List>('querySongs');
    if (result == null) return [];
    return result.cast<Map>().map((m) => Map<String, dynamic>.from(m)).toList();
  }

  Future<Uint8List?> queryArtwork(int id, {int size = 500}) async {
    final result = await _channel.invokeMethod<Uint8List>('queryArtwork', {
      'id': id,
      'size': size,
    });
    return result;
  }

  Future<void> scanMedia(String path) async {
    await _channel.invokeMethod('scanMedia', {'path': path});
  }
}
