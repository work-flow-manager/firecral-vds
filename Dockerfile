# Firecrawl Production Docker Image
FROM node:20-slim

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    python3 \
    python3-pip \
    build-essential \
    wget \
    gnupg \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install Chrome for Playwright
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/googlechrome-linux-keyring.gpg \
    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/googlechrome-linux-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list \
    && apt-get update \
    && apt-get install -y google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Clone Firecrawl repository
RUN git clone https://github.com/mendableai/firecrawl.git . \
    && cd apps/api && npm install \
    && npx playwright install --with-deps chromium

# Copy production environment
COPY .env.production /app/apps/api/.env

# Environment variables for Gemini + Ollama hybrid
ENV NODE_ENV=production \
    PORT=3002 \
    HOST=0.0.0.0 \
    USE_DB_AUTHENTICATION=false \
    GEMINI_API_KEY=AIzaSyAJWyUi0s9DHtRorkuDVnpoxDXqDGTqNdw \
    GEMINI_MODEL=gemini-2.5-flash-latest \
    OLLAMA_BASE_URL=http://host.docker.internal:11434 \
    MODEL_EMBEDDING_NAME=nomic-embed-text \
    AI_STRATEGY=hybrid \
    AI_PRIMARY=gemini \
    AI_EMBEDDINGS=ollama \
    REDIS_URL=redis://redis:6379 \
    PLAYWRIGHT_MICROSERVICE_URL=http://playwright-service:3000/scrape \
    PROXY_SERVER=http://xcuuwcfa:yccpzo0b9nth@45.61.100.172:6440 \
    PROXY_USERNAME=xcuuwcfa \
    PROXY_PASSWORD=yccpzo0b9nth \
    WEBSHARE_API_KEY=7tk8w3pjogiwpwpf84y0m8wc6zj6yrn8ycvhrrz8 \
    PROXY_ROTATION_ENABLED=true \
    RATE_LIMIT_ENABLED=true \
    RATE_LIMIT_MAX_REQUESTS=411 \
    RATE_LIMIT_WINDOW_MS=3600000 \
    MAX_CONCURRENT_REQUESTS=25 \
    TIMEOUT_MS=30000 \
    TEST_API_KEY=7877e105e5f7b9ec3edf4a8eec5059ab9914efef1b30fe232f59ff31cb8e6fcf

WORKDIR /app/apps/api

EXPOSE 3002

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD curl -f http://localhost:3002/health || exit 1

CMD ["npm", "run", "start:production"]