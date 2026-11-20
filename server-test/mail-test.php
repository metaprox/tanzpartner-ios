<?php
// Einmaliger Test des Mailversands (S04). Nur im passwortgeschützten
// Testordner ablegen und nach dem Test wieder löschen.
// Aufruf: mail-test.php            -> zeigt Umgebung, sendet nichts
//         mail-test.php?modus=mail -> Versand über PHP mail()
//         mail-test.php?modus=smtp -> Versand über SMTP (SSL, Port 465)
// Zugangsdaten stehen ausschließlich in private/mail-config.php.

ini_set('display_errors', '0');
header('Content-Type: text/plain; charset=utf-8');
header('Cache-Control: no-store');

$configPath = '/home/sites/site100047965/web/private/mail-config.php';
if (!is_readable($configPath)) {
    http_response_code(500);
    exit("Konfiguration fehlt: private/mail-config.php\n");
}
$c = require $configPath;

$modus = $_GET['modus'] ?? '';
if ($modus !== 'mail' && $modus !== 'smtp') {
    echo "Umgebung (es wurde nichts gesendet)\n";
    echo "PHP-Version: " . PHP_VERSION . "\n";
    echo "mail() vorhanden: " . (function_exists('mail') ? 'ja' : 'nein') . "\n";
    echo "sendmail_path: " . ini_get('sendmail_path') . "\n";
    echo "OpenSSL: " . (extension_loaded('openssl') ? 'ja' : 'nein') . "\n";
    echo "\nVersand testen mit ?modus=mail oder ?modus=smtp\n";
    exit;
}

$zeit = date('Y-m-d H:i:s');
$betreff = '=?UTF-8?B?' . base64_encode("Tanzpartner-Mailtest ($modus) $zeit") . '?=';
$text = "Testmail des Tanzpartner-Servers über $modus ($zeit).\n"
      . "Umlaute: äöüß. Keine Antwort nötig.\n";
$domain = substr(strrchr($c['from'], '@'), 1);

$kopf = [
    'From: =?UTF-8?B?' . base64_encode('Tanzpartner Ostfriesland') . '?= <' . $c['from'] . '>',
    'Reply-To: ' . $c['reply_to'],
    'MIME-Version: 1.0',
    'Content-Type: text/plain; charset=UTF-8',
    'Content-Transfer-Encoding: 8bit',
];

if ($modus === 'mail') {
    $ok = mail($c['to'], $betreff, $text, implode("\r\n", $kopf), '-f' . $c['from']);
    echo $ok
        ? "mail() hat die Nachricht angenommen. Zustellung im Posteingang (auch Spam) prüfen.\n"
        : "mail() hat die Nachricht abgelehnt.\n";
    exit;
}

// --- SMTP mit Anmeldung über SSL (Port 465) ---
function smtpAntwort($fp, int $erwartet): string
{
    $antwort = '';
    while (($zeile = fgets($fp, 515)) !== false) {
        $antwort .= $zeile;
        if (strlen($zeile) < 4 || $zeile[3] === ' ') {
            break;
        }
    }
    if ((int) substr($antwort, 0, 3) !== $erwartet) {
        throw new RuntimeException(trim($antwort) ?: 'keine Antwort');
    }
    return $antwort;
}

function smtpBefehl($fp, string $befehl, int $erwartet, string $schritt): void
{
    fwrite($fp, $befehl . "\r\n");
    try {
        smtpAntwort($fp, $erwartet);
    } catch (RuntimeException $e) {
        throw new RuntimeException("$schritt fehlgeschlagen: " . $e->getMessage());
    }
}

try {
    $kontext = stream_context_create(['ssl' => ['verify_peer' => true, 'verify_peer_name' => true]]);
    $fp = stream_socket_client('ssl://' . $c['smtp_host'] . ':465', $nr, $fehler, 20,
        STREAM_CLIENT_CONNECT, $kontext);
    if (!$fp) {
        throw new RuntimeException("Verbindung zu {$c['smtp_host']}:465 fehlgeschlagen: $fehler");
    }
    stream_set_timeout($fp, 20);
    smtpAntwort($fp, 220);
    smtpBefehl($fp, 'EHLO ' . $domain, 250, 'Begrüßung');
    smtpBefehl($fp, 'AUTH LOGIN', 334, 'Anmeldung');
    smtpBefehl($fp, base64_encode($c['smtp_user']), 334, 'Benutzername');
    smtpBefehl($fp, base64_encode($c['smtp_pass']), 235, 'Passwort');
    smtpBefehl($fp, 'MAIL FROM:<' . $c['from'] . '>', 250, 'Absender');
    smtpBefehl($fp, 'RCPT TO:<' . $c['to'] . '>', 250, 'Empfänger');
    smtpBefehl($fp, 'DATA', 354, 'Datenbeginn');

    $nachricht = implode("\r\n", array_merge($kopf, [
        'To: <' . $c['to'] . '>',
        'Subject: ' . $betreff,
        'Date: ' . date('r'),
        'Message-ID: <' . bin2hex(random_bytes(12)) . '@' . $domain . '>',
    ])) . "\r\n\r\n" . preg_replace('/^\./m', '..', str_replace("\n", "\r\n", $text));
    smtpBefehl($fp, $nachricht . "\r\n.", 250, 'Versand');
    fwrite($fp, "QUIT\r\n");
    fclose($fp);
    echo "SMTP-Versand angenommen. Zustellung im Posteingang (auch Spam) prüfen.\n";
} catch (Throwable $e) {
    http_response_code(500);
    echo "SMTP-Test fehlgeschlagen: " . $e->getMessage() . "\n";
}
