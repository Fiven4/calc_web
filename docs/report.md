# Практическая работа 1. Маршрутизация, формы и URL как состояние

## 1. Схема маршрутов

```
/                              HomeScreen
├── /calculator                CalculatorScreen   (форма)
│   └── /calculator/result     ResultScreen       ?a=…&op=…&b=…
├── /converter                 ConverterScreen    (форма)
│   └── /converter/result      ResultScreen       ?from=…&to=…&amount=…
└── (любой другой адрес)       NotFoundScreen     через errorBuilder
```

Маршруты результата вложены в маршруты форм (`routes: [GoRoute(path: 'result', …)]`), поэтому итоговые адреса `/calculator/result` и `/converter/result`. Вложенность даёт кнопку «назад» в строке заголовка и корректную историю браузера.

Во `main()` вызывается `usePathUrlStrategy()`, поэтому адреса без решётки (`/calculator`, а не `/#/calculator`). Приложение собрано через `MaterialApp.router(routerConfig: appRouter)`.

## 2. Как параметры попадают из формы в адрес и обратно

**Форма → адрес.** После нажатия «Вычислить» форма проверяется через `Form.validate()`. Если ошибок нет, экран собирает адрес и переходит на него:

```dart
final uri = Uri(
  path: '/calculator/result',
  queryParameters: {'a': a, 'op': _operation, 'b': b},
);
context.go(uri.toString());
```

Класс `Uri` сам кодирует спецсимволы. Это важно для операции `+`: в строке запроса незакодированный плюс означает пробел, а `Uri` превращает его в `%2B`. Запятая в числах заменяется точкой до сборки адреса.

**Адрес → экран.** Маршрут результата в `router.dart` читает `state.uri.queryParameters`, вызывает функцию из `lib/logic` (`calculate` или `convert`) и передаёт на экран готовый текст результата или текст ошибки. Экран результата ничего не знает о форме и не использует ни конструктор с данными формы, ни `extra`. Поэтому тот же результат получается при прямом открытии ссылки в новой вкладке и при перезагрузке страницы.

**Обработка некорректных адресов.** Функции `calculate` и `convert` принимают `String?` и никогда не бросают исключений, а возвращают `CalcFailure` / `ConvertFailure` с понятным сообщением:

| Адрес | Сообщение |
|---|---|
| `…/result?a=5&op=/&b=0` | Деление на ноль невозможно |
| `…/result?a=abc&op=%2B&b=2` | В адресе переданы не числа |
| `…/result?a=5&op=%5E&b=2` | Неизвестная операция |
| `…/result?a=5` | Не передан обязательный параметр (a, op или b) |
| `/qwerty` | экран 404 с адресом и кнопкой «На главную» |

**Дополнительно (оценка «5»).**
- Результат округляется до 8 знаков с отбрасыванием хвостовых нулей: `10 / 3 = 3.33333333`; конвертация — до 2 знаков.
- Тема (светлая / тёмная) и последняя пара валют сохраняются через `shared_preferences` (в браузере это `localStorage`) и восстанавливаются после перезагрузки.
- Формы и результат ограничены по ширине (`ConstrainedBox`, 400–420 px) и прокручиваются (`SingleChildScrollView`), поэтому раскладка работает от 360 до 1920 px.
- Логика вынесена в `lib/logic`; 13 модульных тестов в `test/logic_test.dart` и 6 тестов приложения в `test/app_test.dart`, всего 19 проверок, `flutter test` проходит.

## 3. Снимки экранов

### Android Studio

![Проект в Android Studio](screenshots/23-android-studio-project.png)

![Запуск тестов в Android Studio](screenshots/24-android-studio-tests.png)

### Основные экраны

| Главная | Калькулятор |
|---|---|
| ![](screenshots/01-home.png) | ![](screenshots/02-calculator-form.png) |

| Ошибки валидации | Заполненная форма |
|---|---|
| ![](screenshots/03-calculator-validation.png) | ![](screenshots/04-calculator-filled.png) |

### Результат и адресная строка

В адресной строке видны переданные параметры `a=10&op=/&b=3`.

![Результат вычисления](screenshots/05-calculator-result.png)

### Экраны ошибок

| Деление на ноль | Не числа |
|---|---|
| ![](screenshots/06-error-division-by-zero.png) | ![](screenshots/07-error-not-a-number.png) |

| Неизвестная операция | Нет параметра |
|---|---|
| ![](screenshots/08-error-unknown-operation.png) | ![](screenshots/09-error-missing-parameter.png) |

### Экран 404

![404](screenshots/10-not-found-404.png)

### Конвертер валют

| Форма | Пустое поле |
|---|---|
| ![](screenshots/11-converter-form.png) | ![](screenshots/12-converter-validation-empty.png) |

| Не число | Заполненная форма |
|---|---|
| ![](screenshots/13-converter-validation-not-a-number.png) | ![](screenshots/14-converter-filled.png) |

![Результат конвертации](screenshots/15-converter-result.png)

Последняя пара валют восстановлена после повторного открытия:

![Запомненная пара](screenshots/16-converter-remembered-pair.png)

### Тёмная тема

| Переключение | После перезагрузки страницы |
|---|---|
| ![](screenshots/17-dark-theme.png) | ![](screenshots/18-dark-theme-after-reload.png) |

### Адаптивность

| 360 px, калькулятор | 360 px, конвертер | 360 px, результат |
|---|---|---|
| ![](screenshots/19-width-360-calculator.png) | ![](screenshots/20-width-360-converter.png) | ![](screenshots/21-width-360-result.png) |

![1920 px](screenshots/22-width-1920-calculator.png)
