<?php
// Vorlage. Ausgefüllt als private/mail-config.php außerhalb von htdocs ablegen.
// Die ausgefüllte Datei niemals ins Repository übernehmen.
return [
    'to'        => 'EIGENE-TESTADRESSE',                    // Empfänger der Testmail
    'from'      => 'POSTFACH@tanzpartner-ostfriesland.de',  // Absender = echtes Postfach
    'reply_to'  => 'kontakt@tanzpartner-ostfriesland.de',   // Antworten gehen hierhin
    'smtp_host' => 'SMTP-SERVER-LAUT-KUNDENMENUE',
    'smtp_user' => 'BENUTZERNAME-DES-POSTFACHS',
    'smtp_pass' => 'PASSWORT-DES-POSTFACHS',
];
