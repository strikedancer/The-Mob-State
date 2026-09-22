<#
.SYNOPSIS
  Post a player-facing changelog to Discord #updates (NL + EN) and optionally to in-game world chat.

.DESCRIPTION
  Reads DISCORD_UPDATES_WEBHOOK_URL from the environment or local .env.plesk.
  Never prints the webhook URL. Skip Crew Wars / staff channels — this is #updates only.

  Discord gets Dutch + English: content has both intros; two embeds (NL then EN) with bullets.
  After Discord succeeds, posts a short NL+EN teaser to in-game world chat via VPS (plink),
  unless -SkipWorldChat is set.

.PARAMETER Title
  Short Dutch embed title (headline only).

.PARAMETER TitleEn
  Short English embed title.

.PARAMETER Intro
  Required Dutch paragraph (180–900 chars): what changed, why it matters, what to do.

.PARAMETER IntroEn
  Required English paragraph (180–900 chars), same content as Intro.

.PARAMETER Bullets
  4–8 full Dutch sentences (without leading dashes).

.PARAMETER BulletsEn
  4–8 full English sentences matching Bullets.

.PARAMETER WorldChatNl
  Short Dutch world-chat teaser (40–280 chars). Required unless -SkipWorldChat.

.PARAMETER WorldChatEn
  Short English world-chat teaser (40–280 chars). Required unless -SkipWorldChat.

.PARAMETER Url
  Optional link on the embeds (default https://themobstate.com).

.PARAMETER SkipWorldChat
  Only post Discord #updates (no in-game world chat).

.PARAMETER PuttySession
  Saved PuTTY session for world-chat post (default: server vps).

.PARAMETER ProjectDir
  Remote git repo path on the VPS.

.EXAMPLE
  .\scripts\post_discord_update.ps1 `
    -Title "Cel en drugs" `
    -TitleEn "Jail and drugs" `
    -Intro "Lange NL uitleg..." `
    -IntroEn "Long EN explanation..." `
    -Bullets @("Zin 1.","Zin 2.","Zin 3.","Zin 4.") `
    -BulletsEn @("Sentence 1.","Sentence 2.","Sentence 3.","Sentence 4.") `
    -WorldChatNl "Update: in de cel kun je geen drugs meer starten of ophalen. Meer info in Discord #updates." `
    -WorldChatEn "Update: while jailed you can no longer start or collect drugs. Details in Discord #updates."
#>
param(
    [Parameter(Mandatory = $true)]
    [string] $Title,

    [Parameter(Mandatory = $true)]
    [string] $TitleEn,

    [Parameter(Mandatory = $true)]
    [string] $Intro,

    [Parameter(Mandatory = $true)]
    [string] $IntroEn,

    [Parameter(Mandatory = $true)]
    [string[]] $Bullets,

    [Parameter(Mandatory = $true)]
    [string[]] $BulletsEn,

    [string] $WorldChatNl = "",

    [string] $WorldChatEn = "",

    [string] $Url = "https://themobstate.com",

    [switch] $SkipWorldChat,

    [string] $PuttySession = "server vps",

    [string] $SshUser = "root",

    [string] $SshHost = "",

    [string] $ProjectDir = "/var/www/vhosts/themobstate.com/apps/mafia_game"
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

function Format-BulletLines {
    param(
        [string[]] $Items,
        [string] $LangLabel
    )
    $lines = @()
    foreach ($item in $Items) {
        $text = ([string]$item).Trim()
        if ($text.Length -eq 0) { continue }
        if ($text.Length -lt 24) {
            Write-Error ("Each {0} bullet must be a full sentence (at least 24 characters): {1}" -f $LangLabel, $text)
            exit 1
        }
        if ($text.StartsWith("- ")) {
            $text = $text.Substring(2).Trim()
        }
        $lines += "- $text"
    }
    if ($lines.Count -lt 4 -or $lines.Count -gt 8) {
        Write-Error ("Provide 4-8 non-empty {0} bullets (full sentences)." -f $LangLabel)
        exit 1
    }
    $description = $lines -join "`n"
    if ($description.Length -gt 3500) {
        Write-Error ("{0} bullet text is too long." -f $LangLabel)
        exit 1
    }
    return $description
}

function Get-PuTTYSessionHostName {
    param([string] $SessionName)
    $encoded = $SessionName -replace " ", "%20"
    $regPath = "HKCU:\Software\SimonTatham\PuTTY\Sessions\$encoded"
    if (-not (Test-Path -LiteralPath $regPath)) { return $null }
    (Get-ItemProperty -LiteralPath $regPath -ErrorAction SilentlyContinue).HostName
}

function Assert-Title {
    param([string] $Value, [string] $Label)
    $clean = $Value.Trim()
    if ($clean.Length -lt 8 -or $clean.Length -gt 120) {
        Write-Error ("{0} must be 8-120 characters and cannot be the whole update." -f $Label)
        exit 1
    }
    return $clean
}

function Assert-Intro {
    param([string] $Value, [string] $Label)
    $text = $Value.Trim()
    if ($text.Length -lt 180 -or $text.Length -gt 900) {
        Write-Error ("{0} is required: 180-900 characters of player-facing text. Do not post a title-only update." -f $Label)
        exit 1
    }
    return $text
}

$webhook = Get-UpdatesWebhook
if ([string]::IsNullOrWhiteSpace($webhook) -or $webhook -notmatch '^https://discord(?:app)?\.com/api/webhooks/') {
    Write-Error "DISCORD_UPDATES_WEBHOOK_URL is missing or not a Discord webhook. Set it in the environment or .env.plesk."
    exit 1
}

$cleanTitleNl = Assert-Title -Value $Title -Label "Title (NL)"
$cleanTitleEn = Assert-Title -Value $TitleEn -Label "TitleEn"
$introNl = Assert-Intro -Value $Intro -Label "Intro (NL)"
$introEn = Assert-Intro -Value $IntroEn -Label "IntroEn"
$descNl = Format-BulletLines -Items $Bullets -LangLabel "NL"
$descEn = Format-BulletLines -Items $BulletsEn -LangLabel "EN"

if (-not $SkipWorldChat) {
    $wcNl = $WorldChatNl.Trim()
    $wcEn = $WorldChatEn.Trim()
    if ($wcNl.Length -lt 40 -or $wcNl.Length -gt 280) {
        Write-Error "WorldChatNl is required (40-280 chars) unless -SkipWorldChat."
        exit 1
    }
    if ($wcEn.Length -lt 40 -or $wcEn.Length -gt 280) {
        Write-Error "WorldChatEn is required (40-280 chars) unless -SkipWorldChat."
        exit 1
    }
}

$contentText = ("NL`n{0}`n`nEN`n{1}" -f $introNl, $introEn)
if ($contentText.Length -gt 1900) {
    Write-Error "Combined NL+EN intro exceeds Discord content limit (1900)."
    exit 1
}

$embedNl = @{
    title       = ("NL · {0}" -f $cleanTitleNl)
    description = $descNl
    url         = $Url
    color       = 13938487
    footer      = @{ text = "themobstate.com · NL" }
}
$embedEn = @{
    title       = ("EN · {0}" -f $cleanTitleEn)
    description = $descEn
    url         = $Url
    color       = 5793266
    footer      = @{ text = "themobstate.com · EN" }
}
$payloadObject = @{
    username = "The Mob State"
    content  = $contentText
    embeds   = @($embedNl, $embedEn)
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
$descLenNl = 0
$descLenEn = 0
$embedList = @($posted.embeds)
if ($embedList.Count -ge 1) {
    $descLenNl = ([string]$embedList[0].description).Length
}
if ($embedList.Count -ge 2) {
    $descLenEn = ([string]$embedList[1].description).Length
}

if ($contentLen -lt 360 -or $descLenNl -lt 80 -or $descLenEn -lt 80 -or $embedList.Count -lt 2) {
    Write-Error ("Discord accepted the post but bilingual body is too short (content={0}, embedNl={1}, embedEn={2}, embeds={3}). Do not treat this as a successful player update." -f $contentLen, $descLenNl, $descLenEn, $embedList.Count)
    exit 1
}

Write-Output ("Posted bilingual changelog to Discord #updates (content {0} chars, NL embed {1}, EN embed {2})." -f $contentLen, $descLenNl, $descLenEn)

if ($SkipWorldChat) {
    Write-Output "Skipped in-game world chat (-SkipWorldChat)."
    exit 0
}

$worldMessage = ("Update / Update`nNL: {0}`nEN: {1}" -f $WorldChatNl.Trim(), $WorldChatEn.Trim())
if ($worldMessage.Length -gt 800) {
    Write-Error ("World chat message exceeds 800 characters ({0}). Shorten WorldChatNl/WorldChatEn." -f $worldMessage.Length)
    exit 1
}

$plink = Join-Path ${env:ProgramFiles} "PuTTY\plink.exe"
if (-not (Test-Path $plink)) {
    Write-Error "plink.exe not found; Discord was posted but world chat was not. Install PuTTY or re-run without needing world chat after fixing plink."
    exit 1
}

$hostName = $SshHost
if ([string]::IsNullOrWhiteSpace($hostName)) {
    $hostName = Get-PuTTYSessionHostName -SessionName $PuttySession
}
if ([string]::IsNullOrWhiteSpace($hostName)) {
    Write-Error "Discord was posted but world chat failed: set -SshHost or fix PuTTY session HostName."
    exit 1
}

$b64 = [Convert]::ToBase64String($utf8NoBom.GetBytes($worldMessage))
$dirUnix = ($ProjectDir -replace "\\", "/").TrimEnd("/")
$remoteScript = @"
#!/bin/bash
set -e
cd '$dirUnix'
docker compose --env-file .env.plesk -f docker-compose.plesk.yml exec -T backend node dist/scripts/postSystemAnnouncement.js --name 'The Mob State' --b64 '$b64'
"@

$tmp = [System.IO.Path]::GetTempFileName() + ".sh"
$sshTarget = "${SshUser}@${hostName}"
try {
    [System.IO.File]::WriteAllText($tmp, $remoteScript, $utf8NoBom)
    $worldOut = & $plink -l $SshUser -no-antispoof -load $PuttySession -m $tmp $sshTarget 2>&1
    $worldExit = $LASTEXITCODE
} catch {
    Write-Error "Discord was posted but world-chat plink failed."
    exit 1
} finally {
    Remove-Item -LiteralPath $tmp -Force -ErrorAction SilentlyContinue
}

if ($worldExit -ne 0) {
    Write-Error ("Discord was posted but world-chat script failed (exit {0}): {1}" -f $worldExit, ($worldOut | Out-String).Trim())
    exit 1
}

Write-Output ("Posted NL+EN teaser to in-game world chat ({0} chars)." -f $worldMessage.Length)
Write-Output ($worldOut | Out-String).Trim()
