$lines = Get-Content lib/home_feed_page.dart
for ($i = 320; $i -le 360; $i++) {
    if ($i -lt $lines.Count) {
        Write-Host "$($i+1): $($lines[$i])"
    }
}