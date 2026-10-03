#!/usr/bin/env bash
set -e

# 进入仓库根目录
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

# 项目名：可通过参数传入，或环境变量 CF_PAGES_PROJECT 指定，默认为 how-to-live-better
PROJECT_NAME="${1:-${CF_PAGES_PROJECT:-how-to-live-better}}"

echo "==> 1. 构建单文件静态页面..."
node tools/offline/build.mjs dist/index.html

echo "==> 2. 复制辅助静态资源（robots.txt, sitemap.xml, og.png 等）..."
[ -f robots.txt ] && cp robots.txt dist/
[ -f sitemap.xml ] && cp sitemap.xml dist/
[ -f og.png ] && cp og.png dist/

echo "==> 3. 部署到 Cloudflare Pages (项目名: ${PROJECT_NAME})..."
npx wrangler pages deploy dist --project-name="${PROJECT_NAME}"

echo "==> 部署完成！"
