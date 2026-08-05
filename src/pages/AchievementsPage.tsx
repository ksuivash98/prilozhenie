import { Page } from '../components/Page';
import { useGame } from '../game/store';

export function AchievementsPage() {
  const { state } = useGame();

  const list = [
    { id: 'first', title: 'Первое слово', done: state.wordsRead >= 1, desc: 'Прочитай первое слово' },
    { id: 'w50', title: 'Собиратель слов', done: state.wordsRead >= 50, desc: '50 слов' },
    { id: 'w200', title: 'Хранитель сказаний', done: state.wordsRead >= 200, desc: '200 слов' },
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
