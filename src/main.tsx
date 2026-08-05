import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';
import { HashRouter } from 'react-router-dom';
import App from './App';
import './index.css';

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    {/* HashRouter нужен для GitHub Pages: сервер не знает клиентские маршруты */}
    <HashRouter>
      <App />
    </HashRouter>
  </StrictMode>,
);
