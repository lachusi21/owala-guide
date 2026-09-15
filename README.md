# Owala 水壺檔案

介紹 Owala 水壺的發明故事、靠行銷爆紅的過程、已證實在用的名人，以及台灣熱門款式、價格與正規購買通路。

## 網址

- **GitHub Pages**：https://lachusi21.github.io/owala-guide/
- **Cloudflare Pages**：https://owala-guide.pages.dev
  設定好 Cloudflare 金鑰後才會開始部署。如果這個名稱在 Cloudflare 已被別人使用，實際網址會多一段隨機字，以 Cloudflare 後台顯示的為準。

## 檔案說明

| 檔案 | 用途 |
|---|---|
| `owala.html` | 網頁內容。要修改網站，改這個檔案就好 |
| `assets/og-image.html` | 網頁縮圖的原稿（分享連結時顯示的圖片） |
| `assets/og-image.png` | 網頁縮圖成品，1200 × 630 |
| `scripts/build.sh` | 把 `owala.html` 包成完整的 HTML，加上縮圖標籤，輸出到 `dist/` |
| `scripts/render-og.sh` | 把縮圖原稿截圖成 PNG（需要本機有 Chrome 或 Edge） |
| `.github/workflows/deploy.yml` | 自動部署設定 |

## 網頁縮圖

在 LINE、Facebook、Threads、X 分享網址時，會顯示 `assets/og-image.png` 這張縮圖。
圖上的水壺是自己畫的通用插圖，沒有使用 Owala 的商標或產品照片，避免版權問題。

要修改縮圖：

1. 編輯 `assets/og-image.html`
2. 重新產生圖片：

   ```bash
   bash scripts/render-og.sh
   ```

3. 提交 `assets/og-image.png` 並 push

社群平台會快取縮圖。如果換圖後分享時還是舊圖，可以用 [Facebook 分享偵錯工具](https://developers.facebook.com/tools/debug/) 重新抓取。

## 自動部署怎麼運作

每次 push 到 `main` 分支，GitHub Actions 會：

1. 執行 `scripts/build.sh` 產生 `dist/index.html`
2. 部署到 GitHub Pages
3. 部署到 Cloudflare Pages（還沒設定金鑰時會自動略過，不會讓整個流程失敗）

也可以到 repo 的 **Actions → 部署網站 → Run workflow** 手動重新部署。

## 第一次設定 Cloudflare Pages

1. 登入 [Cloudflare 儀表板](https://dash.cloudflare.com/)。
2. 取得 **Account ID**：在帳戶首頁右側，或網址列 `dash.cloudflare.com/` 後面那串英數字。
3. 建立 **API Token**：到 **My Profile → API Tokens → Create Token → Create Custom Token**，權限選 **Account → Cloudflare Pages → Edit**，建立後複製 token（只會顯示一次）。
4. 在這個資料夾打開終端機，執行下面兩行，依提示貼上剛才的值：

   ```bash
   gh secret set CLOUDFLARE_ACCOUNT_ID --repo lachusi21/owala-guide
   ```

   ```bash
   gh secret set CLOUDFLARE_API_TOKEN --repo lachusi21/owala-guide
   ```

5. 到 repo 的 **Actions → 部署網站 → Run workflow** 重新跑一次，就會部署到 Cloudflare Pages。

## 在本機預覽

```bash
bash scripts/build.sh
```

然後用瀏覽器開啟 `dist/index.html`。
