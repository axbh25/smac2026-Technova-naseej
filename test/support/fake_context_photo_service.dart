import 'package:naseej/core/photo/context_photo_service.dart';

class FakeContextPhotoService implements ContextPhotoService {
  FakeContextPhotoService({
    ContextPhotoResult? nextPickResult,
    this.recoveredResult,
    this.throwOnDelete = false,
  }) : nextPickResult = nextPickResult ?? const ContextPhotoResult.cancelled();

  ContextPhotoResult nextPickResult;
  ContextPhotoResult? recoveredResult;
  bool throwOnDelete;

  final List<ContextPhotoSource> requestedSources = <ContextPhotoSource>[];

  final List<String> deletedPaths = <String>[];

  @override
  Future<ContextPhotoResult> pickAndStorePhoto(
    ContextPhotoSource source,
  ) async {
    requestedSources.add(source);

    return nextPickResult;
  }

  @override
  Future<ContextPhotoResult?> recoverLostPhoto() async {
    final ContextPhotoResult? result = recoveredResult;

    recoveredResult = null;

    return result;
  }

  @override
  Future<void> deleteStoredPhoto(String? storedPath) async {
    if (throwOnDelete) {
      throw StateError('Intentional photo deletion failure.');
    }

    if (storedPath != null) {
      deletedPaths.add(storedPath);
    }
  }
}
