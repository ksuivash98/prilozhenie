export type DragonStage = 'egg' | 'baby' | 'teen' | 'adult' | 'legendary';

export type LocationId =
  | 'village'
  | 'magic_forest'
  | 'caves'
  | 'castle'
  | 'desert'
  | 'ice_valley'
  | 'volcano'
  | 'sky_islands'
  | 'underwater'
  | 'cosmos';

export interface Location {
  id: LocationId;
  name: string;
  emoji: string;
  description: string;
  x: number;
  y: number;
  word: string;
  boss: string;
  bossHp: number;
}

export interface MiniGame {
  id: string;
  title: string;
  emoji: string;
  description: string;
  word: string;
  unlockWords: number;
}

export interface GameState {
  playerName: string;
  onboardingDone: boolean;
  wordsRead: number;
  xp: number;
  coins: number;
  level: number;
  vitality: number;
  lastReadAt: number;
  unlockedLocations: LocationId[];
  currentLocation: LocationId;
  dragonName: string;
  dragonStage: DragonStage;
  dragonXp: number;
  bossesDefeated: number;
  streak: number;
  correct: number;
  errors: number;
  hardWords: Record<string, number>;
  parentPin: string | null;
  storiesRead: string[];
  completedQuests: string[];
  bestScores: Record<string, number>;
}

export const LOCATIONS: Location[] = [
  {
    id: 'village',
    name: 'Деревня Слов',
    emoji: '🏘️',
    description: 'Здесь всё началось. Жители ждут возвращения книг.',
    x: 18,
    y: 68,
    word: 'мост',
    boss: 'Тень Колодца',
    bossHp: 24,
  },
  {
    id: 'magic_forest',
    name: 'Волшебный лес',
    emoji: '🌳',
    description: 'Деревья шепчут слоги. Буквы прячутся в листве.',
    x: 38,
    y: 48,
    word: 'лиса',
    boss: 'Лесной шёпот',
    bossHp: 32,
  },
  {
    id: 'caves',
    name: 'Пещеры Эха',
    emoji: '💎',
    description: 'Каждое слово зажигает кристаллы.',
    x: 22,
    y: 30,
    word: 'камень',
    boss: 'Эхо-голем',
    bossHp: 40,
  },
  {
    id: 'castle',
    name: 'Замок Букв',
    emoji: '🏰',
    description: 'Древняя крепость великих книг.',
    x: 55,
    y: 34,
    word: 'замок',
    boss: 'Рыцарь Безмолвия',
    bossHp: 48,
  },
  {
    id: 'desert',
    name: 'Пустыня Песков',
    emoji: '🏜️',
    description: 'Слова погребены под дюнами.',
    x: 74,
    y: 58,
    word: 'песок',
    boss: 'Песчаный змей',
    bossHp: 56,
  },
  {
    id: 'ice_valley',
    name: 'Ледяная долина',
    emoji: '❄️',
    description: 'Мороз сковал сказки.',
    x: 78,
    y: 24,
    word: 'снег',
    boss: 'Морозный великан',
    bossHp: 64,
  },
  {
    id: 'volcano',
    name: 'Вулкан Пламени',
    emoji: '🌋',
    description: 'Жаркие руны кипят в лаве.',
    x: 48,
    y: 76,
    word: 'огонь',
    boss: 'Огненный дрейк',
    bossHp: 72,
  },
  {
    id: 'sky_islands',
    name: 'Небесные острова',
    emoji: '☁️',
    description: 'Облака несут летающие слова.',
    x: 62,
    y: 14,
    word: 'облако',
    boss: 'Грозовой орёл',
    bossHp: 80,
  },
  {
    id: 'underwater',
    name: 'Подводный мир',
    emoji: '🐠',
    description: 'Жемчужины-буквы сияют на дне.',
    x: 88,
    y: 74,
    word: 'волна',
    boss: 'Кракен Приливов',
    bossHp: 88,
  },
  {
    id: 'cosmos',
    name: 'Космос Сказаний',
    emoji: '🌌',
    description: 'Пожиратель Букв ждёт в сердце тьмы.',
    x: 42,
    y: 10,
    word: 'звезда',
    boss: 'Пожиратель Букв',
    bossHp: 100,
  },
];

export const MINI_GAMES: MiniGame[] = [
  { id: 'feed_dragon', title: 'Накорми дракона', emoji: '🐉', description: 'Выбери еду и прочитай её название.', word: 'яблоко', unlockWords: 0 },
  { id: 'collect_word', title: 'Собери слово', emoji: '🔤', description: 'Нажми буквы в правильном порядке.', word: 'лиса', unlockWords: 5 },
  { id: 'catch_letter', title: 'Поймай букву', emoji: '🧲', description: 'Лови нужные буквы среди лишних.', word: 'лес', unlockWords: 10 },
  { id: 'defeat_monster', title: 'Победи монстра', emoji: '👾', description: 'Чем длиннее слово — тем сильнее удар.', word: 'смелость', unlockWords: 15 },
  { id: 'open_chest', title: 'Открой сундук', emoji: '🧰', description: 'Прочитай пароль сундука.', word: 'ключ', unlockWords: 20 },
  { id: 'find_item', title: 'Найди предмет', emoji: '🔎', description: 'Найди спрятанный предмет по подсказке.', word: 'фонарь', unlockWords: 25 },
  { id: 'fishing', title: 'Рыбалка', emoji: '🎣', description: 'Выуди буквы и собери слово.', word: 'рыба', unlockWords: 35 },
  { id: 'farm', title: 'Ферма', emoji: '🌱', description: 'Посади слоги и собери урожай.', word: 'мама', unlockWords: 45 },
  { id: 'magic_forest', title: 'Магический лес', emoji: '🌲', description: 'Освети тропу правильными словами.', word: 'тропа', unlockWords: 55 },
  { id: 'flying_words', title: 'Летающие слова', emoji: '🪽', description: 'Коснись нужного слова среди летающих.', word: 'облако', unlockWords: 65 },
  { id: 'puzzles', title: 'Пазлы', emoji: '🧩', description: 'Собери слово из частей.', word: 'дом', unlockWords: 75 },
  { id: 'letter_hunt', title: 'Поиск букв', emoji: '🔍', description: 'Найди все буквы слова на поляне.', word: 'сова', unlockWords: 85 },
  { id: 'magic_runes', title: 'Магические руны', emoji: '🔮', description: 'Активируй руны по порядку.', word: 'руна', unlockWords: 100 },
  { id: 'knowledge_tower', title: 'Башня знаний', emoji: '🗼', description: 'Поднимайся этаж за этажом.', word: 'башня', unlockWords: 120 },
  { id: 'forge', title: 'Кузница', emoji: '⚒️', description: 'Выкуй меч из слогов.', word: 'меч', unlockWords: 140 },
  { id: 'labyrinth', title: 'Лабиринт', emoji: '🌀', description: 'Выбери верный поворот по указателю.', word: 'право', unlockWords: 160 },
  { id: 'word_garden', title: 'Сад слов', emoji: '🌷', description: 'Полей цветы правильными словами.', word: 'цветок', unlockWords: 180 },
  { id: 'ship_voyage', title: 'Путешествие', emoji: '⛵', description: 'Направляй корабль флагами-словами.', word: 'ветер', unlockWords: 200 },
  { id: 'save_creature', title: 'Спаси зверька', emoji: '🐿️', description: 'Прочитай заклинание спасения.', word: 'дружба', unlockWords: 220 },
  { id: 'library_game', title: 'Библиотека', emoji: '📚', description: 'Расставь книги по названиям.', word: 'сказка', unlockWords: 250 },
];

export const STORIES = [
  {
    id: 'village_dawn',
    title: 'Утро в Деревне Слов',
    pages: [
      'В деревне погас свет слов.',
      'Маленький герой нашёл яйцо дракона.',
      'Луми сказала: «Читай — и мир оживёт!»',
      'Первое слово зажгло фонарь у моста.',
    ],
  },
  {
    id: 'forest_whisper',
    title: 'Шёпот леса',
    pages: [
      'Волшебный лес потерял голос.',
      'Белка показала тропу из слогов.',
      'Герой прочитал «лиса» — и лиса вышла из тумана.',
      'Деревья зашелестели благодарностью.',
    ],
  },
  {
    id: 'devourer_shadow',
    title: 'Тень Пожирателя',
    pages: [
      'Далеко в космосе ждал Пожиратель Букв.',
      'Он прятал книги в чёрных облаках.',
      'Но каждое прочитанное слово делало тьму слабее.',
      'Дракон вздохнул огнём надежды.',
    ],
  },
];

export const LUMI = {
  greet: [
    'Привет! Я Луми. Давай вместе вернём силу слов!',
    'Рада тебя видеть! Мир уже ждёт твоих слов.',
  ],
  encourage: [
    'Ты справишься! Попробуй ещё раз — я рядом.',
    'Каждая попытка делает тебя сильнее. Вперёд!',
    'Дыши спокойно. Слово само придёт к тебе.',
  ],
  celebrate: [
    'Ура! Ты прочитал это слово — мир стал ярче!',
    'Потрясающе! Дракон гордится тобой!',
    'Волшебно! Ещё одно слово вернулось домой.',
  ],
};

export const STAGE_LABEL: Record<DragonStage, string> = {
  egg: 'Яйцо',
  baby: 'Малыш',
  teen: 'Подросток',
  adult: 'Взрослый',
  legendary: 'Легендарный',
};

export const STAGE_EMOJI: Record<DragonStage, string> = {
  egg: '🥚',
  baby: '🐣',
  teen: '🐉',
  adult: '🐲',
  legendary: '✨🐲',
};
