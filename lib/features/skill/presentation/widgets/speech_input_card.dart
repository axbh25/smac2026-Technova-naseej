import 'package:flutter/material.dart';
import 'package:naseej/core/theme/app_colors.dart';
import 'package:naseej/core/theme/app_spacing.dart';

class SpeechInputCard extends StatelessWidget {
  const SpeechInputCard({
    required this.isListening,
    required this.initializationAttempted,
    required this.isAvailable,
    required this.title,
    required this.body,
    required this.buttonLabel,
    required this.privacyLabel,
    required this.onPressed,
    this.errorMessage,
    super.key,
  });

  final bool isListening;
  final bool initializationAttempted;
  final bool isAvailable;

  final String title;
  final String body;
  final String buttonLabel;
  final String privacyLabel;
  final String? errorMessage;

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final bool permanentlyUnavailable =
        initializationAttempted && !isAvailable && !isListening;

    final Color statusColor = isListening
        ? AppColors.accent
        : AppColors.primary;

    return AnimatedContainer(
      key: const ValueKey<String>('speech_input_card'),
      duration: const Duration(milliseconds: 200),
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isListening ? AppColors.surfaceSoft : AppColors.surface,
        border: Border.all(
          color: isListening ? AppColors.accent : AppColors.border,
          width: isListening ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.surfaceSoft,
                  shape: BoxShape.circle,
                  border: Border.all(color: statusColor, width: 2),
                ),
                child: Icon(
                  isListening
                      ? Icons.graphic_eq_rounded
                      : permanentlyUnavailable
                      ? Icons.mic_off_rounded
                      : Icons.mic_rounded,
                  color: statusColor,
                  size: 30,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.xxs),
                    Semantics(
                      liveRegion: true,
                      child: Text(
                        body,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (errorMessage != null) ...<Widget>[
            const SizedBox(height: AppSpacing.sm),
            Text(
              errorMessage!,
              key: const ValueKey<String>('speech_fallback_message'),
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.error),
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Icon(
                Icons.privacy_tip_outlined,
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
          const SizedBox(height: AppSpacing.md),
          if (!permanentlyUnavailable)
            SizedBox(
              width: double.infinity,
              height: 56,
              child: isListening
                  ? FilledButton.icon(
                      key: const ValueKey<String>('speech_button'),
                      onPressed: onPressed,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.accent,
                      ),
                      icon: const Icon(Icons.stop_rounded),
                      label: Text(buttonLabel),
                    )
                  : OutlinedButton.icon(
                      key: const ValueKey<String>('speech_button'),
                      onPressed: onPressed,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      icon: const Icon(Icons.mic_rounded),
                      label: Text(buttonLabel),
                    ),
            ),
        ],
      ),
    );
  }
}
