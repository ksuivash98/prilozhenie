# ReadQuest (Web)

**Чтение превращается в настоящее приключение.**

Сайт: [https://ksuivash98.github.io/prilozhenie/](https://ksuivash98.github.io/prilozhenie/)

## Почему был белый экран

GitHub Pages отдавал **исходный** `index.html` со строкой:

```html
<script type="module" src="/src/main.tsx"></script>
```

Браузер на Pages **не умеет** запускать TypeScript/Vite-исходники. Нужна папка **сборки** (`dist` / `docs`) с готовыми `.js` и `.css`.

## Как починить деплой (один раз)

1. В GitHub открой репозиторий → **Settings → Pages**
2. Source: **Deploy from a branch**
3. Branch: `main`
4. Folder: **/docs**
5. Save

После этого сайт возьмёт готовые файлы из папки `docs/` (уже собраны в проекте).

Либо включи **GitHub Actions** (workflow `.github/workflows/deploy.yml`) и в Pages выбери Source: **GitHub Actions**.

## Локально

```bash
npm install
npm run dev
```

Сборка в `docs/` для Pages:

```bash
npm run build
# скопируй содержимое dist/ в docs/
```

Прогресс сохраняется в `localStorage`.
