# Windows开发工具箱一键安装脚本
# 管理员运行PowerShell

#Requires -RunAsAdministrator

$ErrorActionPreference = "Stop"

# 颜色输出函数
function Write-ColorOutput($ForegroundColor) {
    $fc = $host.UI.RawUI.ForegroundColor
    $host.UI.RawUI.ForegroundColor = $ForegroundColor
    if ($args) {
        Write-Output $args
    }
    $host.UI.RawUI.ForegroundColor = $fc
}

function Write-Success { Write-ColorOutput Green $args }
function Write-Info { Write-ColorOutput Cyan $args }
function Write-Warning { Write-ColorOutput Yellow $args }
function Write-Error { Write-ColorOutput Red $args }

Write-Info "╔══════════════════════════════════════════════════════════════╗"
Write-Info "║          🪟 Windows开发工具箱一键安装脚本                       ║"
Write-Info "╚══════════════════════════════════════════════════════════════╝"
Write-Info ""
Write-Info "开始安装Windows开发环境..."
Write-Info ""

# 检查管理员权限
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "请以管理员身份运行此脚本！"
    exit 1
}

# 设置执行策略
Write-Info "📋 配置PowerShell执行策略..."
try {
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    Write-Success "✅ 执行策略已设置"
} catch {
    Write-Warning "⚠️  执行策略设置失败: $_"
}

# 安装Scoop
Write-Info ""
Write-Info "📦 检查Scoop包管理器..."
if (!(Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Info "正在安装Scoop..."
    try {
        irm get.scoop.sh | iex
        Write-Success "✅ Scoop安装完成"
    } catch {
        Write-Error "❌ Scoop安装失败: $_"
        exit 1
    }
} else {
    Write-Success "✅ Scoop已安装: $(scoop --version)"
}

# 添加buckets
Write-Info ""
Write-Info "📦 添加Scoop buckets..."
try {
    scoop bucket add extras -q
    scoop bucket add versions -q
    Write-Success "✅ Buckets已添加"
} catch {
    Write-Warning "⚠️  Buckets添加失败: $_"
}

# 更新Scoop
Write-Info ""
Write-Info "🔄 更新Scoop..."
scoop update *

# 定义安装列表
$packages = @{
    # 开发工具
    "开发工具" = @(
        "git",
        "python",
        "nodejs",
        "go",
        "java17",
        "maven",
        "gradle"
    )

    # 编辑器和IDE
    "编辑器" = @(
        "vscode",
        "jetbrains-toolbox"
    )

    # CLI工具
    "CLI工具" = @(
        "gh",
        "windows-terminal",
        "pwsh",
        "starship"
    )

    # 其他工具
    "其他工具" = @(
        "obsidian",
        "snipaste",
        "chrome"
    )
}

# 安装Scoop包
foreach ($category in $packages.Keys) {
    Write-Info ""
    Write-Info "📦 安装$category..."
    foreach ($pkg in $packages[$category]) {
        Write-Info "  正在安装 $pkg..."
        try {
            scoop install $pkg -q
            Write-Success "  ✅ $pkg"
        } catch {
            Write-Warning "  ⚠️  $pkg 安装失败: $_"
        }
    }
}

# 安装winget应用
Write-Info ""
Write-Info "📦 安装Windows应用（winget）..."

$wingetApps = @(
    @{Name = "Microsoft.VisualStudio.2022.Community"; DisplayName = "Visual Studio 2022"},
    @{Name = "ByteDance.Feishu"; DisplayName = "飞书"},
    @{Name = "ByteDance.Doubao"; DisplayName = "豆包"},
    @{Name = "Kingsoft.WPSOffice"; DisplayName = "WPS Office"},
    @{Name = "Xunlei.Xunlei"; DisplayName = "迅雷"}
)

foreach ($app in $wingetApps) {
    Write-Info "  正在安装 $($app.DisplayName)..."
    try {
        winget install --id $app.Name -e --accept-source-agreements --accept-package-agreements -q
        Write-Success "  ✅ $($app.DisplayName)"
    } catch {
        Write-Warning "  ⚠️  $($app.DisplayName) 安装失败: $_"
    }
}

# 配置Git
Write-Info ""
Write-Info "🔧 配置Git..."
$gitConfigured = $false
if (Get-Command git -ErrorAction SilentlyContinue) {
    $userName = Read-Host "请输入Git用户名（留空跳过）"
    if ($userName) {
        $userEmail = Read-Host "请输入Git邮箱"
        git config --global user.name $userName
        git config --global user.email $userEmail
        Write-Success "✅ Git已配置"
        $gitConfigured = $true
    }
}

if (-not $gitConfigured) {
    Write-Warning "⚠️  Git配置已跳过"
}

# 安装Claude Code CLI
Write-Info ""
Write-Info "📦 安装Claude Code CLI..."
if (Get-Command npm -ErrorAction SilentlyContinue) {
    try {
        npm install -g @anthropic-ai/claude-code
        Write-Success "✅ Claude Code CLI已安装"
    } catch {
        Write-Warning "⚠️  Claude Code CLI安装失败: $_"
    }
} else {
    Write-Warning "⚠️  npm未找到，跳过Claude Code CLI安装"
}

# 创建符号链接
Write-Info ""
Write-Info "🔧 配置开发环境..."

# 配置Windows Terminal
if (Test-Path "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe") {
    Write-Success "✅ Windows Terminal已安装"
}

# 完成信息
Write-Info ""
Write-Info "╔══════════════════════════════════════════════════════════════╗"
Write-Info "║                    ✅ 安装完成！                              ║"
Write-Info "╚══════════════════════════════════════════════════════════════╝"
Write-Info ""
Write-Info "📋 已安装工具："
Write-Info ""

# 显示版本信息
$versionCommands = @{
    "Scoop" = "scoop --version"
    "Git" = "git --version"
    "Node.js" = "node --version"
    "Python" = "python --version"
    "Go" = "go version"
    "Java" = "java -version"
    "VS Code" = "code --version"
    "GitHub CLI" = "gh --version"
    "PowerShell" = "$PSVersionTable.PSVersion"
}

foreach ($tool in $versionCommands.Keys) {
    $cmd = $versionCommands[$tool]
    try {
        $output = Invoke-Expression $cmd 2>&1 | Select-Object -First 1
        Write-Success "  ✅ $tool : $output"
    } catch {
        Write-Warning "  ⚠️  $tool : 未安装或配置"
    }
}

Write-Info ""
Write-Info "🎯 下一步操作："
Write-Info ""
Write-Info "1. 重启终端以使所有更改生效"
Write-Info "2. 配置Claude Code CLI:"
Write-Info "   claude auth login"
Write-Info ""
Write-Info "3. 配置GitHub CLI:"
Write-Info "   gh auth login"
Write-Info ""
Write-Info "4. 安装Visual Studio工作负载（如需要）"
Write-Info ""
Write-Info "5. 配置IDE和编辑器"
Write-Info ""

Write-Warning "⚠️  某些应用可能需要重启计算机才能完成安装"
Write-Info ""
Write-Info "按任意键退出..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
