<#
.SYNOPSIS
  Upload trade goods card PNGs to the VPS external image tree (Pageant + PuTTY PSCP).

.DESCRIPTION
  Uses **Pageant** + **pscp/plink** with **-load "server vps"** and login **root** (`-l root`).

  Aligns with docs/module-protocols/PROTOCOL_MASTER.md + docker-compose.plesk.yml:
  backend mounts CLIENT_EXTERNAL_IMAGES_PATH (default under the project) at /client/images.
  Trade thumbnails must live under: .../runtime/client-images/trade_goods/cards/

  Requires: PuTTY PSCP/plink, **Pageant** with key loaded, saved session **server vps** (override with -PuttySession).

.PARAMETER PuttySession
  Exact PuTTY saved session name.

.PARAMETER RemoteBase
  Directory on the server that corresponds to CLIENT_EXTERNAL_IMAGES_PATH (no trailing slash).

.PARAMETER ProjectRoot
  Local repo root; defaults to parent of this script's folder.

.PARAMETER PscpBatch
  If set, passes **-batch** to **plink** and **pscp** (non-interactive; fails on unknown host key). Use for CI/automation after the host key is trusted once in PuTTY.

.EXAMPLE
  .\scripts\upload_trade_goods_images_to_vps.ps1 -PuttySession "server vps"
.EXAMPLE
  .\scripts\upload_trade_goods_images_to_vps.ps1 -PuttySession "server vps" -PscpBatch
#>
param(
    [Parameter(Mandatory = $false)]
    [string] $PuttySession = "server vps",

    [Parameter(Mandatory = $false)]
    [string] $SshUser = "root",

    [Parameter(Mandatory = $false)]
    [string] $SshHost = "",

    [Parameter(Mandatory = $false)]
    [string] $RemoteBase = "/var/www/vhosts/themobstate.com/apps/mafia_game/runtime/client-images",

    [Parameter(Mandatory = $false)]
    [string] $ProjectRoot = "",

    [Parameter(Mandatory = $false)]
    [switch] $PscpBatch
)

$scriptDir = if (-not [string]::IsNullOrWhiteSpace($PSScriptRoot)) {
    $PSScriptRoot
} else {
    Split-Path -Parent $MyInvocation.MyCommand.Path
}
if ([string]::IsNullOrWhiteSpace($ProjectRoot)) {
    $ProjectRoot = (Resolve-Path (Join-Path $scriptDir "..")).Path
}

function Get-PuTTYSessionHostName {
    param([string] $SessionName)
    $encoded = $SessionName -replace " ", "%20"
    $regPath = "HKCU:\Software\SimonTatham\PuTTY\Sessions\$encoded"
    if (-not (Test-Path -LiteralPath $regPath)) {
        return $null
    }
    return (Get-ItemProperty -LiteralPath $regPath -ErrorAction SilentlyContinue).HostName
}

$ErrorActionPreference = "Stop"

$pscp = Join-Path ${env:ProgramFiles} "PuTTY\pscp.exe"
$plink = Join-Path ${env:ProgramFiles} "PuTTY\plink.exe"
if (-not (Test-Path $pscp)) {
    throw "PSCP not found at $pscp. Install PuTTY or adjust path."
}
if (-not (Test-Path $plink)) {
    throw "PLINK not found at $plink. Install PuTTY or adjust path."
}

$hostName = $SshHost
if ([string]::IsNullOrWhiteSpace($hostName)) {
    $hostName = Get-PuTTYSessionHostName -SessionName $PuttySession
}
if ([string]::IsNullOrWhiteSpace($hostName)) {
    throw "Could not resolve SSH host. Save the session in PuTTY first, or pass -SshHost."
}
$sshTarget = "${SshUser}@${hostName}"

$cards = Join-Path $ProjectRoot "runtime\client-images\trade_goods\cards"

if (-not (Test-Path $cards)) {
    throw "Local folder missing: $cards. Run: python backend/scripts/generate_trade_goods_card_images_leonardo.py"
}

$cardPng = @(Get-ChildItem -Path $cards -Filter "*.png" -File -ErrorAction SilentlyContinue)
if ($cardPng.Count -eq 0) {
    throw "No PNG files under trade_goods/cards. Generate images first (Leonardo script in backend/scripts)."
}

$remoteCards = "${sshTarget}:$RemoteBase/trade_goods/cards/"

Write-Host "Auth: Pageant. PuTTY: -load `"$PuttySession`" -l $SshUser"
Write-Host "SSH target: $sshTarget"
Write-Host "Remote base: $RemoteBase"
Write-Host "Uploading $($cardPng.Count) trade good card(s)..."

$mkdirCmd = "mkdir -p $RemoteBase/trade_goods/cards && chmod -R a+rX $RemoteBase/trade_goods"
$plinkArgs = @("-load", $PuttySession, $sshTarget, $mkdirCmd)
if ($PscpBatch) {
    $plinkArgs = @("-batch") + $plinkArgs
}
& $plink @plinkArgs

$pscpArgs = @("-l", $SshUser, "-load", $PuttySession)
if ($PscpBatch) {
    $pscpArgs = @("-batch") + $pscpArgs
}
& $pscp @pscpArgs (Join-Path $cards "*.png") $remoteCards

Write-Host "Done. Verify on the server:"
Write-Host "  ls -la $RemoteBase/trade_goods/cards/"
