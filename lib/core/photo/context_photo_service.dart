enum ContextPhotoSource { camera, gallery }

enum ContextPhotoFailure {
  permissionDenied,
  sourceUnavailable,
  invalidFile,
  storageFailure,
  unknown,
}

class ContextPhotoResult {
  const ContextPhotoResult.selected(this.storedPath)
    : failure = null,
      cancelled = false;

  const ContextPhotoResult.cancelled()
    : storedPath = null,
      failure = null,
      cancelled = true;

  const ContextPhotoResult.failed(this.failure)
    : storedPath = null,
      cancelled = false;

  final String? storedPath;
  final ContextPhotoFailure? failure;
  final bool cancelled;

  bool get isSelected => storedPath != null;

  bool get hasFailure => failure != null;
}

abstract interface class ContextPhotoService {
  Future<ContextPhotoResult> pickAndStorePhoto(ContextPhotoSource source);

  Future<ContextPhotoResult?> recoverLostPhoto();

  Future<void> deleteStoredPhoto(String? storedPath);
}
