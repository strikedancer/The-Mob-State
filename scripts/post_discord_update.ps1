<#
.SYNOPSIS
  Post a player-facing changelog to Discord #updates (visible text + embed).

.DESCRIPTION
  Reads DISCORD_UPDATES_WEBHOOK_URL from the environment or local .env.plesk.
  Never prints the webhook URL. Skip Crew Wars / staff channels — this is #updates only.

  Discord must get a real paragraph in `content` plus bullets in the embed.
  Title-only posts are rejected.

.PARAMETER Title
  Short embed title (Dutch). The title is a headline, not the update.

.PARAMETER Intro
  Required player-facing Dutch paragraph: what changed, why it matters, what to do.
  Minimum 180 characters.

.PARAMETER Bullets
  4–8 full sentences (without leading dashes). Each line is concrete, no jargon.

.PARAMETER Url
  Optional link on the embed (default https://themobstate.com).

.EXAMPLE
  .\scripts\post_discord_update.ps1 -Title "Territorium" -Intro "Lange uitleg..." -Bullets @("Eerste volle zin.","Tweede volle zin.","Derde volle zin.","Vierde volle zin.")
#>
param(
    [Parameter(Mandatory = $true)]
    [string] $Title,

    [Parameter(Mandatory = $true)]
    [string] $Intro,

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
if ($cleanTitle.Length -lt 8 -or $cleanTitle.Length -gt 120) {
    Write-Error "Title must be 8-120 characters and cannot be the whole update."
    exit 1
}

$introText = $Intro.Trim()
if ($introText.Length -lt 180 -or $introText.Length -gt 1500) {
    Write-Error "Intro is required: 180-1500 characters of player-facing Dutch. Do not post a title-only update."
    exit 1
}

$lines = @()
foreach ($item in $Bullets) {
    $text = ([string]$item).Trim()
    if ($text.Length -eq 0) { continue }
    if ($text.Length -lt 24) {
        Write-Error "Each bullet must be a full sentence (at least 24 characters): $text"
        exit 1
    }
    if ($text.StartsWith("- ")) {
        $text = $text.Substring(2).Trim()
    }
    $lines += "- $text"
}
if ($lines.Count -lt 4 -or $lines.Count -gt 8) {
    Write-Error "Provide 4-8 non-empty bullets (full sentences)."
    exit 1
}

$description = $lines -join "`n"
if ($description.Length -gt 3500) {
    Write-Error "Bullet text is too long."
    exit 1
}

if ($introText.Length -gt 1900) {
    Write-Error "Intro exceeds Discord content limit."
    exit 1
}

$embed = @{
    title       = $cleanTitle
    description = $description
    url         = $Url
    color       = 13938487
    footer      = @{ text = "themobstate.com" }
}
$payloadObject = @{
    username = "The Mob State"
    content  = $introText
    embeds   = @($embed)
}

$json = $payloadObject | ConvertTo-Json -Depth 8 -Compress
$utf8NoBom = New-Object System.Text.UTF8Encoding $false
$bodyBytes = $utf8NoBom.GetBytes($json)

$uri = $webhook
if ($uri -notmatch '[?&]wait=') {
    if ($uri.Contains('?')) { $uri += '&wait=true' } else { $uri += '?wait=true' }
}

try {
    $response = Invoke-WebRequest -Method Post -Uri $uri -ContentType "application/json; charset=utf-8" -Body $bodyBytes -UseBasicParsing
} catch {
    Write-Error "Discord webhook post failed (URL not printed)."
    exit 1
}

$posted = $response.Content | ConvertFrom-Json
$contentLen = ([string]$posted.content).Length
$descLen = 0
$embedList = @($posted.embeds)
if ($embedList.Count -gt 0) {
    $descLen = ([string]$embedList[0].description).Length
}

if ($contentLen -lt 180 -or $descLen -lt 80) {
    Write-Error ("Discord accepted the post but the body is too short (content={0}, embed={1}). Do not treat this as a successful player update." -f $contentLen, $descLen)
    exit 1
}

Write-Output ("Posted changelog to Discord #updates (content {0} chars, embed {1} chars)." -f $contentLen, $descLen)
