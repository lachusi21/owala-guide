#!/usr/bin/env bash
# 把 assets/og-image.html 截圖成 1200×630 的網頁縮圖 assets/og-image.png
# 需要本機有 Google Chrome 或 Microsoft Edge。改完縮圖原稿後執行一次，再提交 PNG。
set -euo pipefail
cd "$(dirname "$0")/.."

browser=""
for p in "/c/Program Files/Google/Chrome/Application/chrome.exe" \
         "/c/Program Files (x86)/Microsoft/Edge/Application/msedge.exe" \
         "/c/Program Files/Microsoft/Edge/Application/msedge.exe" \
         "$(command -v google-chrome 2>/dev/null || true)" \
         "$(command -v chromium 2>/dev/null || true)"; do
  if [ -n "$p" ] && [ -f "$p" ]; then browser="$p"; break; fi
done
if [ -z "$browser" ]; then
  echo "錯誤：找不到 Chrome 或 Edge，無法產生縮圖。" >&2
  exit 1
fi

to_native() { if command -v cygpath >/dev/null 2>&1; then cygpath -w "$1"; else printf '%s' "$1"; fi; }
src="$(pwd)/assets/og-image.html"
out="$(pwd)/assets/og-image.png"
profile="$(mktemp -d)"

if command -v cygpath >/dev/null 2>&1; then
  src_url="file:///$(cygpath -m "$src")"
else
  src_url="file://$src"
fi

"$browser" --headless=new --disable-gpu --hide-scrollbars --no-first-run \
  --user-data-dir="$(to_native "$profile")" \
  --window-size=1200,630 --virtual-time-budget=8000 \
  --screenshot="$(to_native "$out")" "$src_url" >/dev/null 2>&1 || true

rm -rf "$profile"
if [ ! -s "$out" ]; then
  echo "錯誤：截圖失敗，沒有產生 $out" >&2
  exit 1
fi
echo "已產生 assets/og-image.png"
