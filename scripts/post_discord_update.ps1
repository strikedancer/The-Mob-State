<#
.SYNOPSIS
  Post a player-facing changelog embed to Discord #updates.

.DESCRIPTION
  Reads DISCORD_UPDATES_WEBHOOK_URL from the environment or local .env.plesk.
  Never prints the webhook URL. Skip Crew Wars / staff channels — this is #updates only.

.PARAMETER Title
  Embed title (short, Dutch for live players).

.PARAMETER Bullets
  1–6 changelog lines (without leading bullets).

.PARAMETER Url
  Optional link on the embed (default https://themobstate.com).

.EXAMPLE
  .\scripts\post_discord_update.ps1 -Title "HUD en handel" -Bullets @("Credits staan in de HUD","Koop-500 crash opgelost")
#>
param(
    [Parameter(Mandatory = $true)]
    [string] $Title,

    [Parameter(Mandatory = $true)]
    [string[]] $Bullets,

    [string] $Url = "https://themobstate.com"
)

$ErrorActionPreference = "Stop"

function Get-UpdatesWebhook {
    $fromEnv = [string]$env:DISCORD_UPDATES_WEBHOOK_URL
    if (-not [string]::IsNullOrWhiteSpace($fromEnv)) {
        return $fromEnv.Trim()
    }
    $envFile = Join-Path (Split-Path -Parent $PSScriptRoot) ".env.plesk"
    if (-not (Test-Path -LiteralPath $envFile)) {
        return $null
    }
    foreach ($line in Get-Content -LiteralPath $envFile) {
        if ($line -match '^\s*DISCORD_UPDATES_WEBHOOK_URL\s*=\s*(.*)$') {
            return $Matches[1].Trim().Trim('"').Trim("'")
        }
    }
    return $null
}

$webhook = Get-UpdatesWebhook
if ([string]::IsNullOrWhiteSpace($webhook) -or $webhook -notmatch '^https://discord(?:app)?\.com/api/webhooks/') {
    Write-Error "DISCORD_UPDATES_WEBHOOK_URL is missing or not a Discord webhook. Set it in the environment or .env.plesk."
    exit 1
}

$cleanTitle = $Title.Trim()
if ($cleanTitle.Length -lt 1 -or $cleanTitle.Length -gt 120) {
    Write-Error "Title must be 1–120 characters."
    exit 1
}

$lines = @()
foreach ($item in $Bullets) {
    $text = ([string]$item).Trim()
    if ($text.Length -eq 0) { continue }
    $lines += "• $text"
}
if ($lines.Count -lt 1 -or $lines.Count -gt 6) {
    Write-Error "Provide 1–6 non-empty bullets."
    exit 1
}

$description = ($lines -join "`n")
if ($description.Length -gt 1800) {
    Write-Error "Changelog text is too long."
    exit 1
}

function Escape-JsonString([string] $value) {
    return $value.
        Replace('\', '\\').
        Replace('"', '\"').
        Replace("`r", '').
        Replace("`n", '\n')
}

$payload = '{"username":"The Mob State","embeds":[{"title":"' +
    (Escape-JsonString $cleanTitle) +
    '","description":"' +
    (Escape-JsonString $description) +
    '","url":"' +
    (Escape-JsonString $Url) +
    '","color":13938487}]}'

try {
    Invoke-RestMethod -Method Post -Uri $webhook -ContentType "application/json; charset=utf-8" -Body ([System.Text.Encoding]::UTF8.GetBytes($payload)) | Out-Null
} catch {
    Write-Error "Discord webhook post failed (URL not printed)."
    exit 1
}

Write-Output "Posted changelog to Discord #updates."
