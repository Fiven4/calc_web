import 'package:calc_web/main.dart';
import 'package:calc_web/router.dart';
import 'package:calc_web/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await AppStorage.init();
    appRouter.go('/');
  });

  testWidgets('главная показывает кнопки перехода', (tester) async {
    await tester.pumpWidget(const CalcApp());
    await tester.pumpAndSettle();

    expect(find.text('Калькулятор'), findsOneWidget);
    expect(find.text('Конвертер валют'), findsOneWidget);
  });

  testWidgets('неизвестный адрес открывает экран 404', (tester) async {
    await tester.pumpWidget(const CalcApp());
    appRouter.go('/qwerty');
    await tester.pumpAndSettle();

    expect(find.text('404'), findsOneWidget);
    expect(find.textContaining('/qwerty'), findsOneWidget);
  });

  testWidgets('прямой адрес результата с ошибкой не падает', (tester) async {
    await tester.pumpWidget(const CalcApp());
    appRouter.go('/calculator/result?a=5&op=%2F&b=0');
    await tester.pumpAndSettle();

    expect(find.text('Деление на ноль невозможно'), findsOneWidget);
  });

  testWidgets('прямой адрес результата без параметров не падает', (
    tester,
  ) async {
    await tester.pumpWidget(const CalcApp());
    appRouter.go('/calculator/result');
    await tester.pumpAndSettle();

    expect(
      find.textContaining('Не передан обязательный параметр'),
      findsOneWidget,
    );
  });

  testWidgets('форма калькулятора не пускает дальше с пустыми полями', (
    tester,
  ) async {
    await tester.pumpWidget(const CalcApp());
    appRouter.go('/calculator');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Вычислить'));
    await tester.pumpAndSettle();

    expect(find.text('Введите число'), findsNWidgets(2));
    expect(find.text('Результат вычисления'), findsNothing);
  });

  testWidgets('переключатель темы сохраняет выбор', (tester) async {
    await tester.pumpWidget(const CalcApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.dark_mode));
    await tester.pumpAndSettle();

    expect(AppStorage.themeMode.value, ThemeMode.dark);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('theme_mode'), 'dark');
  });
}
