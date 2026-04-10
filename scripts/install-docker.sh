#!/bin/bash
# Docker安装脚本
# 支持: Ubuntu, Debian

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARNING]${NC} $1"; }

log "🐳 开始安装Docker..."

# 检测系统
if [ -f /etc/os-release ]; then
  . /etc/os-release
  OS=$ID
else
  warn "无法检测操作系统"
  exit 1
fi

case $OS in
  ubuntu|debian)
    log "检测到 $OS 系统"

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

    log "✅ Docker安装完成!"
    echo ""
    echo "版本信息:"
    docker --version
    docker compose version
    echo ""
    warn "请重新登录或运行 'newgrp docker' 以使docker组生效"
    ;;

  *)
    warn "不支持的系统: $OS"
    log "请访问 https://docs.docker.com/engine/install/ 获取安装指南"
    exit 1
    ;;
esac
