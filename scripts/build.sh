#!/usr/bin/env bash
# 把 owala.html 包成完整的 HTML 文件，輸出到 dist/index.html
# owala.html 只有 <title>、<style> 和內容，缺少 doctype、字元編碼與 viewport，
# 直接放上靜態主機會讓手機版縮小、中文可能變亂碼，所以部署前先補齊。
set -euo pipefail
cd "$(dirname "$0")/.."

src="owala.html"
out="dist"

split=$(grep -n '^<div class="wrap"' "$src" | head -n 1 | cut -d: -f1 || true)
if [ -z "$split" ]; then
  echo "錯誤：在 $src 裡找不到 <div class=\"wrap\">，無法分出 head 和 body。" >&2
  exit 1
fi

rm -rf "$out"
mkdir -p "$out"

{
  printf '<!doctype html>\n<html lang="zh-Hant-TW">\n<head>\n'
  printf '<meta charset="utf-8">\n'
  printf '<meta name="viewport" content="width=device-width, initial-scale=1">\n'
  printf '%s\n' "<link rel=\"icon\" href=\"data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'><text y='.9em' font-size='90'>🥤</text></svg>\">"
  printf '<style>body{margin:0}img{max-width:100%%}[hidden]{display:none!important}</style>\n'
  head -n $((split - 1)) "$src"
  printf '</head>\n<body>\n'
  tail -n +"$split" "$src"
  printf '</body>\n</html>\n'
} > "$out/index.html"

echo "已產生 $out/index.html"
