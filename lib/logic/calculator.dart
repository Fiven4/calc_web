sealed class CalcResult {
  const CalcResult();
}

class CalcSuccess extends CalcResult {
  final double value;
  const CalcSuccess(this.value);
}

class CalcFailure extends CalcResult {
  final String message;
  const CalcFailure(this.message);
}

double? parseNumber(String? raw) {
  if (raw == null) return null;
  final value = double.tryParse(raw.trim().replaceAll(',', '.'));
  if (value == null || !value.isFinite) return null;
  return value;
}

CalcResult calculate(String? rawA, String? rawOp, String? rawB) {
  if (rawA == null || rawOp == null || rawB == null) {
    return const CalcFailure('Не передан обязательный параметр (a, op или b)');
  }

  final a = parseNumber(rawA);
  final b = parseNumber(rawB);
  if (a == null || b == null) {
    return const CalcFailure('В адресе переданы не числа');
  }

  final op = rawOp.trim().isEmpty ? '+' : rawOp.trim();

  return switch (op) {
    '+' => CalcSuccess(a + b),
    '-' => CalcSuccess(a - b),
    '*' => CalcSuccess(a * b),
    '/' =>
      b == 0
          ? const CalcFailure('Деление на ноль невозможно')
          : CalcSuccess(a / b),
    _ => const CalcFailure('Неизвестная операция'),
  };
}

String formatNumber(double value, {int maxDecimals = 8}) {
  if (value.abs() >= 1e21) return value.toString();
  var text = value.toStringAsFixed(maxDecimals);
  if (text.contains('.')) {
    text = text.replaceFirst(RegExp(r'0+$'), '');
    text = text.replaceFirst(RegExp(r'\.$'), '');
  }
  return text == '-0' ? '0' : text;
}
