# Firecrawl Production Docker

Firecrawl configurado para produção com Gemini 2.5 Flash + Ollama embeddings.

## 🚀 Features

- **Gemini 2.5 Flash**: Processamento principal ultra-rápido
- **Ollama Embeddings**: nomic-embed-text local para embeddings
- **100 Proxies Webshare**: Rotação automática
- **300k requests/mês**: Rate limiting configurado
- **Redis Queue**: Para processamento assíncrono
- **Playwright Service**: Para scraping JavaScript

## 📦 Deploy no Easypanel

### Opção 1: Usar Docker Hub/GitHub Registry

1. A imagem será automaticamente publicada em: `ghcr.io/work-flow-manager/firecral-vds:latest`

2. No Easypanel, crie um novo app com:
```yaml
image: ghcr.io/work-flow-manager/firecral-vds:latest
domains:
  - firecrawl.wmappliances.cloud
ports:
  - 3002:3002
```

### Opção 2: Build Local

```bash
# Clone o repositório
git clone https://github.com/work-flow-manager/firecral-vds.git
cd firecrawl-docker

# Build local
docker-compose build

# Ou build direto
docker build -t firecrawl-production:latest .
```

## 🔧 Configuração

### Variáveis de Ambiente Importantes

```env
# API Keys
GEMINI_API_KEY=AIzaSyAJWyUi0s9DHtRorkuDVnpoxDXqDGTqNdw
TEST_API_KEY=7877e105e5f7b9ec3edf4a8eec5059ab9914efef1b30fe232f59ff31cb8e6fcf

# Ollama (local embeddings)
OLLAMA_BASE_URL=http://host.docker.internal:11434
MODEL_EMBEDDING_NAME=nomic-embed-text

# Proxies Webshare
PROXY_SERVER=http://xcuuwcfa:yccpzo0b9nth@45.61.100.172:6440
WEBSHARE_API_KEY=7tk8w3pjogiwpwpf84y0m8wc6zj6yrn8ycvhrrz8
```

## 🌐 Endpoints

- **Health Check**: `GET /health`
- **Scrape**: `POST /v0/scrape`
- **Crawl**: `POST /v0/crawl`
- **Search**: `POST /v0/search`

## 📊 Limites

- **Rate Limit**: 411 requests/hora (300k/mês)
- **Concurrent Requests**: 25
- **Timeout**: 30 segundos
- **Retry**: 3 tentativas

## 🔑 Autenticação

Use o header `Authorization`:
```bash
curl -X POST https://firecrawl.wmappliances.cloud/v0/scrape \
  -H "Authorization: Bearer 7877e105e5f7b9ec3edf4a8eec5059ab9914efef1b30fe232f59ff31cb8e6fcf" \
  -H "Content-Type: application/json" \
  -d '{"url": "https://example.com"}'
```

## 🐳 Docker Compose

Para rodar localmente:
```bash
docker-compose up -d
```

## 📝 Licença

Proprietary - Todos os direitos reservados
