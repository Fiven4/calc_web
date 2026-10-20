import 'package:flutter/material.dart';

import '../storage.dart';

class AppPage extends StatelessWidget {
  final String title;
  final Widget child;
  final double maxWidth;

  const AppPage({
    super.key,
    required this.title,
    required this.child,
    this.maxWidth = 420,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: FittedBox(fit: BoxFit.scaleDown, child: Text(title)),
        actions: [
          IconButton(
            tooltip: isDark ? 'Светлая тема' : 'Тёмная тема',
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => AppStorage.setDarkTheme(!isDark),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: child,
          ),
        ),
      ),
    );
  }
}
