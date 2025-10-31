import os
import requests
import subprocess

# === Настройки ===
GITHUB_USER = "abrikosikk"
REPO_NAME = "rpm-ahk"
SCRIPTS_DIR = "scripts"
BRANCH = "main"

# === Создание локальной папки для скриптов ===
os.makedirs(SCRIPTS_DIR, exist_ok=True)

# === Список файлов из GitHub API ===
url = f"https://api.github.com/repos/{GITHUB_USER}/{REPO_NAME}/contents/{SCRIPTS_DIR}?ref={BRANCH}"
response = requests.get(url)
files = response.json()

for file in files:
    if file["name"].endswith(".ahk"):
        print(f"Загружаю: {file['name']}...")
        ahk_data = requests.get(file["download_url"]).text
        local_path = os.path.join(SCRIPTS_DIR, file["name"])
        with open(local_path, "w", encoding="utf-8") as f:
            f.write(ahk_data)
        print(f"✅ {file['name']} сохранён.")

# === Автозапуск всех скриптов ===
for file_name in os.listdir(SCRIPTS_DIR):
    if file_name.endswith(".ahk"):
        subprocess.Popen(["AutoHotkey.exe", os.path.join(SCRIPTS_DIR, file_name)])
        print(f"🚀 Запущен {file_name}")
