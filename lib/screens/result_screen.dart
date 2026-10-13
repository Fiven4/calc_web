import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/app_page.dart';

/// Экран результата. Получает всё только из адреса (через router.dart),
/// поэтому работает и после перехода из формы, и при прямом открытии ссылки.
class ResultScreen extends StatelessWidget {
  final String title;
  final String expression;
  final String? resultText;
  final String? error;
  final String backPath;

  const ResultScreen({
    super.key,
    required this.title,
    required this.expression,
    required this.backPath,
    this.resultText,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final failed = error != null;

    return AppPage(
      title: title,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            color: failed ? scheme.errorContainer : scheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Icon(
                    failed ? Icons.error_outline : Icons.check_circle_outline,
                    size: 40,
                    color: failed
                        ? scheme.onErrorContainer
                        : scheme.onPrimaryContainer,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    expression,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    failed ? error! : '= $resultText',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: failed
                          ? scheme.onErrorContainer
                          : scheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => context.go(backPath),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Вернуться к форме'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => context.go('/'),
            icon: const Icon(Icons.home),
            label: const Text('На главную'),
          ),
        ],
      ),
    );
  }
}
