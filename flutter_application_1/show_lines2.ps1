$lines = Get-Content lib/home_feed_page.dart
for ($i = 355; $i -le 380; $i++) {
    if ($i -lt $lines.Count) {
        Write-Host "$($i+1): $($lines[$i])"
    }
}