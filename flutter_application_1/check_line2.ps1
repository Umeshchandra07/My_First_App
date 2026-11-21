$lines = Get-Content lib/home_feed_page.dart -Raw
$line345 = $lines.Split("`n")[344]  # 0-based index
Write-Host "Line 345 length: $($line345.Length)"
Write-Host "Line 345 content: '$line345'"
for ($i = 0; $i -lt $line345.Length; $i++) {
    $ch = $line345[$i]
    $code = [int]$ch
    Write-Host "${i}: [$ch] $code"
}
$line346 = $lines.Split("`n")[345]
Write-Host "Line 346 content: '$line346'"