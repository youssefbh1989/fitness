
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class ImageHelper {
  static final ImageHelper _instance = ImageHelper._internal();
  static final ImagePicker _picker = ImagePicker();
  static final Uuid _uuid = Uuid();
  
  factory ImageHelper() {
    return _instance;
  }
  
  ImageHelper._internal();
  
  // Pick image from gallery
  Future<File?> pickImageFromGallery({
    int maxWidth = 1080,
    int maxHeight = 1920,
    int quality = 90,
  }) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: maxWidth.toDouble(),
        maxHeight: maxHeight.toDouble(),
        imageQuality: quality,
      );
      
      if (pickedFile == null) {
        return null;
      }
      
      return File(pickedFile.path);
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }
  
  // Take a photo
  Future<File?> takePhoto({
    int maxWidth = 1080,
    int maxHeight = 1920,
    int quality = 90,
  }) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: maxWidth.toDouble(),
        maxHeight: maxHeight.toDouble(),
        imageQuality: quality,
      );
      
      if (pickedFile == null) {
        return null;
      }
      
      return File(pickedFile.path);
    } catch (e) {
      print('Error taking photo: $e');
      return null;
    }
  }
  
  // Compress image
  Future<File?> compressImage(File file, {
    int quality = 80,
    int targetWidth = 1080,
    int targetHeight = 1920,
  }) async {
    try {
      final dir = await getTemporaryDirectory();
      final targetPath = '${dir.path}/${_uuid.v4()}.jpg';
      
      final result = await FlutterImageCompress.compressAndGetFile(
        file.path,
        targetPath,
        quality: quality,
        minWidth: targetWidth,
        minHeight: targetHeight,
      );
      
      return result != null ? File(result.path) : null;
    } catch (e) {
      print('Error compressing image: $e');
      return null;
    }
  }
  
  // Cached network image builder with error handling
  static Widget cachedNetworkImageWithErrorHandling(
    String imageUrl, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) {
        return placeholder ?? 
          Container(
            color: Colors.grey[200],
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
      },
      errorWidget: (context, url, error) {
        print('Error loading image: $url, $error');
        return errorWidget ??
          Container(
            color: Colors.grey[300],
            child: const Center(
              child: Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 30,
              ),
            ),
          );
      },
    );
  }
  
  // Clear image cache
  static Future<void> clearImageCache() async {
    await DefaultCacheManager().emptyCache();
    imageCache.clear();
  }
  
  // Calculate image cache size
  static Future<String> getImageCacheSize() async {
    final cacheManager = DefaultCacheManager();
    final stats = await cacheManager.getCacheSize();
    
    // Convert bytes to readable format
    if (stats < 1024) {
      return '$stats B';
    } else if (stats < 1024 * 1024) {
      final kb = (stats / 1024).toStringAsFixed(2);
      return '$kb KB';
    } else {
      final mb = (stats / (1024 * 1024)).toStringAsFixed(2);
      return '$mb MB';
    }
  }
}
