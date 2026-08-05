import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

// base: './' — чтобы CSS/JS открывались на GitHub Pages
// (и из подпапки репозитория, и с относительными путями)
export default defineConfig({
  plugins: [react()],
  base: './',
})
