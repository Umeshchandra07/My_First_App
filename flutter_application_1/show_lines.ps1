$lines = Get-Content lib/home_feed_page.dart
for ($i = 339; $i -le 355; $i++) {
    if ($i -lt $lines.Count) {
        Write-Host "$($i+1): $($lines[$i])"
    }
}