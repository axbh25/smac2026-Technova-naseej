import 'dart:io';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:naseej/core/photo/context_photo_service.dart';
import 'package:path_provider/path_provider.dart';

typedef SupportDirectoryProvider = Future<Directory> Function();

class DeviceContextPhotoService implements ContextPhotoService {
  DeviceContextPhotoService({
    ImagePicker? imagePicker,
    SupportDirectoryProvider? supportDirectoryProvider,
  }) : _imagePicker = imagePicker ?? ImagePicker(),
       _supportDirectoryProvider =
           supportDirectoryProvider ?? getApplicationSupportDirectory;

  static const int _maximumImageDimension = 1600;
  static const int _imageQuality = 82;

  final ImagePicker _imagePicker;
  final SupportDirectoryProvider _supportDirectoryProvider;

  @override
  Future<ContextPhotoResult> pickAndStorePhoto(
    ContextPhotoSource source,
  ) async {
    try {
      final XFile? selectedImage = await _imagePicker.pickImage(
        source: source == ContextPhotoSource.camera
            ? ImageSource.camera
            : ImageSource.gallery,
        maxWidth: _maximumImageDimension.toDouble(),
        maxHeight: _maximumImageDimension.toDouble(),
        imageQuality: _imageQuality,
        requestFullMetadata: false,
        preferredCameraDevice: CameraDevice.rear,
      );

      if (selectedImage == null) {
        return const ContextPhotoResult.cancelled();
      }

      return _copyIntoPrivateStorage(selectedImage);
    } on PlatformException catch (error) {
      return ContextPhotoResult.failed(_mapPlatformException(error));
    } on FileSystemException {
      return const ContextPhotoResult.failed(
        ContextPhotoFailure.storageFailure,
      );
    } catch (_) {
      return const ContextPhotoResult.failed(ContextPhotoFailure.unknown);
    }
  }

  @override
  Future<ContextPhotoResult?> recoverLostPhoto() async {
    try {
      final LostDataResponse response = await _imagePicker.retrieveLostData();

      if (response.isEmpty) {
        return null;
      }

      final List<XFile>? files = response.files;

      if (files != null && files.isNotEmpty) {
        return _copyIntoPrivateStorage(files.first);
      }

      final PlatformException? exception = response.exception;

      if (exception != null) {
        return ContextPhotoResult.failed(_mapPlatformException(exception));
      }

      return const ContextPhotoResult.failed(ContextPhotoFailure.unknown);
    } on PlatformException catch (error) {
      return ContextPhotoResult.failed(_mapPlatformException(error));
    } on FileSystemException {
      return const ContextPhotoResult.failed(
        ContextPhotoFailure.storageFailure,
      );
    } catch (_) {
      return const ContextPhotoResult.failed(ContextPhotoFailure.unknown);
    }
  }

  @override
  Future<void> deleteStoredPhoto(String? storedPath) async {
    if (storedPath == null || storedPath.trim().isEmpty) {
      return;
    }

    final Directory photoDirectory = await _getContextPhotoDirectory();

    final String allowedPrefix =
        '${photoDirectory.absolute.path}${Platform.pathSeparator}';

    final File candidateFile = File(storedPath);
    final String candidatePath = candidateFile.absolute.path;

    if (!candidatePath.startsWith(allowedPrefix)) {
      return;
    }

    if (await candidateFile.exists()) {
      await candidateFile.delete();
    }
  }

  Future<ContextPhotoResult> _copyIntoPrivateStorage(
    XFile selectedImage,
  ) async {
    try {
      final File sourceFile = File(selectedImage.path);

      if (!await sourceFile.exists()) {
        return const ContextPhotoResult.failed(ContextPhotoFailure.invalidFile);
      }

      final Directory photoDirectory = await _getContextPhotoDirectory();

      final String extension = _safeExtension(
        selectedImage.name.isNotEmpty ? selectedImage.name : selectedImage.path,
      );

      final String fileName =
          'context_${DateTime.now().microsecondsSinceEpoch}$extension';

      final String destinationPath =
          '${photoDirectory.path}${Platform.pathSeparator}$fileName';

      final File copiedFile = await sourceFile.copy(destinationPath);

      return ContextPhotoResult.selected(copiedFile.path);
    } on FileSystemException {
      return const ContextPhotoResult.failed(
        ContextPhotoFailure.storageFailure,
      );
    } catch (_) {
      return const ContextPhotoResult.failed(ContextPhotoFailure.unknown);
    }
  }

  Future<Directory> _getContextPhotoDirectory() async {
    final Directory supportDirectory = await _supportDirectoryProvider();

    final Directory photoDirectory = Directory(
      '${supportDirectory.path}'
      '${Platform.pathSeparator}'
      'context_photos',
    );

    if (!await photoDirectory.exists()) {
      await photoDirectory.create(recursive: true);
    }

    return photoDirectory;
  }

  ContextPhotoFailure _mapPlatformException(PlatformException exception) {
    final String code = exception.code.toLowerCase();

    if (code.contains('denied') ||
        code.contains('restricted') ||
        code.contains('permission')) {
      return ContextPhotoFailure.permissionDenied;
    }

    if (code.contains('unavailable') ||
        code.contains('no_available_camera') ||
        code.contains('source_not_supported')) {
      return ContextPhotoFailure.sourceUnavailable;
    }

    return ContextPhotoFailure.unknown;
  }

  String _safeExtension(String sourceName) {
    final String normalizedName = sourceName.toLowerCase();

    const List<String> supportedExtensions = <String>[
      '.jpg',
      '.jpeg',
      '.png',
      '.webp',
      '.heic',
      '.heif',
    ];

    for (final String extension in supportedExtensions) {
      if (normalizedName.endsWith(extension)) {
        return extension;
      }
    }

    return '.jpg';
  }
}
