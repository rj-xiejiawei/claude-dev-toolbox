# Claude Code 开发武器库

> 🚀 一键安装完整开发环境 - Claude CLI, Lark, Oh My Zsh, Docker, SDKMAN等全套工具链

## ✨ 特性

- 📦 **一键安装** - 单条命令安装所有开发工具
- 🔧 **模块化** - 支持自定义安装选项
- 📚 **完整文档** - 详细的工具清单和配置说明
- 🔄 **可复现** - 新环境快速复刻相同配置
- 🎯 **持续更新** - 跟踪最新版本和最佳实践

## 🚀 快速开始

### 一键安装

```bash
# 克隆仓库
git clone https://github.com/your-username/claude-dev-toolbox.git
cd claude-dev-toolbox

# 运行安装脚本
./skills/dev-toolbox-install/install.sh

# 或查看所有选项
./skills/dev-toolbox-install/install.sh --help
```

### 安装选项

```bash
# 完整安装（推荐）
./install.sh

# 自定义安装
./install.sh --no-java          # 跳过Java/Maven
./install.sh --with-go          # 安装Go
./install.sh --no-lark          # 跳过Lark skills
./install.sh --no-n8n           # 跳过n8n配置
./install.sh --with-oh-my-zsh   # 安装Oh My Zsh
./install.sh --with-sdkman      # 安装SDKMAN
./install.sh --with-docker      # 安装Docker
```

## 📊 包含工具

### 系统基础层
- **Shell**: zsh + Oh My Zsh
- **版本管理**: nvm (Node.js), SDKMAN (Java)
- **模糊搜索**: fzf v0.44.1
- **Zsh插件**: zsh-autosuggestions, fzf-tab
- **容器**: Docker + docker-compose

### Claude生态
- **Claude CLI**: v2.1.96
- **oh-my-claudecode**: v4.11.4 (多代理编排)
- **Skills**: 41个 (20 Lark + 21 自定义)

### 开发语言
- **Node.js**: v24.14.1
- **Java**: 17 (通过SDKMAN)
- **Maven**: 最新版本
- **Go**: 可选
- **Python**: 系统自带

### 飞书集成
- **Lark CLI**: v1.0.7
- **20+ Lark Skills**: 文档、表格、日历、通讯录等

### MCP服务器
- **n8n-mcp**: 工作流自动化

## 📁 目录结构

```
claude-dev-toolbox/
├── README.md                   # 本文件
├── 武器库清单.md               # 完整工具清单和配置
├── skills/                     # Claude skills
│   ├── dev-toolbox-install/   # 一键安装skill
│   ├── 武器库清单/             # 查看清单skill
│   └── 系统环境检查/           # 环境检查skill
├── scripts/                    # 辅助脚本
│   ├── install-docker.sh      # Docker安装脚本
│   └── backup-config.sh       # 配置备份脚本
└── docs/                       # 详细文档
    ├── INSTALLATION.md        # 安装指南
    ├── CONFIGURATION.md       # 配置说明
    └── TROUBLESHOOTING.md     # 故障排查
```

## 📚 详细文档

- [完整武器库清单](武器库清单.md) - 所有工具的详细列表
- [安装指南](docs/INSTALLATION.md) - 详细安装步骤
- [配置说明](docs/CONFIGURATION.md) - 配置文件详解
- [故障排查](docs/TROUBLESHOOTING.md) - 常见问题解决

## 🔧 使用方法

### 查看工具清单

```bash
# 方式1: 使用skill（需要Claude CLI）
/武器库清单

# 方式2: 直接查看
cat 武器库清单.md
```

### 检查环境状态

```bash
# 使用skill
/系统环境检查

# 或手动检查
./skills/系统环境检查/check.sh
```

### 备份配置

```bash
# 备份所有配置
./scripts/backup-config.sh

# 恢复配置
./scripts/backup-config.sh --restore
```

## 🎯 前置要求

- **操作系统**: Linux/macOS/WSL2
- **基础工具**: curl, git, sudo权限
- **网络**: 能够访问GitHub和npm registry

## 📦 安装后配置

### 1. Claude认证

```bash
export ANTHROPIC_AUTH_TOKEN="sk-ant-xxxxx"
claude auth login
```

### 2. Lark认证

```bash
lark-cli auth login
```

### 3. Docker配置（可选）

```bash
# 将用户添加到docker组（避免sudo）
sudo usermod -aG docker $USER

# 重新登录或运行
newgrp docker
```

### 4. 重启Shell

```bash
source ~/.zshrc
# 或重启终端
```

## 🔍 版本管理

### Node.js (nvm)

```bash
nvm list                  # 查看已安装版本
nvm install 20            # 安装新版本
nvm use 20                # 切换版本
nvm alias default 20      # 设置默认版本
```

### Java (SDKMAN)

```bash
sdk list java             # 查看可用版本
sdk install java 21.0.1-tem
sdk use java 21.0.1-tem   # 临时切换
sdk default java 21.0.1-tem # 设置默认
```

## 💡 常见问题

### SDKMAN离线问题

```bash
mkdir -p ~/.sdkman/etc
echo "sdkman_healthcheck_enable=false" > ~/.sdkman/etc/config
```

### Docker权限问题

```bash
sudo usermod -aG docker $USER
newgrp docker
```

### Java版本冲突

```bash
sdk list java
sdk default java 17.0.12-tem
```

更多问题请查看 [故障排查文档](docs/TROUBLESHOOTING.md)

## 🤝 贡献

欢迎提交Issue和Pull Request！

1. Fork本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启Pull Request

## 📝 更新日志

### v2.0.0 (2026-04-10)
- ✨ 新增Docker安装支持
- ✨ 新增完整的Shell增强工具
- ✨ 新增SDKMAN支持
- 📝 完善文档体系
- 🐛 修复安装脚本的兼容性问题

### v1.0.0 (2026-04-10)
- 🎉 初始版本
- ✅ Claude CLI + Lark CLI
- ✅ Java + Maven安装
- ✅ n8n-mcp配置

## 📄 许可证

本项目采用 MIT 许可证 - 详见 [LICENSE](LICENSE) 文件

## 🙏 致谢

- [Claude Code](https://github.com/anthropics/claude-code) - Anthropic官方CLI
- [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) - 多代理编排系统
- [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh) - Zsh配置框架
- [fzf](https://github.com/junegunn/fzf) - 命令行模糊搜索器

## 📮 联系方式

- 作者: crab
- GitHub: [your-username]
- 项目主页: [https://github.com/your-username/claude-dev-toolbox]

---

⭐ 如果这个项目对你有帮助，请给个Star！
