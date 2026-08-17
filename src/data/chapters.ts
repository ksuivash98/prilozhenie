import type { LocationId } from '../game/data';
import { normalizeSpeech } from '../services/fuzzyMatch';

function makeWordId(word: string): string {
  const normalized = normalizeSpeech(word).replace(/\s+/g, '_');
  return `word_${normalized || 'unknown'}`;
}

export interface ChapterWord {
  id: string;
  text: string;
  chapterId: number;
  isKey?: boolean;
}

export interface MiniBossDef {
  index: 1 | 2 | 3;
  id: string;
  name: string;
  emoji: string;
  /** Доля новых слов главы (0.8 = 80/20). */
  newRatio: number;
  taskCount: number;
}

export interface WorldUnlock {
  id: string;
  name: string;
  emoji: string;
  kind: 'item' | 'pet' | 'world';
}

export interface ChapterDef {
  id: number;
  locationId: LocationId;
  name: string;
  emoji: string;
  newWords: ChapterWord[];
  miniBosses: MiniBossDef[];
  bossName: string;
  bossEmoji: string;
  bossTaskCount: number;
  /** Доля новых слов у главного босса. */
  bossNewRatio: number;
  unlock: WorldUnlock;
}

function w(chapterId: number, text: string, isKey = true): ChapterWord {
  return {
    id: makeWordId(text),
    text: text.toUpperCase(),
    chapterId,
    isKey,
  };
}

function mini(
  chapterId: number,
  index: 1 | 2 | 3,
  name: string,
  emoji: string,
  newRatio: number,
  taskCount: number,
): MiniBossDef {
  return {
    index,
    id: `ch${chapterId}_mini_${index}`,
    name,
    emoji,
    newRatio,
    taskCount,
  };
}

export const CHAPTERS: ChapterDef[] = [
  {
    id: 1,
    locationId: 'village',
    name: 'Деревня Слов',
    emoji: '🏘️',
    newWords: [
      w(1, 'КОТ'),
      w(1, 'ДОМ'),
      w(1, 'МАМА'),
      w(1, 'СОН'),
      w(1, 'МОСТ'),
      w(1, 'СВЕТ'),
      w(1, 'ПУТЬ'),
      w(1, 'КНИГА'),
    ],
    miniBosses: [
      mini(1, 1, 'Страж колодца', '🪣', 0.8, 10),
      mini(1, 2, 'Тень забора', '🪵', 0.75, 8),
      mini(1, 3, 'Хранитель фонаря', '🏮', 0.7, 10),
    ],
    bossName: 'Тень Колодца',
    bossEmoji: '👹',
    bossTaskCount: 10,
    bossNewRatio: 0.67,
    unlock: { id: 'lamp_village', name: 'Фонарь деревни', emoji: '🪔', kind: 'item' },
  },
  {
    id: 2,
    locationId: 'magic_forest',
    name: 'Волшебный лес',
    emoji: '🌳',
    newWords: [
      w(2, 'ЛИСА'),
      w(2, 'ТРОПА'),
      w(2, 'СОВА'),
      w(2, 'ЛИСТ'),
      w(2, 'БЕЛКА'),
      w(2, 'ГНЕЗДО'),
      w(2, 'ЧАЩА'),
      w(2, 'МОХ'),
    ],
    miniBosses: [
      mini(2, 1, 'Шёпот кустов', '🌿', 0.8, 10),
      mini(2, 2, 'Страж тропы', '🦊', 0.75, 8),
      mini(2, 3, 'Ночная сова', '🦉', 0.7, 10),
    ],
    bossName: 'Лесной шёпот',
    bossEmoji: '🌲',
    bossTaskCount: 10,
    bossNewRatio: 0.67,
    unlock: { id: 'pet_fox', name: 'Лисичка-спутник', emoji: '🦊', kind: 'pet' },
  },
  {
    id: 3,
    locationId: 'caves',
    name: 'Пещеры Эха',
    emoji: '💎',
    newWords: [
      w(3, 'ЛЕС'),
      w(3, 'МОСТ'),
      w(3, 'ЛИСА'),
      w(3, 'РЕКА'),
      w(3, 'ГРИБ'),
      w(3, 'ДЕРЕВО'),
      w(3, 'ПОЛЯНА'),
      w(3, 'ЗАМОК'),
    ],
    miniBosses: [
      mini(3, 1, 'Эхо входа', '🪨', 0.8, 10),
      mini(3, 2, 'Кристальный страж', '💎', 0.75, 8),
      mini(3, 3, 'Голем тропы', '🗿', 0.7, 10),
    ],
    bossName: 'Эхо-голем',
    bossEmoji: '💎',
    bossTaskCount: 10,
    bossNewRatio: 0.67,
    unlock: { id: 'crystal_echo', name: 'Кристалл эха', emoji: '💠', kind: 'item' },
  },
  {
    id: 4,
    locationId: 'castle',
    name: 'Замок Букв',
    emoji: '🏰',
    newWords: [
      w(4, 'БАШНЯ'),
      w(4, 'РЫЦАРЬ'),
      w(4, 'ЩИТ'),
      w(4, 'МЕЧ'),
      w(4, 'КОРОНА'),
      w(4, 'ФЛАГ'),
      w(4, 'ВОРОТА'),
      w(4, 'ГЕРОЙ'),
    ],
    miniBosses: [
      mini(4, 1, 'Страж ворот', '🛡️', 0.8, 10),
      mini(4, 2, 'Башенный страж', '🗼', 0.75, 8),
      mini(4, 3, 'Рыцарь зала', '⚔️', 0.7, 10),
    ],
    bossName: 'Рыцарь Безмолвия',
    bossEmoji: '🏰',
    bossTaskCount: 10,
    bossNewRatio: 0.67,
    unlock: { id: 'banner_letters', name: 'Знамя букв', emoji: '🚩', kind: 'world' },
  },
  {
    id: 5,
    locationId: 'desert',
    name: 'Пустыня Песков',
    emoji: '🏜️',
    newWords: [
      w(5, 'ПЕСОК'),
      w(5, 'ДЮНА'),
      w(5, 'ОАЗИС'),
      w(5, 'ВЕРБЛЮД'),
      w(5, 'ЖАРА'),
      w(5, 'СЛЕД'),
      w(5, 'КАРТА'),
      w(5, 'КЛАД'),
    ],
    miniBosses: [
      mini(5, 1, 'Страж дюны', '🌵', 0.8, 10),
      mini(5, 2, 'Песчаный вихрь', '💨', 0.75, 8),
      mini(5, 3, 'Хранитель оазиса', '🌴', 0.7, 10),
    ],
    bossName: 'Песчаный змей',
    bossEmoji: '🐍',
    bossTaskCount: 10,
    bossNewRatio: 0.67,
    unlock: { id: 'compass_sand', name: 'Компас песков', emoji: '🧭', kind: 'item' },
  },
  {
    id: 6,
    locationId: 'ice_valley',
    name: 'Ледяная долина',
    emoji: '❄️',
    newWords: [
      w(6, 'СНЕГ'),
      w(6, 'ЛЁД'),
      w(6, 'ГОРА'),
      w(6, 'МЕТЕЛЬ'),
      w(6, 'САНИ'),
      w(6, 'СЕВЕР'),
      w(6, 'ИСКРА'),
      w(6, 'ЗВЕЗДА'),
    ],
    miniBosses: [
      mini(6, 1, 'Снежный страж', '⛄', 0.8, 10),
      mini(6, 2, 'Ледяной мост', '🧊', 0.75, 8),
      mini(6, 3, 'Северный ветер', '🌬️', 0.7, 10),
    ],
    bossName: 'Морозный великан',
    bossEmoji: '❄️',
    bossTaskCount: 10,
    bossNewRatio: 0.67,
    unlock: { id: 'pet_owl', name: 'Полярная сова', emoji: '🦉', kind: 'pet' },
  },
  {
    id: 7,
    locationId: 'volcano',
    name: 'Вулкан Пламени',
    emoji: '🌋',
    newWords: [
      w(7, 'ОГОНЬ'),
      w(7, 'ЛАВА'),
      w(7, 'ЖАР'),
      w(7, 'ПЕПЕЛ'),
      w(7, 'РУНА'),
      w(7, 'СИЛА'),
      w(7, 'ЩИТ'),
      w(7, 'ДЫМ'),
    ],
    miniBosses: [
      mini(7, 1, 'Искровой страж', '🔥', 0.8, 10),
      mini(7, 2, 'Страж лавы', '🌋', 0.75, 8),
      mini(7, 3, 'Пепельный дрейк', '🐲', 0.7, 10),
    ],
    bossName: 'Огненный дрейк',
    bossEmoji: '🔥',
    bossTaskCount: 10,
    bossNewRatio: 0.67,
    unlock: { id: 'ember_heart', name: 'Сердце жара', emoji: '❤️‍🔥', kind: 'item' },
  },
  {
    id: 8,
    locationId: 'sky_islands',
    name: 'Небесные острова',
    emoji: '☁️',
    newWords: [
      w(8, 'ОБЛАКО'),
      w(8, 'НЕБО'),
      w(8, 'ПТИЦА'),
      w(8, 'КРЫЛО'),
      w(8, 'ВЕТЕР'),
      w(8, 'РАДУГА'),
      w(8, 'МОСТ'),
      w(8, 'СВЕТ'),
    ],
    miniBosses: [
      mini(8, 1, 'Страж облака', '☁️', 0.8, 10),
      mini(8, 2, 'Ветряной страж', '🪽', 0.75, 8),
      mini(8, 3, 'Грозовой страж', '⚡', 0.7, 10),
    ],
    bossName: 'Грозовой орёл',
    bossEmoji: '🦅',
    bossTaskCount: 10,
    bossNewRatio: 0.67,
    unlock: { id: 'wing_pin', name: 'Перо неба', emoji: '🪶', kind: 'world' },
  },
  {
    id: 9,
    locationId: 'underwater',
    name: 'Подводный мир',
    emoji: '🐠',
    newWords: [
      w(9, 'ВОЛНА'),
      w(9, 'РЫБА'),
      w(9, 'МОРЕ'),
      w(9, 'КИТ'),
      w(9, 'РАКУШКА'),
      w(9, 'КОРАБЛЬ'),
      w(9, 'ДНО'),
      w(9, 'ЖЕМЧУГ'),
    ],
    miniBosses: [
      mini(9, 1, 'Страж рифа', '🪸', 0.8, 10),
      mini(9, 2, 'Хранитель волны', '🌊', 0.75, 8),
      mini(9, 3, 'Страж жемчуга', '🐚', 0.7, 10),
    ],
    bossName: 'Кракен Приливов',
    bossEmoji: '🐙',
    bossTaskCount: 10,
    bossNewRatio: 0.67,
    unlock: { id: 'pearl_song', name: 'Песня жемчуга', emoji: '🫧', kind: 'item' },
  },
  {
    id: 10,
    locationId: 'cosmos',
    name: 'Космос Сказаний',
    emoji: '🌌',
    newWords: [
      w(10, 'ЗВЕЗДА'),
      w(10, 'ЛУНА'),
      w(10, 'КОМЕТА'),
      w(10, 'РАКЕТА'),
      w(10, 'НОЧЬ'),
      w(10, 'МИР'),
      w(10, 'СКАЗКА'),
      w(10, 'СВЕТ'),
    ],
    miniBosses: [
      mini(10, 1, 'Страж орбиты', '🪐', 0.8, 10),
      mini(10, 2, 'Тень кометы', '☄️', 0.75, 8),
      mini(10, 3, 'Страж созвездия', '✨', 0.7, 10),
    ],
    bossName: 'Пожиратель Букв',
    bossEmoji: '🌌',
    bossTaskCount: 10,
    bossNewRatio: 0.67,
    unlock: { id: 'star_map', name: 'Карта сказаний', emoji: '🗺️', kind: 'world' },
  },
  {
    id: 11,
    locationId: 'dragon_land',
    name: 'Земля драконов',
    emoji: '🐉',
    newWords: [
      w(11, 'ДРАКОН'),
      w(11, 'КРЫЛО'),
      w(11, 'ПЛАМЯ'),
      w(11, 'ГНЕЗДО'),
      w(11, 'РУНА'),
      w(11, 'СИЛА'),
      w(11, 'ДРУГ'),
      w(11, 'НЕБО'),
    ],
    miniBosses: [
      mini(11, 1, 'Страж яйца', '🥚', 0.8, 10),
      mini(11, 2, 'Хранитель рун', '🔮', 0.75, 8),
      mini(11, 3, 'Крылатый страж', '🐉', 0.7, 10),
    ],
    bossName: 'Страж Рун',
    bossEmoji: '🐲',
    bossTaskCount: 10,
    bossNewRatio: 0.67,
    unlock: { id: 'dragon_friend', name: 'Печать дракона', emoji: '🪙', kind: 'pet' },
  },
];

export function chapterByLocation(locationId: LocationId): ChapterDef | undefined {
  return CHAPTERS.find((c) => c.locationId === locationId);
}

export function chapterById(id: number): ChapterDef | undefined {
  return CHAPTERS.find((c) => c.id === id);
}

export function allChapterWords(): ChapterWord[] {
  return CHAPTERS.flatMap((c) => c.newWords);
}

export function introducingChapterId(wordId: string): number | undefined {
  for (const ch of CHAPTERS) {
    if (ch.newWords.some((w) => w.id === wordId)) return ch.id;
  }
  return undefined;
}

export function previousChapterWords(chapterId: number): ChapterWord[] {
  return CHAPTERS.filter((c) => c.id < chapterId).flatMap((c) => c.newWords);
}

export function splitWordGroups(words: ChapterWord[], groups = 3): ChapterWord[][] {
  const size = Math.max(1, Math.ceil(words.length / groups));
  return Array.from({ length: groups }, (_, i) => words.slice(i * size, (i + 1) * size));
}
