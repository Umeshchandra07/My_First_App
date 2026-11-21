$lines = Get-Content lib/home_feed_page.dart
for ($i = 180; $i -le 210; $i++) {
    if ($i -lt $lines.Count) {
        Write-Host "$($i+1): $($lines[$i])"
    }
}