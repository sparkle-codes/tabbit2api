# Tabbit2API

[![Python](https://img.shields.io/badge/Python-3.11+-blue.svg)](https://www.python.org/)
[![FastAPI](https://img.shields.io/badge/FastAPI-0.110+-green.svg)](https://fastapi.tiangolo.com/)
[![Docker](https://img.shields.io/badge/Docker-ready-blue.svg)](https://www.docker.com/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

**Tabbit2API** 是一个非官方的 API 适配器，将 Tabbit 浏览器的内部 AI 接口转换为 OpenAI 和 Anthropic Claude 兼容的标准 API，让你可以在任何支持自定义 API 地址的客户端中使用 Tabbit 的 AI 能力。

> **支持版本**：国内版 Tabbit (web.tabbit-ai.com)

---

## ✨ 核心功能

- **双协议兼容** — 同时支持 OpenAI (`/v1/chat/completions`) 和 Anthropic Claude (`/v1/messages`) 两种 API 格式
- **Claude Code 支持** — 可直接接入 Claude Code，支持工具调用和 thinking 模式
- **多账户轮询** — 内置 Token 池，支持添加多个 Tabbit 账户，自动负载均衡
- **智能健康管理** — 自动监控 Token 状态，连续出错自动冷却
- **Web 管理面板** — 可视化管理 Token、查看日志、修改配置
- **Google 登录获取 Token** — 支持通过 Google 账号自动获取 Tabbit Token
- **流式与非流式** — 完整支持 Streaming 和非流式响应
- **Docker 部署** — 提供完整的 Docker Compose 配置

---

## 📋 环境要求

| 依赖 | 版本要求 | 说明 |
|------|----------|------|
| Python | >= 3.11 | 推荐 3.11 或 3.12 |
| pip | 最新版 | 用于安装 Python 依赖 |
| Docker | >= 24.0（可选） | 仅 Docker 部署时需要 |

Python 依赖包（自动安装）：

```
fastapi >= 0.110.0
uvicorn >= 0.29.0
httpx >= 0.27.0
pydantic >= 2.0.0
urllib3 >= 2.0.0
```

---

## 🚀 快速开始

### 方式一：Python 启动（推荐）

```bash
# 1. 克隆项目
git clone https://github.com/sparkle-codes/tabbit2api.git
cd tabbit2api

# 2. 安装依赖
pip install -r requirements.txt

# 3. 启动服务
python tabbit2api.py
```

服务将在 `http://localhost:8800` 启动，首次运行自动生成配置文件。

### 方式二：Docker Compose 部署

```bash
git clone https://github.com/sparkle-codes/tabbit2api.git
cd tabbit2api
docker compose up -d
```

### 方式三：Conda 环境

```bash
conda env create -f environment.yml
conda activate tabbit2api
python tabbit2api.py
```

---

## 🔧 配置

### 添加 Token

1. 打开管理面板 `http://localhost:8800/admin`（默认密码 `admin`）
2. 进入 **Tokens** 页面
3. 点击「手动添加」或「Google 登录获取」

### 配置文件

配置文件 `config.json` 在首次启动时自动生成。也可参考 `config.json.example` 手动创建：

```json
{
  "server": {
    "host": "0.0.0.0",
    "port": 8800
  },
  "tabbit": {
    "base_url": "https://web.tabbit-ai.com",
    "client_id": "2dd8eb4c1ed9c344d173"
  },
  "tokens": [
    {
      "name": "my-account",
      "value": "<你的 Tabbit Token>",
      "enabled": true
    }
  ],
  "proxy": {
    "api_key": "",
    "system_prompt": ""
  },
  "claude": {
    "default_model": "best",
    "system_prompt": ""
  }
}
```

| 配置项 | 路径 | 默认值 | 说明 |
|--------|------|--------|------|
| 服务端口 | `server.port` | `8800` | 服务监听端口 |
| Tabbit 域名 | `tabbit.base_url` | `https://web.tabbit-ai.com` | 上游 API 地址 |
| 代理 API Key | `proxy.api_key` | 空 | 全局 API Key 校验（留空则不校验） |
| Claude 默认模型 | `claude.default_model` | `best` | Claude Code 使用的默认模型 |

---

## 📦 支持的模型

| 模型 ID | 说明 |
|---------|------|
| `best` | 自动选择最优模型（推荐） |
| `kimi-k2.6` | Moonshot 最新旗舰多模态 |
| `kimi-k2.5` | Moonshot 旗舰多模态 |
| `glm-5.1` | 智谱最新文本模型 |
| `glm-5v-turbo` | 智谱多模态模型 |
| `deepseek-v4-pro` | DeepSeek 旗舰 Pro |
| `deepseek-v4-flash` | DeepSeek 旗舰 Flash |
| `deepseek-v3.2` | DeepSeek MoE |
| `minimax-m2.7` | MiniMax 旗舰文本 |
| `qwen3.5-plus` | 阿里千问多模态 |
| `doubao-seed-1.8` | 字节豆包旗舰 |
| `longcat-flash-chat` | 美团旗舰模型 |
| `longcat-flash-thinking` | 美团思考模型 |

---

## 🔌 API 端点

### OpenAI 兼容

```bash
curl http://localhost:8800/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "best",
    "messages": [{"role": "user", "content": "你好！"}],
    "stream": false
  }'
```

### Claude 兼容

```bash
curl http://localhost:8800/v1/messages \
  -H "Content-Type: application/json" \
  -H "x-api-key: any-key" \
  -H "anthropic-version: 2023-06-01" \
  -d '{
    "model": "best",
    "messages": [{"role": "user", "content": "你好！"}],
    "stream": true
  }'
```

### 其他端点

| 端点 | 方法 | 说明 |
|------|------|------|
| `/v1/models` | GET | 获取模型列表 |
| `/health` | GET | 健康检查 |
| `/admin` | GET | 管理面板 |

---

## 🎯 客户端接入

### Cherry Studio / NextChat / Trae

1. 设置 → 模型供应商 → 添加「自定义 OpenAI 兼容 API」
2. **API Base URL**: `http://localhost:8800/v1`
3. **API Key**: 留空（或填你设置的 `proxy.api_key`）
4. 手动添加模型 ID：`best`、`kimi-k2.6`、`glm-5.1` 等

### Claude Code

在配置文件中设置：

```json
{
  "env": {
    "ANTHROPIC_API_KEY": "any-key-here",
    "ANTHROPIC_BASE_URL": "http://localhost:8800",
    "ANTHROPIC_MODEL": "best"
  }
}
```

### Python 调用

```python
import requests

resp = requests.post("http://localhost:8800/v1/chat/completions", json={
    "model": "best",
    "messages": [{"role": "user", "content": "你好"}],
    "stream": False
})
print(resp.json()["choices"][0]["message"]["content"])
```

---

## 🐳 Docker 部署

```bash
# 构建并运行
docker compose up -d

# 自定义端口
PORT=9900 docker compose up -d

# 查看日志
docker compose logs -f

# 停止
docker compose down
```

### Nginx 反向代理

```nginx
server {
    listen 80;
    server_name api.your-domain.com;

    location / {
        proxy_pass http://localhost:8800;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_read_timeout 300s;
    }
}
```

---

## 📁 项目结构

```
tabbit2api/
├── tabbit2api.py          # 主入口
├── config.json            # 配置文件（自动生成，勿上传）
├── config.json.example    # 配置示例
├── requirements.txt       # Python 依赖
├── Dockerfile             # Docker 镜像
├── docker-compose.yml     # Docker Compose
├── start.bat              # Windows 一键启动
├── core/
│   ├── tabbit_client.py   # Tabbit 上游客户端
│   ├── token_manager.py   # Token 池管理
│   ├── claude_compat.py   # Claude API 兼容层
│   ├── config.py          # 配置管理
│   ├── auth.py            # 鉴权
│   └── log_store.py       # 日志存储
├── routes/
│   ├── openai_compat.py   # OpenAI 兼容路由
│   ├── claude_api.py      # Claude 兼容路由
│   └── admin_api.py       # 管理面板 API
└── static/
    └── index.html         # 管理面板前端
```

---

## 🔒 安全建议

1. **修改默认密码** — 登录管理面板后立即修改默认密码 `admin`
2. **设置 API Key** — 在配置中设置 `proxy.api_key` 防止未授权访问
3. **启用 HTTPS** — 使用 Nginx + Certbot 配置 SSL 证书
4. **不要上传 config.json** — 已在 `.gitignore` 中排除

---

## 🙏 参考项目

- [hih24337/tabb2](https://github.com/hih24337/tabb2) — 设计思路参考
- [CassiopeiaCode/b4u2cc](https://github.com/CassiopeiaCode/b4u2cc) — Claude 兼容层参考

---

## 📄 许可证

[MIT License](LICENSE)
