import 'calculator.dart';

/// Курсы заданы константами: сколько единиц валюты стоит 1 доллар США.
const Map<String, double> ratesPerUsd = {
  'USD': 1,
  'EUR': 0.92,
  'GBP': 0.79,
  'RUB': 92.5,
  'CNY': 7.24,
  'JPY': 151.3,
  'KZT': 470,
};

const Map<String, String> currencyNames = {
  'USD': 'Доллар США',
  'EUR': 'Евро',
  'GBP': 'Фунт стерлингов',
  'RUB': 'Российский рубль',
  'CNY': 'Китайский юань',
  'JPY': 'Японская иена',
  'KZT': 'Казахстанский тенге',
};

List<String> get currencyCodes => ratesPerUsd.keys.toList();

sealed class ConvertResult {
  const ConvertResult();
}

class ConvertSuccess extends ConvertResult {
  final double amount;
  final double value;
  const ConvertSuccess({required this.amount, required this.value});
}

class ConvertFailure extends ConvertResult {
  final String message;
  const ConvertFailure(this.message);
}

/// Переводит сумму из одной валюты в другую по «сырым» параметрам адреса.
ConvertResult convert(String? rawFrom, String? rawTo, String? rawAmount) {
  if (rawFrom == null || rawTo == null || rawAmount == null) {
    return const ConvertFailure(
      'Не передан обязательный параметр (from, to или amount)',
    );
  }

  final from = ratesPerUsd[rawFrom];
  final to = ratesPerUsd[rawTo];
  if (from == null) return ConvertFailure('Неизвестная валюта: $rawFrom');
  if (to == null) return ConvertFailure('Неизвестная валюта: $rawTo');

  final amount = parseNumber(rawAmount);
  if (amount == null) return const ConvertFailure('Сумма — не число');
  if (amount < 0) {
    return const ConvertFailure('Сумма не может быть отрицательной');
  }

  return ConvertSuccess(amount: amount, value: amount / from * to);
}
