# GitHub推送指南

## 🚀 快速推送

### 方式1: 使用GitHub CLI (推荐)

```bash
# 1. 安装gh CLI（如果未安装）
sudo apt install gh

# 2. 登录GitHub
gh auth login

# 3. 创建仓库并推送
cd /mnt/d/code/other/claude-dev-toolbox
gh repo create claude-dev-toolbox --public --source=. --remote=origin --push
```

### 方式2: 手动创建并推送

```bash
# 1. 在GitHub网站创建新仓库
#    访问: https://github.com/new
#    仓库名: claude-dev-toolbox
#    设置为Public或Private

# 2. 添加远程仓库
cd /mnt/d/code/other/claude-dev-toolbox
git remote add origin https://github.com/YOUR_USERNAME/claude-dev-toolbox.git

# 3. 重命名分支为main
git branch -M main

# 4. 推送到GitHub
git push -u origin main
```

## 📋 推送前检查清单

- [ ] 修改README.md中的用户名
- [ ] 确认LICENSE信息正确
- [ ] 检查敏感信息（API密钥等）
- [ ] 测试安装脚本

## 🔄 后续使用

### 克隆到新环境

```bash
git clone https://github.com/YOUR_USERNAME/claude-dev-toolbox.git
cd claude-dev-toolbox
./skills/dev-toolbox-install/install.sh --with-docker
```

### 更新仓库

```bash
git add .
git commit -m "描述你的更改"
git push
```

## 🌟 推广

- 在Twitter分享
- 在Reddit r/devtools发布
- 添加到Awesome Lists
- 告诉你的团队和朋友
