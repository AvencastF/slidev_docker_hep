#!/bin/bash

hep() {
    cp -f "./node_modules/slidev-theme-hep/example.md" "${asset_path}/slides.md"
    cp -rf "./node_modules/slidev-theme-hep/public" "${asset_path}/"

    ln -s "${asset_path}/public" "${slidev_path}/"
}

slidev_path="/slidev/workspace"
asset_path="/slidev"

echo "--> Start Docker for Slidev"
echo "    slidev-docker-hep, by AvencastF"

echo "==> Current Directory: $(pwd)"

mkdir -p ${slidev_path}

if [ "$NPM_MIRROR" != "" ]; then
    npm config set registry $NPM_MIRROR
fi

cd ${slidev_path}
echo "==> Install Slidev and themes in ${slidev_path}"
npm i @slidev/cli @slidev/theme-seriph @slidev/theme-default
npm i slidev-theme-hep
npm i -D playwright-chromium

if [ "$NPM_MIRROR" != "" ]; then
    npm config delete registry
fi


md_file=$1
run_type=$2

if [[ -f "${asset_path}/${md_file}" ]] && [[ -z "$run_type" ]]; then
    echo "==> Read markdown file: ${md_file}"
    echo "==> Start slidev..."
    ln -sf "${asset_path}/${md_file}" "${slidev_path}/${md_file}"
    npx slidev "${slidev_path}/${md_file}" --remote

else
    echo "Run Type: $run_type"
    if [[ "$run_type" == "hep" ]]; then
        echo "==> Build the HEP style project to current working directory..."
        hep && sed -i 's/theme: \.\//theme: hep/' "${asset_path}/slides.md"

    elif [[ "$run_type" == "full" ]]; then
        echo "==> Build the full HEP style project to current working directory..."
        hep
        cp -rf "./node_modules/slidev-theme-hep/components" "${slidev_path}/"
        cp -rf "./node_modules/slidev-theme-hep/layouts" "${slidev_path}/"
        cp -rf "./node_modules/slidev-theme-hep/styles" "${slidev_path}/"
        cp -rf "./node_modules/slidev-theme-hep/package.json" "${slidev_path}/package.json"
    else
        echo "No markdown file found. Using the default template."
        cp -f "/usr/local/lib/node_modules/@slidev/cli/template.md" "${asset_path}/slides.md"
        # Simplifying the sed command for clarity and avoiding the complex ':a;N;$!ba;' pattern
        sed -i 's/GitHub"\n/GitHub"/' "${asset_path}/slides.md"
        echo "==> Copied the default template to ${asset_path}/slides.md"
    fi

    for file in `ls $asset_path/*.md`; do
        filename=$(basename "$file")
        ln -sf "$file" "$slidev_path/$filename"
    done
    
    npx slidev --remote
fi