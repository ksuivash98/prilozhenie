import { cpSync, mkdirSync, rmSync, writeFileSync, existsSync } from 'node:fs'
import { join } from 'node:path'

const root = process.cwd()
const dist = join(root, 'dist')
const docs = join(root, 'docs')

if (!existsSync(dist)) {
  console.error('Папка dist не найдена. Сначала выполни npm run build')
  process.exit(1)
}

rmSync(docs, { recursive: true, force: true })
mkdirSync(docs, { recursive: true })
cpSync(dist, docs, { recursive: true })
writeFileSync(join(docs, '.nojekyll'), '')
console.log('Готово: содержимое dist скопировано в docs/ для GitHub Pages')
