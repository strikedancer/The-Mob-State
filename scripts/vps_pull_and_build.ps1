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
git pull origin main
# Keep external image library in sync for vault banner (served via /client/images).
mkdir -p runtime/client-images/vault || true
cp -f client/assets/images/vault/vault_banner.png runtime/client-images/vault/vault_banner.png || true
docker compose --env-file .env.plesk -f docker-compose.plesk.yml config
docker compose --env-file .env.plesk -f docker-compose.plesk.yml up -d --build --no-deps backend
docker compose --env-file .env.plesk -f docker-compose.plesk.yml up -d --build --no-deps client
docker compose --env-file .env.plesk -f docker-compose.plesk.yml logs --tail=120 backend
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
