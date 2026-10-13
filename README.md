# Калькулятор и конвертер валют на Flutter Web

Практическая работа 1. Маршрутизация, формы и URL как состояние.

Web-приложение на Flutter из трёх основных экранов: главная, калькулятор и конвертер валют. Результат показывается на отдельном экране, а все данные для него берутся только из адреса. Поэтому ссылку на результат можно открыть в новой вкладке, и экран восстановится целиком.

Разработка и запуск выполнены в Android Studio (устройство «Chrome (web)»).

![Проект в Android Studio](docs/screenshots/23-android-studio-project.png)

## Результат работы

### Главная, калькулятор, результат

| Главная | Калькулятор |
|---|---|
| ![Главная](docs/screenshots/01-home.png) | ![Форма калькулятора](docs/screenshots/02-calculator-form.png) |

| Валидация формы | Результат: параметры видны в адресной строке |
|---|---|
| ![Ошибки валидации](docs/screenshots/03-calculator-validation.png) | ![Результат](docs/screenshots/05-calculator-result.png) |

### Конвертер валют

| Форма | Результат |
|---|---|
| ![Форма конвертера](docs/screenshots/14-converter-filled.png) | ![Результат конвертации](docs/screenshots/15-converter-result.png) |

### Ошибки в адресе и страница 404

Открытие результата напрямую с некорректными параметрами не ломает приложение.

| Деление на ноль | Не числа |
|---|---|
| ![Деление на ноль](docs/screenshots/06-error-division-by-zero.png) | ![Не числа](docs/screenshots/07-error-not-a-number.png) |

| Неизвестная операция | Нет параметра |
|---|---|
| ![Неизвестная операция](docs/screenshots/08-error-unknown-operation.png) | ![Нет параметра](docs/screenshots/09-error-missing-parameter.png) |

![Экран 404](docs/screenshots/10-not-found-404.png)

### Тёмная тема и адаптивность

Тема и последняя пара валют сохраняются между перезагрузками страницы.

| Тёмная тема после перезагрузки | Ширина 360 px |
|---|---|
| ![Тёмная тема](docs/screenshots/18-dark-theme-after-reload.png) | ![360 px](docs/screenshots/19-width-360-calculator.png) |

### Тесты в Android Studio

![Тесты](docs/screenshots/24-android-studio-tests.png)

Полный набор снимков и пояснения: [docs/report.md](docs/report.md).

## Что реализовано

- Маршрутизация на `go_router`, адреса без решётки (`usePathUrlStrategy()`), `MaterialApp.router`.
- Три экрана и отдельные экраны результата. Данные передаются только через параметры адреса, без конструктора и `extra`.
- Формы на `Form` и `TextFormField` с проверкой: пустое и нечисловое значение не пропускаются. Запятая принимается как десятичный разделитель.
- Калькулятор: `+`, `-`, `*`, `/`. Конвертер: 7 валют, курсы заданы константами.
- Обработка некорректных адресов: деление на ноль, не числа, неизвестная операция, отсутствующий параметр, неизвестная валюта.
- Экран 404 через `errorBuilder`. Кнопка «назад» браузера возвращает на предыдущий экран приложения.
- Светлая и тёмная тема с сохранением выбора. Конвертер запоминает последнюю пару валют.
- Адаптивная раскладка от 360 до 1920 px: формы ограничены по ширине и прокручиваются.
- Округление результата: `10 / 3` выводится как `3.33333333`.
- Логика вынесена в `lib/logic`. 19 тестов: 13 модульных и 6 тестов экранов и маршрутов.
- `flutter analyze` без замечаний, `flutter build web` собирается.

## Маршруты

| Адрес | Экран |
|---|---|
| `/` | Главная |
| `/calculator` | Форма калькулятора |
| `/calculator/result?a=10&op=/&b=3` | Результат вычисления |
| `/converter` | Форма конвертера |
| `/converter/result?from=EUR&to=JPY&amount=250` | Результат конвертации |
| любой другой | Экран 404 |

Форма собирает адрес через `Uri(path:, queryParameters:)` и переходит на него через `context.go`. Маршрут результата читает `state.uri.queryParameters`, вызывает функцию из `lib/logic` и передаёт на экран готовый результат или текст ошибки. Подробнее: [docs/report.md](docs/report.md).

## Запуск

```bash
flutter pub get
flutter run -d chrome --web-port=5555
flutter test
flutter analyze
flutter build web
```

## Структура

```
lib/
├── main.dart                 точка входа, usePathUrlStrategy, MaterialApp.router, темы
├── router.dart               маршруты go_router и errorBuilder (404)
├── storage.dart              сохранение темы и последней пары валют (shared_preferences)
├── logic/
│   ├── calculator.dart       calculate(), parseNumber(), formatNumber()
│   └── currency.dart         курсы-константы, convert()
├── screens/                  home, calculator, converter, result, not_found
└── widgets/app_page.dart     каркас экрана: заголовок, кнопка темы, ограничение ширины
test/
├── logic_test.dart           модульные тесты логики
└── app_test.dart             тесты маршрутов и форм
```
