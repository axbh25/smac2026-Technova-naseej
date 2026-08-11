import 'dart:io';

import 'package:flutter/material.dart';
import 'package:naseej/core/theme/app_colors.dart';
import 'package:naseej/core/theme/app_spacing.dart';

class ContextPhotoCard extends StatelessWidget {
  const ContextPhotoCard({
    required this.photoPath,
    required this.isBusy,
    required this.title,
    required this.body,
    required this.addLabel,
    required this.replaceLabel,
    required this.removeLabel,
    required this.processingLabel,
    required this.privacyLabel,
    required this.unavailableLabel,
    required this.onAddOrReplace,
    required this.onRemove,
    this.errorMessage,
    super.key,
  });

  final String? photoPath;
  final bool isBusy;

  final String title;
  final String body;
  final String addLabel;
  final String replaceLabel;
  final String removeLabel;
  final String processingLabel;
  final String privacyLabel;
  final String unavailableLabel;
  final String? errorMessage;

  final VoidCallback onAddOrReplace;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final bool hasPhotoPath = photoPath != null && photoPath!.trim().isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Icon(
                Icons.photo_camera_outlined,
                color: AppColors.primary,
                size: 28,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(body, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
            ],
          ),
          if (hasPhotoPath) ...<Widget>[
            const SizedBox(height: AppSpacing.md),
            _PhotoPreview(
              photoPath: photoPath!,
              unavailableLabel: unavailableLabel,
            ),
          ],
          if (errorMessage != null) ...<Widget>[
            const SizedBox(height: AppSpacing.sm),
            Text(
              errorMessage!,
              key: const ValueKey<String>('context_photo_error'),
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.error),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          if (hasPhotoPath)
            Row(
              children: <Widget>[
                Expanded(
                  child: OutlinedButton.icon(
                    key: const ValueKey<String>('replace_context_photo_button'),
                    onPressed: isBusy ? null : onAddOrReplace,
                    icon: isBusy
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.photo_camera_outlined),
                    label: Text(isBusy ? processingLabel : replaceLabel),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: TextButton.icon(
                    key: const ValueKey<String>('remove_context_photo_button'),
                    onPressed: isBusy ? null : onRemove,
                    icon: const Icon(Icons.delete_outline_rounded),
                    label: Text(removeLabel),
                  ),
                ),
              ],
            )
          else
            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton.icon(
                key: const ValueKey<String>('add_context_photo_button'),
                onPressed: isBusy ? null : onAddOrReplace,
                icon: isBusy
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.add_a_photo_outlined),
                label: Text(isBusy ? processingLabel : addLabel),
              ),
            ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Icon(
                Icons.lock_outline_rounded,
                size: 18,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  privacyLabel,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PhotoPreview extends StatelessWidget {
  const _PhotoPreview({
    required this.photoPath,
    required this.unavailableLabel,
  });

  final String photoPath;
  final String unavailableLabel;

  @override
  Widget build(BuildContext context) {
    final File photoFile = File(photoPath);
    final bool exists = photoFile.existsSync();

    return ClipRRect(
      key: const ValueKey<String>('context_photo_selected'),
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: double.infinity,
        height: 180,
        child: exists
            ? Image.file(
                photoFile,
                fit: BoxFit.cover,
                cacheWidth: 1200,
                errorBuilder:
                    (
                      BuildContext context,
                      Object error,
                      StackTrace? stackTrace,
                    ) {
                      return _UnavailablePhoto(label: unavailableLabel);
                    },
              )
            : _UnavailablePhoto(label: unavailableLabel),
      ),
    );
  }
}

class _UnavailablePhoto extends StatelessWidget {
  const _UnavailablePhoto({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceSoft,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(
            Icons.broken_image_outlined,
            color: AppColors.textSecondary,
            size: 40,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
