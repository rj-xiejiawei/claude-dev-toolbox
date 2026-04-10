---
name: dev-toolbox-install
description: 一键安装完整开发环境 - Claude CLI, Lark, Oh My Zsh, SDKMAN, Java, Go, MCP等全套工具链
categories: [setup, installation, environment, system]
author: claude
version: 2.0.0
---

# 开发工具箱一键安装 (完整版)

自动安装完整的Claude Code开发环境，包括系统工具、版本管理器、Shell增强、开发语言、MCP服务器等。

## 安装内容

### 系统基础层
- Oh My Zsh (可选)
- zsh-autosuggestions (命令自动建议)
- fzf-tab (模糊补全)
- fzf (模糊搜索器)

### 版本管理器
- nvm (Node.js版本管理)
- SDKMAN (Java/多语言版本管理)

### Claude生态
- Claude Code CLI
- oh-my-claudecode插件 (多代理编排)
- 41个skills (20 Lark + 21自定义)

### 开发语言
- Java 17 (通过SDKMAN或系统包)
- Maven (Java构建工具)
- Go (可选)

### MCP服务器
- n8n-mcp (工作流自动化)

### 飞书集成
- @larksuite/cli
- 20+ Lark集成skills

## 用法

```bash
# 完整安装 (推荐)
/dev-toolbox-install

# 自定义安装
/dev-toolbox-install --no-java          # 跳过Java/Maven
/dev-toolbox-install --with-go          # 包含Go
/dev-toolbox-install --no-lark          # 跳过Lark skills
/dev-toolbox-install --no-n8n           # 跳过n8n配置
/dev-toolbox-install --with-oh-my-zsh   # 安装Oh My Zsh
/dev-toolbox-install --with-sdkman      # 安装SDKMAN

# 查看帮助
/dev-toolbox-install --help
```

## 安装选项

| 选项 | 说明 | 默认 |
|------|------|------|
| `--no-java` | 跳过Java/Maven安装 | - |
| `--with-go` | 安装Go语言环境 | - |
| `--no-lark` | 跳过Lark skills | - |
| `--no-n8n` | 跳过n8n MCP配置 | - |
| `--with-oh-my-zsh` | 安装Oh My Zsh及插件 | - |
| `--with-sdkman` | 安装SDKMAN版本管理器 | - |

## 前置要求

- Linux/macOS/WSL2系统
- curl 和 git 已安装
- sudo 权限 (用于系统包安装)

## 安装后配置

### 1. Claude认证
```bash
export ANTHROPIC_AUTH_TOKEN="sk-ant-xxxxx"
claude auth login
```

### 2. Lark认证
```bash
lark-cli auth login
```

### 3. Java版本 (如使用SDKMAN)
```bash
sdk default java 17.0.12-tem
```

### 4. 重启Shell
```bash
source ~/.zshrc
# 或重启终端
```

## 配置文件

- `~/.claude/settings.json` - Claude设置
- `~/.mcp.json` - MCP服务器配置
- `~/.zshrc` - Zsh配置
- `~/.lark-cli/config.json` - 飞书配置

## 详细清单

查看完整的工具清单和配置说明: `/武器库清单`

## 故障排查

### SDKMAN离线问题
```bash
mkdir -p ~/.sdkman/etc
echo "sdkman_healthcheck_enable=false" > ~/.sdkman/etc/config
```

### Java版本切换
```bash
sdk list java              # 查看可用版本
sdk use java 17.0.12-tem   # 临时切换
sdk default java 17.0.12-tem # 设置默认
```

### Node版本切换
```bash
nvm list          # 查看已安装版本
nvm use 20        # 切换版本
```

## 版本

**v2.0.0** - 完整版
- 新增: Oh My Zsh支持
- 新增: SDKMAN支持
- 新增: 系统工具检测
- 改进: 更好的错误处理
- 改进: 详细的安装日志

**v1.0.0** - 基础版
- Claude CLI + Lark CLI
- Java + Maven
- n8n-mcp
