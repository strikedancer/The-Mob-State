<#
.SYNOPSIS
  On the VPS: git pull, docker compose config, rebuild backend + client (PROTOCOL_MASTER PuTTY/Plesk flow).

.DESCRIPTION
  Uses **Pageant** (SSH agent) + **PuTTY plink** with **-load "server vps"** and login **root** (`-l root`).
  Connection details (proxy, port, private key file pointer) come from that saved session.

  Matches docs/module-protocols/PROTOCOL_MASTER.md: backup hint, pull, config validate, targeted rebuild, logs.

  Run this in a normal PowerShell window on your PC (not necessarily from Cursor), with **Pageant** running and your key loaded.

.PARAMETER PuttySession
  Saved PuTTY session name (exact). Default: **server vps**.

.PARAMETER SshUser
  SSH login name. Default: **root** (explicit `-l` on plink).

.PARAMETER SshHost
  If empty, HostName is read from the PuTTY session registry entry.

.PARAMETER ProjectDir
  Remote path to the git repo on the VPS (PROTOCOL_MASTER example).

.EXAMPLE
  .\scripts\vps_pull_and_build.ps1 -PuttySession "server vps"
.EXAMPLE
  .\scripts\vps_pull_and_build.ps1 -PuttySession "vps server" -SshHost "203.0.113.10"
#>
param(
    [string] $PuttySession = "server vps",
    [string] $SshUser = "root",
    [string] $SshHost = "",
    [string] $ProjectDir = "/var/www/vhosts/themobstate.com/apps/mafia_game"
)

$ErrorActionPreference = "Stop"

function Get-PuTTYSessionHostName {
    param([string] $SessionName)
    $encoded = $SessionName -replace " ", "%20"
    $regPath = "HKCU:\Software\SimonTatham\PuTTY\Sessions\$encoded"
    if (-not (Test-Path -LiteralPath $regPath)) { return $null }
    (Get-ItemProperty -LiteralPath $regPath -ErrorAction SilentlyContinue).HostName
}

$plink = Join-Path ${env:ProgramFiles} "PuTTY\plink.exe"
if (-not (Test-Path $plink)) { throw "plink.exe not found at $plink" }

$hostName = $SshHost
if ([string]::IsNullOrWhiteSpace($hostName)) {
    $hostName = Get-PuTTYSessionHostName -SessionName $PuttySession
}
if ([string]::IsNullOrWhiteSpace($hostName)) {
    throw "Set -SshHost or fix PuTTY session name so HostName exists in registry."
}
$sshTarget = "${SshUser}@${hostName}"

$dirUnix = ($ProjectDir -replace "\\", "/").TrimEnd("/")
# Single-quoted template so bash $(date ...) is not expanded by PowerShell
$remoteScript = @'
#!/bin/bash
set -e
cd REMOTE_PROJECT_DIR
cp docker-compose.plesk.yml docker-compose.plesk.yml.bak-$(date +%F-%H%M) || true
test -f .env.plesk && cp .env.plesk .env.plesk.bak-$(date +%F-%H%M) || true
# Tracked PNGs under runtime/ can conflict with old untracked copies on the server.
git clean -fd -- runtime/client-images/crew_missions/cards/ runtime/client-images/crew_missions/scenes/ runtime/client-images/avatars/ 2>/dev/null || true
git pull origin main
# Keep external image library in sync (nginx /images/* → runtime/client-images).
mkdir -p runtime/client-images/vault runtime/client-images/avatars || true
cp -f client/assets/images/vault/vault_banner.png runtime/client-images/vault/vault_banner.png || true
# All avatar PNGs for /images/avatars/* (settings grid + nginx external mount); keep in sync with client/assets/images/avatars/
cp -f client/assets/images/avatars/*.png runtime/client-images/avatars/ 2>/dev/null || true
# Trade screen thumbnails (/images/trade_goods/cards/*); keep in sync with client/assets/images/trade_goods/cards/
mkdir -p runtime/client-images/trade_goods/cards || true
cp -f client/assets/images/trade_goods/cards/*.png runtime/client-images/trade_goods/cards/ 2>/dev/null || true
# 8G host + Plesk + MariaDB. Uncapped `flutter build web` has frozen this VPS
# (MariaDB crash recovery, SSH/HTTPS timeout). Keep a 4G swapfile and cap builds.
if [ ! -f /swapfile ]; then
  fallocate -l 4G /swapfile || dd if=/dev/zero of=/swapfile bs=1M count=4096
  chmod 600 /swapfile
  mkswap /swapfile
  swapon /swapfile
  grep -q "/swapfile" /etc/fstab || echo "/swapfile none swap sw 0 0" >> /etc/fstab
else
  swapon /swapfile 2>/dev/null || true
fi
sysctl -w vm.swappiness=10 >/dev/null
grep -q "^vm.swappiness" /etc/sysctl.conf || echo "vm.swappiness=10" >> /etc/sysctl.conf

dc() { docker compose --env-file .env.plesk -f docker-compose.plesk.yml "$@"; }
export COMPOSE_PARALLEL_LIMIT=1
dc config
dc build --memory 2560m backend
# If a prior deploy left 20260414223000_expand_support_workflow in failed state (P3018), clear it so idempotent SQL can re-apply. No-op when not failed.
dc run --rm backend npx prisma migrate resolve --rolled-back "20260414223000_expand_support_workflow" || true
dc run --rm backend npx prisma migrate resolve --rolled-back "20260415061500_expand_player_security" || true
dc run --rm backend npx prisma migrate resolve --rolled-back "20260426120000_add_push_game_events_preference" || true
dc run --rm backend npx prisma migrate resolve --rolled-back "20260426183000_garage_upgrade_track" || true
dc run --rm backend npx prisma migrate resolve --rolled-back "20260427094500_vault_monthly_season" || true
dc run --rm backend npx prisma migrate resolve --rolled-back "20260502120000_add_player_gender" || true
dc run --rm backend npx prisma migrate resolve --rolled-back "20260802140000_player_market_stack_lots" || true
dc run --rm backend npx prisma migrate resolve --rolled-back "20260802160000_player_event_items" || true
dc run --rm backend npx prisma migrate deploy
dc up -d --no-build --no-deps backend
dc build --memory 3g client
dc up -d --no-build --no-deps client
dc build --memory 1536m admin
dc up -d --no-build --no-deps admin
dc logs --tail=120 backend
'@.Replace("REMOTE_PROJECT_DIR", $dirUnix)

$tmp = [System.IO.Path]::GetTempFileName() + ".sh"
try {
    $utf8NoBom = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::WriteAllText($tmp, $remoteScript, $utf8NoBom)
    Write-Host "Auth: Pageant (agent). PuTTY: -load `"$PuttySession`" -l $SshUser"
    Write-Host "Remote: $sshTarget"
    Write-Host "Project: $ProjectDir"
    Write-Host "(No -batch: proxy or PuTTY prompts can be answered in this window.)"
    Write-Host "---"
    # -m: local file whose lines are executed on the remote shell (bash)
    # -no-antispoof: skip post-auth banner prompt that breaks automation
    # -l: login root (session may have empty Auto-login name)
    & $plink -l $SshUser -no-antispoof -t -load $PuttySession -m $tmp $sshTarget
} finally {
    Remove-Item -LiteralPath $tmp -Force -ErrorAction SilentlyContinue
}
