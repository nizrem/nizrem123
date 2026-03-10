#!/bin/bash

echo "🚀 Начинаем локальную установку n8n (Ядро Миланы) на Linux Mint..."

# 1. Создаем папки
echo "📁 Создаем рабочие директории..."
mkdir -p ~/milana-local/knowledge_base
cd ~/milana-local

# 2. Создаем Dockerfile с ffmpeg
echo "📝 Создаем Dockerfile (добавляем ffmpeg)..."
cat << 'EOF' > Dockerfile
FROM n8nio/n8n:latest
USER root
RUN apk update && \
    apk add --no-cache ffmpeg && \
    rm -rf /var/cache/apk/*
USER node
EOF

# 3. Создаем docker-compose.yml для локальной работы
echo "📝 Создаем docker-compose.yml..."
cat << 'EOF' > docker-compose.yml
version: "3.9"
services:
  n8n:
    build:
      context: .
      dockerfile: Dockerfile
    restart: always
    container_name: milana_n8n_local
    environment:
      - GENERIC_TIMEZONE=Europe/Tallinn
      - N8N_HOST=localhost
      - N8N_PORT=5678
      - N8N_PROTOCOL=http
      - WEBHOOK_URL=http://localhost:5678/
      - N8N_DEFAULT_BINARY_DATA_MODE=filesystem
      - N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true
    ports:
      - "5678:5678"
    volumes:
      - ~/.n8n_local:/home/node/.n8n
      - ./knowledge_base:/data/knowledge_base
EOF

# 4. Запускаем сборку и контейнер
echo "🔨 Собираем и запускаем контейнер..."
docker compose up --build -d

echo "✅ Установка завершена!"
echo "База знаний (складывать PDF сюда): ~/milana-local/knowledge_base"
echo "🌐 Открой в браузере: http://localhost:5678"
