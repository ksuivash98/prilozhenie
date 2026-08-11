import { Page } from '../components/Page';
import { useGame } from '../game/store';

export function AchievementsPage() {
  const { state } = useGame();

  const list = [
    { id: 'first', title: 'Первое слово', done: state.uniqueWords >= 1, desc: 'Выучи первое слово' },
    { id: 'w50', title: 'Собиратель слов', done: state.uniqueWords >= 50, desc: 'Выучи 50 уникальных слов' },
    { id: 'w200', title: 'Хранитель сказаний', done: state.uniqueWords >= 200, desc: 'Выучи 200 уникальных слов' },
    { id: 'hatch', title: 'Рождение дракона', done: state.dragonStage !== 'egg', desc: 'Вылупи дракона' },
    { id: 'boss', title: 'Победитель тьмы', done: state.bossesDefeated >= 1, desc: 'Победи босса' },
    { id: 'story', title: 'Читатель библиотеки', done: state.storiesRead.length >= 1, desc: 'Прочитай рассказ' },
    { id: 'map', title: 'Путешественник', done: state.unlockedLocations.length >= 3, desc: 'Открой 3 локации' },
  ];

  return (
    <Page title="Достижения">
      <div className="stack">
        {list.map((a) => (
          <div key={a.id} className={`card ${a.done ? 'warm' : ''}`}>
            <strong>
              {a.done ? '🏅 ' : '🔒 '}
              {a.title}
            </strong>
            <p className="muted">{a.desc}</p>
          </div>
        ))}
      </div>
    </Page>
  );
}
