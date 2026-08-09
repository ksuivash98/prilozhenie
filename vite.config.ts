import { defineConfig } from 'vitest/config'
import react from '@vitejs/plugin-react'

// Путь репозитория на GitHub Pages: https://ksuivash98.github.io/prilozhenie/
export default defineConfig({
  plugins: [react()],
  base: '/prilozhenie/',
  test: {
    environment: 'node',
    include: ['src/**/*.test.ts'],
  },
})
