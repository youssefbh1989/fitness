
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:ui' as ui;

class SocialSharingService {
  static final SocialSharingService _instance = SocialSharingService._internal();
  
  factory SocialSharingService() {
    return _instance;
  }
  
  SocialSharingService._internal();
  
  // Share text content
  Future<void> shareText({
    required String text,
    String? subject,
  }) async {
    try {
      await Share.share(
        text,
        subject: subject,
      );
    } catch (e) {
      print('Error sharing text: $e');
    }
  }
  
  // Share a single file
  Future<void> shareFile({
    required File file,
    String? text,
    String? subject,
  }) async {
    try {
      await Share.shareXFiles(
        [XFile(file.path)],
        text: text,
        subject: subject,
      );
    } catch (e) {
      print('Error sharing file: $e');
    }
  }
  
  // Share multiple files
  Future<void> shareFiles({
    required List<File> files,
    String? text,
    String? subject,
  }) async {
    try {
      await Share.shareXFiles(
        files.map((file) => XFile(file.path)).toList(),
        text: text,
        subject: subject,
      );
    } catch (e) {
      print('Error sharing files: $e');
    }
  }
  
  // Share a widget as an image
  Future<void> shareWidgetAsImage({
    required GlobalKey key,
    String? text,
    String? subject,
  }) async {
    try {
      final ByteData? byteData = await _captureWidgetAsImage(key);
      
      if (byteData != null) {
        final directory = await getTemporaryDirectory();
        final filePath = '${directory.path}/shared_image.png';
        
        final buffer = byteData.buffer;
        await File(filePath).writeAsBytes(
          buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
        );
        
        await shareFile(
          file: File(filePath),
          text: text,
          subject: subject,
        );
      }
    } catch (e) {
      print('Error sharing widget as image: $e');
    }
  }
  
  // Share workout
  Future<void> shareWorkout({
    required String workoutName,
    required int exercises,
    required int duration,
    required String difficultyLevel,
    File? workoutImage,
  }) async {
    final text = '''
Check out this workout I completed in my fitness app!

🏋️ $workoutName
💪 $exercises exercises
⏱️ $duration minutes
🔥 $difficultyLevel difficulty

Download the app to track your fitness journey!
''';

    try {
      if (workoutImage != null && await workoutImage.exists()) {
        await shareFile(
          file: workoutImage,
          text: text,
          subject: 'Check out my workout!',
        );
      } else {
        await shareText(
          text: text,
          subject: 'Check out my workout!',
        );
      }
    } catch (e) {
      print('Error sharing workout: $e');
    }
  }
  
  // Share achievement
  Future<void> shareAchievement({
    required String achievementName,
    required String achievementDescription,
    File? achievementImage,
  }) async {
    final text = '''
I just unlocked a new achievement in my fitness app!

🏆 $achievementName
📝 $achievementDescription

Download the app to start your fitness journey!
''';

    try {
      if (achievementImage != null && await achievementImage.exists()) {
        await shareFile(
          file: achievementImage,
          text: text,
          subject: 'I unlocked a new achievement!',
        );
      } else {
        await shareText(
          text: text,
          subject: 'I unlocked a new achievement!',
        );
      }
    } catch (e) {
      print('Error sharing achievement: $e');
    }
  }
  
  // Capture a widget as an image
  Future<ByteData?> _captureWidgetAsImage(GlobalKey key) async {
    if (key.currentContext == null) {
      return null;
    }
    
    RenderRepaintBoundary boundary = key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    return await image.toByteData(format: ui.ImageByteFormat.png);
  }
}
