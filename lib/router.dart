import 'package:go_router/go_router.dart';

import 'logic/calculator.dart';
import 'logic/currency.dart';
import 'screens/calculator_screen.dart';
import 'screens/converter_screen.dart';
import 'screens/home_screen.dart';
import 'screens/not_found_screen.dart';
import 'screens/result_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/calculator',
      builder: (context, state) => const CalculatorScreen(),
      routes: [
        // Вложенный маршрут: итоговый адрес — /calculator/result
        GoRoute(
          path: 'result',
          builder: (context, state) {
            final q = state.uri.queryParameters;
            final result = calculate(q['a'], q['op'], q['b']);
            return ResultScreen(
              title: 'Результат вычисления',
              expression: '${q['a'] ?? '?'} ${q['op'] ?? '?'} ${q['b'] ?? '?'}',
              resultText: switch (result) {
                CalcSuccess(:final value) => formatNumber(value),
                CalcFailure() => null,
              },
              error: switch (result) {
                CalcSuccess() => null,
                CalcFailure(:final message) => message,
              },
              backPath: '/calculator',
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: '/converter',
      builder: (context, state) => const ConverterScreen(),
      routes: [
        GoRoute(
          path: 'result',
          builder: (context, state) {
            final q = state.uri.queryParameters;
            final result = convert(q['from'], q['to'], q['amount']);
            return ResultScreen(
              title: 'Результат конвертации',
              expression:
                  '${q['amount'] ?? '?'} ${q['from'] ?? '?'} → ${q['to'] ?? '?'}',
              resultText: switch (result) {
                ConvertSuccess(:final value) =>
                  '${formatNumber(value, maxDecimals: 2)} ${q['to']}',
                ConvertFailure() => null,
              },
              error: switch (result) {
                ConvertSuccess() => null,
                ConvertFailure(:final message) => message,
              },
              backPath: '/converter',
            );
          },
        ),
      ],
    ),
  ],
  // Аналог страницы 404: сюда попадают все неизвестные адреса
  errorBuilder: (context, state) =>
      NotFoundScreen(location: state.uri.toString()),
);
