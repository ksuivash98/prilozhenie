import { Navigate, Route, Routes } from 'react-router-dom';
import { GameProvider } from './game/GameProvider';
import { SplashPage } from './pages/SplashPage';
import { OnboardingPage } from './pages/OnboardingPage';
import { HomePage } from './pages/HomePage';
import { LearnPage } from './pages/LearnPage';
import { AdventurePage } from './pages/AdventurePage';
import { LocationPage } from './pages/LocationPage';
import { BattlePage } from './pages/BattlePage';
import { DragonPage } from './pages/DragonPage';
import { MiniGamesHubPage } from './pages/MiniGamesHubPage';
import { MiniGamePage } from './pages/MiniGamePage';
import { LibraryPage } from './pages/LibraryPage';
import { CityPage } from './pages/CityPage';
import { AchievementsPage } from './pages/AchievementsPage';
import { SettingsPage } from './pages/SettingsPage';
import { ParentsPage } from './pages/ParentsPage';
import { StatisticsPage } from './pages/StatisticsPage';

export default function App() {
  return (
    <GameProvider>
      <Routes>
        <Route path="/" element={<SplashPage />} />
        <Route path="/onboarding" element={<OnboardingPage />} />
        <Route path="/home" element={<HomePage />} />
        <Route path="/learn" element={<LearnPage />} />
        <Route path="/adventure" element={<AdventurePage />} />
        <Route path="/adventure/:locationId" element={<LocationPage />} />
        <Route path="/battle/:locationId" element={<BattlePage />} />
        <Route path="/dragon" element={<DragonPage />} />
        <Route path="/mini-games" element={<MiniGamesHubPage />} />
        <Route path="/mini-games/:gameId" element={<MiniGamePage />} />
        <Route path="/library" element={<LibraryPage />} />
        <Route path="/city" element={<CityPage />} />
        <Route path="/achievements" element={<AchievementsPage />} />
        <Route path="/settings" element={<SettingsPage />} />
        <Route path="/parents" element={<ParentsPage />} />
        <Route path="/statistics" element={<StatisticsPage />} />
        <Route path="*" element={<Navigate to="/" replace />} />
      </Routes>
    </GameProvider>
  );
}
