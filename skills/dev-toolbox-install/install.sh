#!/bin/bash
# 开发工具箱一键安装脚本
# 包含: Claude CLI, Lark, Oh My Zsh, Docker, SDKMAN, Java, Go等完整工具链
# 用法: ./install.sh [options]

set -e

# 颜色输出
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

log() { echo -e "${GREEN}[$(date +'%H:%M:%S')]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
info() { echo -e "${BLUE}[INFO]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

# 默认参数
INSTALL_JAVA=true
INSTALL_GO=false
INSTALL_LARK_SKILLS=true
CONFIGURE_N8N=true
INSTALL_OH_MY_ZSH=false
INSTALL_SDKMAN=false
INSTALL_DOCKER=false

# 解析参数
while [[ $# -gt 0 ]]; do
  case $1 in
    --no-java) INSTALL_JAVA=false ;;
    --with-go) INSTALL_GO=true ;;
    --no-lark) INSTALL_LARK_SKILLS=false ;;
    --no-n8n) CONFIGURE_N8N=false ;;
    --with-oh-my-zsh) INSTALL_OH_MY_ZSH=true ;;
    --with-sdkman) INSTALL_SDKMAN=true ;;
    --with-docker) INSTALL_DOCKER=true ;;
    --help|-h)
      echo "用法: $0 [选项]"
      echo ""
      echo "选项:"
      echo "  --no-java        跳过Java/Maven安装"
      echo "  --with-go        安装Go语言环境"
      echo "  --no-lark        跳过Lark skills安装"
      echo "  --no-n8n         跳过n8n MCP配置"
      echo "  --with-oh-my-zsh 安装Oh My Zsh及相关插件"
      echo "  --with-sdkman    安装SDKMAN版本管理器"
      echo "  --with-docker    安装Docker和Docker Compose"
      echo ""
      exit 0
      ;;
    *) error "Unknown option: $1"; exit 1 ;;
  esac
  shift
done

log "🚀 开始安装开发工具箱..."
info "📋 安装配置:"
echo "   Java/Maven: $INSTALL_JAVA"
echo "   Go: $INSTALL_GO"
echo "   Lark Skills: $INSTALL_LARK_SKILLS"
echo "   n8n MCP: $CONFIGURE_N8N"
echo "   Oh My Zsh: $INSTALL_OH_MY_ZSH"
echo "   SDKMAN: $INSTALL_SDKMAN"
echo "   Docker: $INSTALL_DOCKER"
echo ""

# ===== 1. 检查基础工具 =====
log "🔍 检查基础工具..."

if ! command -v curl &> /dev/null; then
  error "curl未安装，请先安装: sudo apt install curl"
  exit 1
fi

if ! command -v git &> /dev/null; then
  error "git未安装，请先安装: sudo apt install git"
  exit 1
fi

log "✅ 基础工具检查通过"

# ===== 2. 检查Node.js和nvm =====
if ! command -v node &> /dev/null; then
  warn "Node.js未安装，正在安装nvm..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  nvm install node
else
  log "✅ Node.js $(node -v) 已安装 (nvm: $([ -s "$NVM_DIR/nvm.sh" ] && nvm --version || echo '未使用nvm'))"
fi

# ===== 3. 安装Docker (可选) =====
if [ "$INSTALL_DOCKER" = true ]; then
  if ! command -v docker &> /dev/null; then
    log "📦 安装Docker..."

    # 检测系统类型
    if [ -f /etc/os-release ]; then
      . /etc/os-release
      OS=$ID
    else
      error "无法检测操作系统类型"
      OS=""
    fi

    case $OS in
      ubuntu|debian)
        log "检测到Ubuntu/Debian系统，使用apt安装..."
        # 更新包索引
        sudo apt-get update

        # 安装依赖
        sudo apt-get install -y \
          ca-certificates \
          curl \
          gnupg \
          lsb-release

        # 添加Docker官方GPG key
        sudo mkdir -p /etc/apt/keyrings
        curl -fsSL https://download.docker.com/linux/${OS}/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

        # 设置仓库
        echo \
          "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/${OS} \
          $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

        # 安装Docker Engine
        sudo apt-get update
        sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

        # 将当前用户添加到docker组
        sudo usermod -aG docker $USER
        warn "请重新登录或运行 'newgrp docker' 以使docker组生效"

        log "✅ Docker已安装: $(docker --version)"
        ;;

      *)
        warn "不支持的系统: $OS，请手动安装Docker"
        info "访问 https://docs.docker.com/engine/install/ 获取安装指南"
        ;;
    esac
  else
    log "✅ Docker 已安装: $(docker --version 2>/dev/null || echo 'version unknown')"
  fi
fi

# ===== 4. 安装Oh My Zsh (可选) =====
if [ "$INSTALL_OH_MY_ZSH" = true ]; then
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    log "📦 安装Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

    # 安装插件
    log "📦 安装Zsh插件..."
    ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions 2>/dev/null || true
    git clone https://github.com/Aloxaf/fzf-tab $ZSH_CUSTOM/plugins/fzf-tab 2>/dev/null || true

    # 安装fzf
    if command -v apt-get &> /dev/null && ! command -v fzf &> /dev/null; then
      sudo apt-get install -y fzf
    fi

    # 安装zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting 2>/dev/null || true

    # 更新.zshrc插件配置
    if [ -f ~/.zshrc ]; then
      sed -i 's/^plugins=(git)/plugins=(git zsh-autosuggestions fzf-tab zsh-syntax-highlighting)/' ~/.zshrc
      log "✅ Zsh插件配置已更新"
    fi
  else
    log "✅ Oh My Zsh 已安装"
  fi
fi

# ===== 5. 安装SDKMAN (可选) =====
if [ "$INSTALL_SDKMAN" = true ]; then
  if [ ! -d "$HOME/.sdkman" ]; then
    log "📦 安装SDKMAN..."
    curl -s "https://get.sdkman.io" | bash
    export SDKMAN_DIR="$HOME/.sdkman"
    [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
    log "✅ SDKMAN 已安装"
  else
    log "✅ SDKMAN 已安装"
  fi
fi

# ===== 6. 安装Claude Code CLI =====
if ! command -v claude &> /dev/null; then
  log "📦 安装Claude Code CLI..."
  npm install -g @anthropic-ai/claude-code
else
  log "✅ Claude Code CLI 已安装: $(claude --version 2>/dev/null || echo 'version unknown')"
fi

# ===== 7. 安装Lark CLI =====
if ! command -v lark-cli &> /dev/null; then
  log "📦 安装Lark CLI..."
  npm install -g @larksuite/cli
else
  log "✅ Lark CLI 已安装: $(lark-cli --version 2>/dev/null || echo 'version unknown')"
fi

# ===== 8. 安装Java 17和Maven =====
if [ "$INSTALL_JAVA" = true ]; then
  if command -v sdk &> /dev/null; then
    # 使用SDKMAN安装
    if ! sdk list java 2>/dev/null | grep -q "17.0.12-tem"; then
      log "📦 通过SDKMAN安装Java 17..."
      sdk install java 17.0.12-tem
    else
      log "✅ Java 17 已通过SDKMAN安装"
    fi

    if ! sdk list maven 2>/dev/null | grep -q "installed"; then
      log "📦 通过SDKMAN安装Maven..."
      sdk install maven
    else
      log "✅ Maven 已通过SDKMAN安装"
    fi
  else
    # 系统包管理器安装
    if ! command -v java &> /dev/null; then
      log "📦 安装Java 17..."
      if command -v apt-get &> /dev/null; then
        sudo apt-get update
        sudo apt-get install -y openjdk-17-jdk maven
      elif command -v brew &> /dev/null; then
        brew install openjdk@17 maven
      else
        warn "无法自动安装Java，请手动安装Java 17和Maven"
      fi
    else
      log "✅ Java 已安装: $(java -version 2>&1 | head -1)"
    fi
  fi
fi

# ===== 9. 安装Go =====
if [ "$INSTALL_GO" = true ]; then
  if ! command -v go &> /dev/null; then
    log "📦 安装Go..."
    if command -v apt-get &> /dev/null; then
      sudo apt-get install -y golang-go
    elif command -v brew &> /dev/null; then
      brew install go
    else
      warn "无法自动安装Go，请手动安装"
    fi
  else
    log "✅ Go 已安装: $(go version 2>&1)"
  fi
fi

# ===== 10. 安装n8n-mcp =====
if [ "$CONFIGURE_N8N" = true ]; then
  if ! npm list -g n8n-mcp &> /dev/null; then
    log "📦 安装n8n-mcp..."
    npm install -g n8n-mcp
  else
    log "✅ n8n-mcp 已安装"
  fi
fi

# ===== 11. 安装oh-my-claudecode插件 =====
log "📦 安装oh-my-claudecode插件..."
if command -v claude &> /dev/null; then
  claude plugin install --source omc oh-my-claudecode 2>/dev/null || warn "oh-my-claudecode可能已安装"
else
  warn "Claude CLI未找到，跳过插件安装"
fi

# ===== 12. 安装Lark skills =====
if [ "$INSTALL_LARK_SKILLS" = true ]; then
  if command -v lark-cli &> /dev/null; then
    log "📦 安装Lark skills..."
    lark-cli skill install --all 2>/dev/null || {
      warn "批量安装失败，手动安装主要skills..."
      lark-cli skill install lark-base 2>/dev/null || true
      lark-cli skill install lark-doc 2>/dev/null || true
      lark-cli skill install lark-im 2>/dev/null || true
    }
  else
    warn "Lark CLI未找到，跳过skills安装"
  fi
fi

# ===== 13. 创建MCP配置 =====
MCP_CONFIG="$HOME/.mcp.json"
if [ "$CONFIGURE_N8N" = true ]; then
  if [ ! -f "$MCP_CONFIG" ]; then
    log "📝 创建MCP配置..."
    cat > "$MCP_CONFIG" << 'EOF'
{
  "mcpServers": {
    "n8n-mcp": {
      "command": "npx",
      "args": ["n8n-mcp"],
      "env": {
        "MCP_MODE": "stdio",
        "LOG_LEVEL": "error"
      }
    }
  }
}
EOF
    log "✅ MCP配置已创建: $MCP_CONFIG"
  else
    log "✅ MCP配置已存在: $MCP_CONFIG"
  fi
fi

# ===== 完成 =====
log "🎉 安装完成！"
echo ""
echo "=========================================="
echo "📊 已安装工具总览"
echo "=========================================="
echo "  🟢 Node.js:     $(node -v 2>/dev/null || echo 'N/A')"
echo "  🟢 Claude CLI:  $(claude --version 2>/dev/null || echo 'N/A')"
echo "  🟢 Lark CLI:    $(lark-cli --version 2>/dev/null || echo 'N/A')"
echo "  🟢 Java:        $(java -version 2>&1 | head -1 || echo 'N/A')"
echo "  🟢 Maven:       $(mvn --version 2>/dev/null | head -1 || echo 'N/A')"
echo "  🟢 Docker:      $(docker --version 2>/dev/null || echo 'N/A')"
echo "  🟢 fzf:         $(fzf --version 2>/dev/null || echo 'N/A')"
if [ "$INSTALL_GO" = true ]; then
  echo "  🟢 Go:          $(go version 2>/dev/null || echo 'N/A')"
fi
echo ""
echo "=========================================="
echo "🎯 下一步操作"
echo "=========================================="
echo "  1️⃣  配置Claude认证:"
echo "      export ANTHROPIC_AUTH_TOKEN=\"your-token\""
echo "      claude auth login"
echo ""
echo "  2️⃣  配置Lark认证:"
echo "      lark-cli auth login"
echo ""
if [ "$INSTALL_JAVA" = true ] && command -v sdk &> /dev/null; then
  echo "  3️⃣  设置默认Java版本:"
  echo "      sdk default java 17.0.12-tem"
  echo ""
fi
if [ "$INSTALL_DOCKER" = true ]; then
  echo "  4️⃣  配置Docker用户组:"
  echo "      newgrp docker"
  echo "      # 或重新登录"
  echo ""
fi
if [ "$CONFIGURE_N8N" = true ]; then
  echo "  5️⃣  配置n8n (可选):"
  echo "      export N8N_API_URL=\"http://localhost:5678\""
  echo "      export N8N_API_KEY=\"your-api-key\""
  echo ""
fi
echo "  6️⃣  重启Shell或运行:"
echo "      source ~/.zshrc"
echo ""
echo "=========================================="
echo "📚 查看完整武器库清单"
echo "=========================================="
echo "  cat 武器库清单.md"
echo ""
echo "=========================================="
