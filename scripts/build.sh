#!/usr/bin/env bash
# 把 owala.html 包成完整的 HTML 文件，輸出到 dist/index.html
# owala.html 只有 <title>、<style> 和內容，缺少 doctype、字元編碼與 viewport，
# 直接放上靜態主機會讓手機版縮小、中文可能變亂碼，所以部署前先補齊。
set -euo pipefail
cd "$(dirname "$0")/.."

src="owala.html"
out="dist"
# 分享連結時社群平台抓縮圖用的正式網址，必須是完整網址
site_url="${SITE_URL:-https://lachusi21.github.io/owala-guide/}"
og_title="Owala 水壺檔案"
og_desc="Owala 水壺的發明故事、爆紅行銷，以及台灣熱門款式與正規購買通路。"

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
  printf '<link rel="canonical" href="%s">\n' "$site_url"
  printf '<meta property="og:type" content="website">\n'
  printf '<meta property="og:locale" content="zh_TW">\n'
  printf '<meta property="og:site_name" content="%s">\n' "$og_title"
  printf '<meta property="og:title" content="%s">\n' "$og_title"
  printf '<meta property="og:description" content="%s">\n' "$og_desc"
  printf '<meta property="og:url" content="%s">\n' "$site_url"
  printf '<meta property="og:image" content="%sog-image.png">\n' "$site_url"
  printf '<meta property="og:image:width" content="1200">\n'
  printf '<meta property="og:image:height" content="630">\n'
  printf '<meta property="og:image:alt" content="Owala 水壺檔案：發明故事、爆紅行銷、台灣怎麼買，旁邊是一個粉紅蓋、綠色瓶身的水壺插圖">\n'
  printf '<meta name="twitter:card" content="summary_large_image">\n'
  printf '<meta name="twitter:image" content="%sog-image.png">\n' "$site_url"
  printf '%s\n' "<link rel=\"icon\" href=\"data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'><text y='.9em' font-size='90'>🥤</text></svg>\">"
  printf '<style>body{margin:0}img{max-width:100%%}[hidden]{display:none!important}</style>\n'
  head -n $((split - 1)) "$src"
  printf '</head>\n<body>\n'
  tail -n +"$split" "$src"
  printf '</body>\n</html>\n'
} > "$out/index.html"

if [ ! -f assets/og-image.png ]; then
  echo "錯誤：找不到 assets/og-image.png，請先執行 bash scripts/render-og.sh。" >&2
  exit 1
fi
cp assets/og-image.png "$out/og-image.png"

echo "已產生 $out/index.html 和 $out/og-image.png"
