# Renders feature-ad.html to PNGs in ads/out/.
# Usage: .\ads\render.ps1 -Feature ai-scorecard
param([string]$Feature = 'ai-scorecard')

$chrome = 'C:\Program Files\Google\Chrome\Application\chrome.exe'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$out = Join-Path $here 'out'
New-Item -ItemType Directory -Force $out | Out-Null
$page = 'file:///' + ((Join-Path $here 'feature-ad.html') -replace '\\', '/')

$sizes = @{ landscape = '1200,627'; square = '1080,1080'; story = '1080,1920' }
foreach ($s in $sizes.Keys) {
  $png = Join-Path $out "$Feature-$s.png"
  & $chrome --headless=new --disable-gpu --hide-scrollbars --force-device-scale-factor=1 `
    --virtual-time-budget=4000 "--window-size=$($sizes[$s])" "--screenshot=$png" `
    "$page`?feature=$Feature&size=$s" 2>$null | Out-Null
  Write-Output "Wrote $png"
}
