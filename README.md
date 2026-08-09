# ReadQuest

**Чтение превращается в настоящее приключение.**

Веб-приложение для детей 5–9 лет: ребёнок сначала читает сам, потом приложение проверяет голос, и только при необходимости помогает.

Сайт: [https://ksuivash98.github.io/prilozhenie/](https://ksuivash98.github.io/prilozhenie/)

## Запуск

```bash
npm install
npm run dev
```

```bash
npm run build
npm run preview
npm run test
npm run build:pages   # сборка + копирование в docs/ для GitHub Pages
```

## Главный принцип

**Сначала ребёнок читает сам → потом проверка → помощь только при необходимости.**

Озвучка слова не показывается до первых неудачных попыток.

## Web Speech API

- Распознавание: `SpeechRecognition` / `webkitSpeechRecognition` (лучше Chrome / Edge)
- Озвучка: `SpeechSynthesis`
- Голос **не записывается** и **не отправляется** на сервер
- Если STT недоступен — режим «✓ Я прочитал»

## Структура

```
src/
  features/reading/   # ReadingChallenge (speech-first)
  services/           # speechRecognition, fuzzyMatch, TTS
  data/curriculum.ts  # буква → слог → слово → предложение
  game/               # состояние, награды, карта
  pages/              # экраны
  components/         # UI
```

## PWA

- `public/manifest.json`
- `public/sw.js`
- Можно «Добавить на главный экран»

## GitHub Pages

В Settings → Pages выбери branch `main` и папку **`/docs`**.

## Ограничения браузеров

| Функция | Chrome | Edge | Safari | Firefox |
|--------|--------|------|--------|---------|
| Игра    | ✅ | ✅ | ✅ | ✅ |
| STT     | ✅ | ✅ | ⚠️ | ⚠️ |
| TTS     | ✅ | ✅ | ✅ | ✅ |
