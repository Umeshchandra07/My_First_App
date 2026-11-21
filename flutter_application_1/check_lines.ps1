$lines = Get-Content lib/home_feed_page.dart -Raw
for ($i = 338; $i -le 348; $i++) {
    if ($i -lt $lines.Split("`n").Count) {
        $line = $lines.Split("`n")[$i]
        Write-Host "$($i+1): '$line'"
    }
}