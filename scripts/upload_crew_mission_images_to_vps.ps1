<#
.SYNOPSIS
  Upload crew mission card/scene PNGs to the VPS external image tree (Pageant + PuTTY PSCP).

.DESCRIPTION
  Aligns with docs/module-protocols/PROTOCOL_MASTER.md + docker-compose.plesk.yml:
  backend mounts CLIENT_EXTERNAL_IMAGES_PATH (default under the project) at /client/images.
  Crew mission files must live under: .../runtime/client-images/crew_missions/cards|scenes/

  Requires: PuTTY PSCP, Pageant with loaded key, a saved PuTTY session that reaches the VPS.

  Note: On this machine the saved session is often named "server vps" (not "vps server").
  Override with -PuttySession.

.PARAMETER PuttySession
  Exact PuTTY saved session name (Connection > Data > Saved Sessions).

.PARAMETER RemoteBase
  Directory on the server that corresponds to CLIENT_EXTERNAL_IMAGES_PATH (no trailing slash).

.PARAMETER ProjectRoot
  Local repo root; defaults to parent of this script's folder.

.PARAMETER SshHost
  Optional hostname or IP. If empty, HostName is read from the PuTTY session registry entry.

.EXAMPLE
  .\scripts\upload_crew_mission_images_to_vps.ps1 -PuttySession "server vps"
.EXAMPLE
  .\scripts\upload_crew_mission_images_to_vps.ps1 -PuttySession "vps server" -SshHost "203.0.113.10"
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
    [string] $ProjectRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
)

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

$cards = Join-Path $ProjectRoot "runtime\client-images\crew_missions\cards"
$scenes = Join-Path $ProjectRoot "runtime\client-images\crew_missions\scenes"

if (-not (Test-Path $cards) -or -not (Test-Path $scenes)) {
    throw "Local folders missing. Create them or run: python backend/scripts/generate_crew_missions_images_leonardo.py --confirm-batch YES"
}

$cardPng = @(Get-ChildItem -Path $cards -Filter "*.png" -File -ErrorAction SilentlyContinue)
$scenePng = @(Get-ChildItem -Path $scenes -Filter "*.png" -File -ErrorAction SilentlyContinue)
if ($cardPng.Count -eq 0 -or $scenePng.Count -eq 0) {
    throw "No PNG files under crew_missions/cards or scenes. Generate images first (Leonardo script in backend/scripts)."
}

$remoteCards = "${sshTarget}:$RemoteBase/crew_missions/cards/"
$remoteScenes = "${sshTarget}:$RemoteBase/crew_missions/scenes/"

Write-Host "Using PuTTY session: $PuttySession (proxy/key/Pageant from session)"
Write-Host "SSH target: $sshTarget"
Write-Host "Remote base: $RemoteBase"
Write-Host "Uploading $($cardPng.Count) card(s) and $($scenePng.Count) scene(s)..."

# Ensure target dirs exist (PROTOCOL_MASTER external image tree)
$mkdirCmd = "mkdir -p $RemoteBase/crew_missions/cards $RemoteBase/crew_missions/scenes && chmod -R a+rX $RemoteBase/crew_missions"
& $plink -batch -load $PuttySession "$sshTarget" $mkdirCmd

# PSCP: -load applies proxy, keys, port from saved session; destination is user@host:path
& $pscp -batch -load $PuttySession (Join-Path $cards "*.png") $remoteCards
& $pscp -batch -load $PuttySession (Join-Path $scenes "*.png") $remoteScenes

Write-Host "Done. Verify on the server:"
Write-Host "  ls -la $RemoteBase/crew_missions/cards/"
Write-Host "  ls -la $RemoteBase/crew_missions/scenes/"
