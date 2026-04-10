# GitHub推送脚本 - 在Windows PowerShell中运行
# 用法: .\scripts\push-to-github.ps1

Write-Host "╔══════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║          🚀 推送到GitHub                                     ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# 切换到仓库目录
$repoPath = "D:\code\other\claude-dev-toolbox"
if (Test-Path $repoPath) {
    Set-Location $repoPath
    Write-Host "✅ 已切换到仓库目录: $repoPath" -ForegroundColor Green
} else {
    Write-Host "❌ 仓库目录不存在: $repoPath" -ForegroundColor Red
    Write-Host "请修改脚本中的repoPath变量为正确的路径" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "📋 推送选项:" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. 使用GitHub CLI (推荐 - 如果已登录)" -ForegroundColor White
Write-Host "2. 使用HTTPS (需要Personal Access Token)" -ForegroundColor White
Write-Host "3. 使用SSH (需要配置SSH密钥)" -ForegroundColor White
Write-Host ""

$choice = Read-Host "请选择 (1/2/3)"

switch ($choice) {
    "1" {
        Write-Host ""
        Write-Host "🔍 检查GitHub CLI..." -ForegroundColor Cyan

        if (Get-Command gh -ErrorAction SilentlyContinue) {
            $authStatus = gh auth status 2>&1
            if ($LASTEXITCODE -eq 0) {
                Write-Host "✅ GitHub CLI已登录" -ForegroundColor Green
                Write-Host ""
                Write-Host "📤 推送到GitHub..." -ForegroundColor Cyan

                gh repo set-default rj-xiejiawei/claude-dev-toolbox
                git push -u origin main

                if ($LASTEXITCODE -eq 0) {
                    Write-Host ""
                    Write-Host "✅ 推送成功!" -ForegroundColor Green
                    Write-Host ""
                    Write-Host "🔗 仓库地址: https://github.com/rj-xiejiawei/claude-dev-toolbox" -ForegroundColor Cyan
                } else {
                    Write-Host ""
                    Write-Host "❌ 推送失败" -ForegroundColor Red
                }
            } else {
                Write-Host "⚠️  GitHub CLI未登录" -ForegroundColor Yellow
                Write-Host ""
                Write-Host "请先登录: gh auth login" -ForegroundColor Cyan
            }
        } else {
            Write-Host "❌ GitHub CLI未安装" -ForegroundColor Red
            Write-Host ""
            Write-Host "安装命令: winget install GitHub.cli" -ForegroundColor Cyan
        }
    }

    "2" {
        Write-Host ""
        Write-Host "📝 HTTPS推送需要GitHub Personal Access Token" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "1. 访问: https://github.com/settings/tokens" -ForegroundColor White
        Write-Host "2. 点击: Generate new token (classic)" -ForegroundColor White
        Write-Host "3. 勾选: repo (完整仓库访问权限)" -ForegroundColor White
        Write-Host "4. 生成并复制token" -ForegroundColor White
        Write-Host ""

        $token = Read-Host "请粘贴你的Personal Access Token (输入时会隐藏)"

        if ($token) {
            Write-Host ""
            Write-Host "📤 推送到GitHub..." -ForegroundColor Cyan

            # 使用token推送
            git remote set-url origin "https://rj-xiejiawei:${token}@github.com/rj-xiejiawei/claude-dev-toolbox.git"
            git push -u origin main

            # 恢复原始URL（不包含token）
            git remote set-url origin "https://github.com/rj-xiejiawei/claude-dev-toolbox.git"

            if ($LASTEXITCODE -eq 0) {
                Write-Host ""
                Write-Host "✅ 推送成功!" -ForegroundColor Green
                Write-Host ""
                Write-Host "🔗 仓库地址: https://github.com/rj-xiejiawei/claude-dev-toolbox" -ForegroundColor Cyan
            } else {
                Write-Host ""
                Write-Host "❌ 推送失败，请检查token是否正确" -ForegroundColor Red
            }
        }
    }

    "3" {
        Write-Host ""
        Write-Host "🔑 SSH推送需要配置SSH密钥" -ForegroundColor Yellow
        Write-Host ""

        # 检查SSH密钥
        $sshKeyPath = "$env:USERPROFILE\.ssh\id_ed25519.pub"
        if (Test-Path $sshKeyPath) {
            Write-Host "✅ 找到SSH公钥: $sshKeyPath" -ForegroundColor Green
            Write-Host ""
            Write-Host "公钥内容:" -ForegroundColor Cyan
            Get-Content $sshKeyPath
            Write-Host ""
            Write-Host "请将上述公钥添加到: https://github.com/settings/keys" -ForegroundColor Yellow
            Write-Host ""

            $continue = Read-Host "已添加公钥? (y/n)"
            if ($continue -eq 'y') {
                Write-Host ""
                Write-Host "📤 推送到GitHub..." -ForegroundColor Cyan

                # 切换到SSH URL
                git remote set-url origin git@github.com:rj-xiejiawei/claude-dev-toolbox.git
                git push -u origin main

                # 恢复HTTPS URL
                git remote set-url origin https://github.com/rj-xiejiawei/claude-dev-toolbox.git

                if ($LASTEXITCODE -eq 0) {
                    Write-Host ""
                    Write-Host "✅ 推送成功!" -ForegroundColor Green
                    Write-Host ""
                    Write-Host "🔗 仓库地址: https://github.com/rj-xiejiawei/claude-dev-toolbox" -ForegroundColor Cyan
                } else {
                    Write-Host ""
                    Write-Host "❌ 推送失败，请检查SSH密钥配置" -ForegroundColor Red
                }
            }
        } else {
            Write-Host "❌ 未找到SSH密钥" -ForegroundColor Red
            Write-Host ""
            Write-Host "生成SSH密钥:" -ForegroundColor Cyan
            Write-Host "ssh-keygen -t ed25519 -C `"your_email@example.com`"" -ForegroundColor White
        }
    }

    default {
        Write-Host "❌ 无效选择" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "按任意键退出..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
