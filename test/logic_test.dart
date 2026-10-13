import 'package:calc_web/logic/calculator.dart';
import 'package:calc_web/logic/currency.dart';
import 'package:flutter_test/flutter_test.dart';

double _value(CalcResult r) => (r as CalcSuccess).value;
String _error(CalcResult r) => (r as CalcFailure).message;

void main() {
  group('calculate', () {
    test('четыре арифметические операции', () {
      expect(_value(calculate('2', '+', '3')), 5);
      expect(_value(calculate('2', '-', '3')), -1);
      expect(_value(calculate('2', '*', '3')), 6);
      expect(_value(calculate('6', '/', '3')), 2);
    });

    test('деление на ноль возвращает ошибку', () {
      expect(_error(calculate('5', '/', '0')), 'Деление на ноль невозможно');
    });

    test('нечисловой ввод возвращает ошибку', () {
      expect(_error(calculate('abc', '+', '1')), 'В адресе переданы не числа');
      expect(_error(calculate('1', '+', '')), 'В адресе переданы не числа');
      expect(_error(calculate('NaN', '+', '1')), 'В адресе переданы не числа');
      expect(
        _error(calculate('Infinity', '+', '1')),
        'В адресе переданы не числа',
      );
    });

    test('неизвестная операция возвращает ошибку', () {
      expect(_error(calculate('1', '^', '2')), 'Неизвестная операция');
    });

    test('отсутствующий параметр возвращает ошибку, а не исключение', () {
      expect(calculate(null, '+', '1'), isA<CalcFailure>());
      expect(calculate('1', null, '1'), isA<CalcFailure>());
      expect(calculate('1', '+', null), isA<CalcFailure>());
    });

    test('запятая принимается как десятичный разделитель', () {
      expect(_value(calculate('1,5', '+', '2,5')), 4);
    });

    test('пробел вместо «+» из строки запроса считается сложением', () {
      expect(_value(calculate('1', ' ', '2')), 3);
    });
  });

  group('formatNumber', () {
    test('округляет длинную дробь', () {
      expect(formatNumber(10 / 3), '3.33333333');
    });

    test('убирает хвостовые нули и точку у целых', () {
      expect(formatNumber(5.0), '5');
      expect(formatNumber(0.1 + 0.2), '0.3');
    });

    test('не выводит отрицательный ноль', () {
      expect(formatNumber(-0.0000000001), '0');
    });
  });

  group('convert', () {
    test('пересчёт через курс к доллару', () {
      final r = convert('USD', 'RUB', '10') as ConvertSuccess;
      expect(r.value, closeTo(925, 1e-9));
    });

    test('одинаковая валюта возвращает ту же сумму', () {
      final r = convert('EUR', 'EUR', '42.5') as ConvertSuccess;
      expect(r.value, closeTo(42.5, 1e-9));
    });

    test('неизвестная валюта и некорректная сумма дают ошибку', () {
      expect(convert('XXX', 'USD', '1'), isA<ConvertFailure>());
      expect(convert('USD', 'XXX', '1'), isA<ConvertFailure>());
      expect(convert('USD', 'EUR', 'abc'), isA<ConvertFailure>());
      expect(convert('USD', 'EUR', '-5'), isA<ConvertFailure>());
      expect(convert(null, 'EUR', '5'), isA<ConvertFailure>());
    });
  });
}
