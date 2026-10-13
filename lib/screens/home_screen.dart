import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/app_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Главная',
      maxWidth: 400,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FilledButton.icon(
            onPressed: () => context.go('/calculator'),
            icon: const Icon(Icons.calculate),
            label: const Text('Калькулятор'),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => context.go('/converter'),
            icon: const Icon(Icons.currency_exchange),
            label: const Text('Конвертер валют'),
          ),
        ],
      ),
    );
  }
}
