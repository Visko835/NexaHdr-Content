#!/bin/bash

echo "========================================="
echo "  NEXAHDR // DATA INJECTOR"
echo "========================================="
echo ""

read -p "[*] Enter Title       : " TITLE
read -p "[*] Enter YouTube URL : " YT_URL
read -p "[*] Enter Download URL: " DL_URL

if [ -z "$TITLE" ] || [ -z "$YT_URL" ] || [ -z "$DL_URL" ]; then
    echo "[!] Error: All fields are required. Aborting."
    exit 1
fi

TANGGAL=$(date +"%d %b %Y")

echo "[*] Processing JSON payload..."
jq --arg t "$TITLE" --arg y "$YT_URL" --arg d "$DL_URL" --arg date "$TANGGAL" \
   '. += [{"title": $t, "youtube_url": $y, "download_url": $d, "date": $date}]' menu1_data.json > tmp.json && mv tmp.json menu1_data.json

echo "[*] Syncing with GitHub..."
git add menu1_data.json
git commit -m "feat: inject savedata artifact - $TITLE"

# Tarik update dulu sebelum push untuk mencegah error
git pull --rebase origin main

echo "[*] Pushing to GitHub..."
git push

echo "========================================="
echo "[+] SUCCESS: Artifact deployed to live environment."
echo "========================================="
