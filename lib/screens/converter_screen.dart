import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../logic/calculator.dart';
import '../logic/currency.dart';
import '../storage.dart';
import '../widgets/app_page.dart';

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  late String _from;
  late String _to;

  @override
  void initState() {
    super.initState();
    // Восстанавливаем последнюю выбранную пару, если она ещё допустима.
    final saved = AppStorage.lastPair;
    final valid =
        saved != null &&
        ratesPerUsd.containsKey(saved.$1) &&
        ratesPerUsd.containsKey(saved.$2);
    _from = valid ? saved.$1 : 'USD';
    _to = valid ? saved.$2 : 'RUB';
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  String? _amountValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Введите сумму';
    final amount = parseNumber(value);
    if (amount == null) return 'Это не число';
    if (amount < 0) return 'Сумма не может быть отрицательной';
    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    AppStorage.saveLastPair(_from, _to);

    final uri = Uri(
      path: '/converter/result',
      queryParameters: {
        'from': _from,
        'to': _to,
        'amount': _amountController.text.trim().replaceAll(',', '.'),
      },
    );
    context.go(uri.toString());
  }

  Widget _currencyField(
    String label,
    String value,
    ValueChanged<String> onChanged,
  ) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items: currencyCodes
          .map(
            (code) => DropdownMenuItem(
              value: code,
              child: Text('$code — ${currencyNames[code]}'),
            ),
          )
          .toList(),
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Конвертер валют',
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _currencyField(
              'Из валюты',
              _from,
              (v) => setState(() => _from = v),
            ),
            const SizedBox(height: 16),
            _currencyField('В валюту', _to, (v) => setState(() => _to = v)),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Сумма',
                border: OutlineInputBorder(),
              ),
              validator: _amountValidator,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _submit,
                child: const Text('Конвертировать'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
