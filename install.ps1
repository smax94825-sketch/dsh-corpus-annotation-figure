#!/usr/bin/env pwsh
# install.ps1 —— 把两个技能装到 DSH 全局技能目录
#
#   .\install.ps1                     # 装到 %USERPROFILE%\.dsh\skills
#   .\install.ps1 -Target "D:\skills" # 自定义目录
#   .\install.ps1 -Force              # 覆盖已存在的同名技能
param(
    [string]$Target = (Join-Path $env:USERPROFILE ".dsh\skills"),
    [switch]$Force
)

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$skills = Join-Path $root "skills"

if (-not (Test-Path $skills)) { throw "找不到 skills 目录：$skills" }
if (-not (Test-Path $Target)) {
    New-Item -ItemType Directory -Force -Path $Target | Out-Null
    Write-Host "创建技能目录：$Target"
}

foreach ($name in @("corpus-annotation-figure", "academic-figure")) {
    $src = Join-Path $skills $name
    $dst = Join-Path $Target $name
    if ((Test-Path $dst) -and -not $Force) {
        Write-Warning "已存在，跳过：$dst （加 -Force 覆盖）"
        continue
    }
    if (Test-Path $dst) { Remove-Item $dst -Recurse -Force }
    Copy-Item $src $dst -Recurse
    Get-ChildItem $dst -Recurse -Directory -Filter "__pycache__" |
        Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "已安装：$dst"
}

Write-Host "`n完成。可对助手说：'画一张 NER 和依存句法的标注示例图'。"
