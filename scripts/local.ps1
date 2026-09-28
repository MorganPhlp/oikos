param(
    [ValidateSet('setup', 'test', 'reset')][string]$Action = 'setup'
)
$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
Push-Location $projectRoot
try {
    if ((Get-Content -Raw supabase/config.toml) -notmatch 'project_id = "oikos-integration"') {
        throw 'Ce script est réservé au projet local oikos-integration.'
    }
    if ($Action -eq 'reset') {
        & supabase db reset --local
        if ($LASTEXITCODE -ne 0) { throw 'Échec du reset local.' }
    }
    if ($Action -ne 'test') {
        $startOutput = & supabase start -x logflare,vector,edge-runtime,supavisor 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($startOutput -join "`n") }
    }
    $statusJson = & supabase status -o json
    if ($LASTEXITCODE -ne 0) { throw 'Supabase local indisponible.' }
    $localStatus = $statusJson | ConvertFrom-Json
    if (([uri]$localStatus.API_URL).Host -notin @('127.0.0.1', 'localhost')) { throw 'URL non locale refusée.' }
    $env:SUPABASE_URL = $localStatus.API_URL
    $env:SUPABASE_ANON_KEY = $localStatus.ANON_KEY
    $env:SUPABASE_SERVICE_ROLE_KEY = $localStatus.SERVICE_ROLE_KEY
    if ($Action -eq 'test') {
        & node scripts/verify-local.mjs
    } else {
        New-Item -ItemType Directory -Force config | Out-Null
        $clientConfig = @{
            SUPABASE_URL = $localStatus.API_URL
            SUPABASE_ANON_KEY = $localStatus.ANON_KEY
            AUTH_REDIRECT_URL = 'http://localhost:3000/reset-password'
        }
        $clientConfig | ConvertTo-Json | Set-Content config/local.json -Encoding utf8NoBOM
        $clientConfig.SUPABASE_URL = $localStatus.API_URL.Replace('127.0.0.1', '10.0.2.2')
        $clientConfig.AUTH_REDIRECT_URL = 'io.supabase.oikos://login-callback/reset-password'
        $clientConfig | ConvertTo-Json | Set-Content config/local.android.json -Encoding utf8NoBOM
        & node scripts/seed-assets.mjs
    }
    if ($LASTEXITCODE -ne 0) { throw 'Échec du script Node.' }
    Write-Host "Supabase local : $($localStatus.API_URL) | Studio : $($localStatus.STUDIO_URL)"
} finally {
    Remove-Item Env:SUPABASE_URL,Env:SUPABASE_ANON_KEY,Env:SUPABASE_SERVICE_ROLE_KEY -ErrorAction SilentlyContinue
    Pop-Location
}
