import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class FilePickerUtil {
  static final ImagePicker _picker = ImagePicker();

  /// Picks a single image and returns File?
  static Future<File?> pickImage({
    required bool isCamera,
    int imageQuality = 85,
    double? maxWidth,
    double? maxHeight,
    BuildContext? context, // optional for showing errors
  }) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: isCamera == true ? ImageSource.camera : ImageSource.gallery,
        imageQuality: imageQuality,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick image: ${e.toString()}')),
        );
      } else {
        debugPrint('ImagePicker Error: $e');
      }
      return null;
    }
  }

  /// Picks multiple images and returns List<File>
  static Future<List<File>> pickMultipleImages({
    int imageQuality = 80,
    double? maxWidth,
    double? maxHeight,
    int maxImages = 10, // you can limit if needed
    BuildContext? context,
  }) async {
    try {
      final List<XFile> pickedFiles = await _picker.pickMultiImage(
        imageQuality: imageQuality,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
      );

      // Convert XFile to File
      return pickedFiles.map((xfile) => File(xfile.path)).toList();
    } catch (e) {
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick images: ${e.toString()}')),
        );
      } else {
        debugPrint('ImagePicker Error: $e');
      }
      return [];
    }
  }

  /// Quick helpers for common use cases
  static Future<File?> pickFromGallery({
    int imageQuality = 85,
    double? maxWidth,
    double? maxHeight,
    BuildContext? context,
  }) async {
    return pickImage(
      isCamera: true,
      imageQuality: imageQuality,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      context: context,
    );
  }

  static Future<File?> pickFromCamera({
    int imageQuality = 90,
    double? maxWidth,
    double? maxHeight,
    BuildContext? context,
  }) async {
    return pickImage(
      isCamera: true,
      imageQuality: imageQuality,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      context: context,
    );
  }
}
