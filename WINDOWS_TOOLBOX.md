# Windows桌面端开发武器库

> 🪟 Windows开发环境完整配置清单
>
> 更新时间: 2026-04-10

## 📦 核心工具清单

### 1. 包管理器

#### Scoop - Windows包管理器
```powershell
# 安装Scoop
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
irm get.scoop.sh | iex

# 添加extras buckets
scoop bucket add extras
scoop bucket add versions

# 更新Scoop
scoop update
```

**用途**: 管理大部分Windows开发工具

### 2. 浏览器

#### Google Chrome
```powershell
# 通过Scoop安装
scoop install chrome

# 或手动下载
# https://www.google.com/chrome/
```

**用途**: 主力浏览器

### 3. 开发工具

#### JetBrains Toolbox
```powershell
# 通过Scoop安装
scoop install jetbrains-toolbox

# 或手动下载
# https://www.jetbrains.com/toolbox-app/
```

**用途**: 管理JetBrains全家桶（IntelliJ IDEA、PyCharm等）

#### Visual Studio Code
```powershell
# 通过Scoop安装
scoop install vscode

# 或通过winget
winget install Microsoft.VisualStudioCode

# 配置settings.json
# 位置: %APPDATA%\Code\User\settings.json
```

**推荐插件**:
```json
{
  "recommendations": [
    "ms-python.python",
    "ms-python.vscode-pylance",
    "github.copilot",
    "eamodio.gitlens",
    "ms-vscode.live-server",
    "formulahendry.auto-rename-tag",
    "christian-kohler.path-intellisense"
  ]
}
```

#### Visual Studio 2022
```powershell
# 通过winget安装
winget install Microsoft.VisualStudio.2022.Community

# 或手动下载
# https://visualstudio.microsoft.com/
```

**推荐工作负载**:
- .NET桌面开发
- Python开发
- Node.js开发
- 通用Windows平台开发

### 4. 笔记与文档

#### Obsidian
```powershell
# 通过Scoop安装
scoop install obsidian

# 或通过winget
winget install Obsidian.Obsidian

# 配置目录
# 通常: C:\Users\YourName\Documents\Obsidian
```

**推荐插件**:
- Calendar
- Dataview
- Excalidraw
- Advanced Tables
- Templater

### 5. 开发CLI工具

#### GitHub CLI (gh)
```powershell
# 通过Scoop安装
scoop install gh

# 认证
gh auth login

# 常用命令
gh repo list
gh pr list
gh issue list
```

**用途**: GitHub命令行工具

#### Claude Code CLI
```powershell
# 通过npm安装（需要Node.js）
npm install -g @anthropic-ai/claude-code

# 认证
claude auth login
```

### 6. 通讯与协作

#### 飞书 (Lark)
```powershell
# 通过winget安装
winget install ByteDance.Feishu

# 或手动下载
# https://www.feishu.cn/
```

**用途**: 企业协作平台

### 7. 代理工具

#### Clash for Windows
```powershell
# 通过Scoop安装
scoop install clash-for-windows

# 或手动下载
# https://github.com/Fndroid/clash_for_windows_pkg/releases

# 配置文件位置
# C:\Users\YourName\.config\clash\
```

**注意**: ⚠️ Clash for Windows已停止维护，推荐替代品：
- Clash Verge (Rev)
- v2rayN
```powershell
scoop install clash-verge
# 或
scoop install v2rayn
```

### 8. 截图工具

#### Snipaste
```powershell
# 通过Scoop安装
scoop install snipaste

# 或手动下载
# https://www.snipaste.com/

# 快捷键
# F1: 截图
# F3: 贴图
```

**用途**: 强大的截图和贴图工具

### 9. AI工具

#### 豆包 (Doubao)
```powershell
# 通过winget安装
winget install ByteDance.Doubao

# 或手动下载
# https://www.doubao.com/
```

**用途**: 字节跳动AI助手

### 10. 下载工具

#### 迅雷 (Xunlei)
```powershell
# 通过winget安装
winget install Xunlei.Xunlei

# 或手动下载
# https://www.xunlei.com/
```

**用途**: 下载工具

### 11. 办公软件

#### WPS Office
```powershell
# 通过winget安装
winget install Kingsoft.WPSOffice

# 或手动下载
# https://www.wps.cn/
```

**替代方案**:
- Microsoft Office (winget install Microsoft.Office)
- LibreOffice (scoop install libreoffice)

### 12. 其他工具

#### Clicli (待确认)
可能是命令行工具，需要更多信息

#### Windows Terminal
```powershell
# 通过Scoop安装
scoop install windows-terminal

# 或通过Microsoft Store安装
# 配置PowerShell 7
scoop install pwsh
```

**推荐配置**:
```json
{
  "profiles": {
    "defaults": {
      "fontFace": "Cascadia Code",
      "fontSize": 11,
      "colorScheme": "One Half Dark"
    }
  }
}
```

## 🚀 一键安装脚本

### PowerShell自动化脚本

保存为 `install-windows-toolbox.ps1`:

```powershell
# Windows开发工具箱一键安装脚本
# 管理员运行PowerShell

# 设置执行策略
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

# 检查Scoop
if (!(Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "安装Scoop..." -ForegroundColor Green
    irm get.scoop.sh | iex
}

# 添加buckets
scoop bucket add extras
scoop bucket add versions

# 安装开发工具
Write-Host "安装开发工具..." -ForegroundColor Green
scoop install git
scoop install python
scoop install nodejs
scoop install go
scoop install java17
scoop install maven
scoop install gradle

# 安装CLI工具
Write-Host "安装CLI工具..." -ForegroundColor Green
scoop install gh
scoop install windows-terminal
scoop install pwsh

# 安装编辑器
Write-Host "安装编辑器..." -ForegroundColor Green
scoop install vscode
scoop install jetbrains-toolbox

# 安装其他工具
Write-Host "安装其他工具..." -ForegroundColor Green
scoop install obsidian
scoop install snipaste
scoop install chrome

# 通过winget安装GUI应用
Write-Host "安装GUI应用..." -ForegroundColor Green
winget install Microsoft.VisualStudio.2022.Community
winget install ByteDance.Feishu
winget install ByteDance.Doubao
winget install Kingsoft.WPSOffice

Write-Host "✅ 安装完成！" -ForegroundColor Green
```

### 使用方法

```powershell
# 1. 以管理员运行PowerShell
# 2. 允许脚本执行
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

# 3. 运行脚本
.\install-windows-toolbox.ps1
```

## 📋 安装检查清单

- [ ] Scoop包管理器
- [ ] Google Chrome
- [ ] JetBrains Toolbox
- [ ] Obsidian
- [ ] Clash/V2rayN
- [ ] 飞书
- [ ] Snipaste
- [ ] Clicli
- [ ] 豆包
- [ ] GitHub CLI (gh)
- [ ] Claude Code CLI
- [ ] 迅雷
- [ ] Visual Studio Code
- [ ] WPS Office
- [ ] Visual Studio 2022
- [ ] Windows Terminal

## 🔧 配置文件位置

### VS Code
```powershell
# Settings
$env:APPDATA\Code\User\settings.json

# Extensions
$env:USERPROFILE\.vscode\extensions\
```

### Windows Terminal
```powershell
# Settings
$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json
```

### Git
```powershell
# Config
$env:USERPROFILE\.gitconfig

# SSH Keys
$env:USERPROFILE\.ssh\
```

### PowerShell
```powershell
# Profile
$PROFILE

# Modules
$env:USERPROFILE\Documents\PowerShell\Modules\
```

## 🎯 推荐工作流

### 1. 初始化新电脑
```powershell
# 1. 安装Scoop
irm get.scoop.sh | iex

# 2. 安装开发工具
scoop install git vscode windows-terminal

# 3. 安装开发环境
scoop install python nodejs go java17

# 4. 安装CLI工具
scoop install gh

# 5. 配置Git
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
```

### 2. 日常开发
```powershell
# 使用Windows Terminal
# 打开VS Code
code .

# 使用gh管理GitHub
gh repo create

# 使用Claude CLI
claude
```

## 📚 参考资源

- [Scoop官网](https://scoop.sh/)
- [Windows Package Manager](https://docs.microsoft.com/en-us/windows/package-manager/)
- [PowerShell文档](https://docs.microsoft.com/en-us/powershell/)
- [Windows Terminal文档](https://docs.microsoft.com/en-us/windows/terminal/)

## 🔄 同步配置

### 使用Git Dotfiles

```powershell
# 创建dotfiles仓库
mkdir ~/dotfiles
cd ~/dotfiles
git init

# 添加配置文件
git add $PROFILE
git add $env:USERPROFILE\.gitconfig

# 推送到GitHub
gh repo create dotfiles --private
git remote add origin https://github.com/YOUR_USERNAME/dotfiles.git
git push -u origin main
```

### 使用OneDrive/Dropbox同步

```powershell
# 创建符号链接
mklink /D "$env:USERPROFILE\Documents\Obsidian" "C:\Path\ToOneDrive\Obsidian"
```

---

**生成工具**: Claude Code
**维护者**: crab
**更新时间**: 2026-04-10
