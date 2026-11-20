# Gesicherter Server-Test

`gesuche.php`: am 16.11.2026 vom Nutzer per Cyberduck heruntergeladene Datei, unverändert übernommen. Enthält keine Passwörter; der Konfigurationspfad ist installationsspezifisch. Authentifizierung erfolgt durch die separate `.htaccess` auf dem Server, nicht durch PHP. Nicht ungeschützt veröffentlichen.

`db-config.example.php`: ausschließlich Platzhalter. Die ausgefüllte Konfiguration bleibt außerhalb des Webverzeichnisses und des Repositorys. Die Git-Ausschlussregeln schützen vor versehentlichem Hinzufügen üblicher Geheimnisdateien; vor jedem Commit trotzdem Diff prüfen.

`schema.sql`: Referenz nach dem gemeinsam ausgeführten SQL; kein Schema-Export vom Server. Nur für eine neue, leere Testdatenbank gedacht. Bestehende Datenbank unverändert lassen, Demo-Daten nicht erneut einfügen.

Keine erneute Bereitstellung erforderlich. Beim Wiederaufsetzen: eigenen geschützten Testordner und HTTPS einrichten, Konfiguration außerhalb von htdocs ablegen, PHP-Konfigurationspfad prüfen und Datei erst hinter dem Zugriffsschutz bereitstellen. Passwortdatei niemals ins Webverzeichnis kopieren.

Abnahme: ohne Anmeldung 401; mit Anmeldung JSON mit numerischen IDs, Umlauten und gültigen Gesuchen; abgelaufene Gesuche fehlen. Nach 15.12.2026 kann die aktuelle Testdatenmenge leer sein. Fehler-/Leerfälle bislang nicht getestet. Browserprüfung am 16.11.2026 durch Nutzer wiederholt und bestätigt: ohne Anmeldung 401, mit Anmeldung drei Demo-Gesuche. Entfernung der temporären Testdateien ebenfalls bestätigt; keine unabhängige Serverprüfung durch Codex.

Lokale PHP-Syntaxprüfung: `/opt/homebrew/opt/php@8.4/bin/php -l server-test/gesuche.php` und `/opt/homebrew/opt/php@8.4/bin/php -l server-test/db-config.example.php`. Am 16.11.2026 mit Homebrew PHP 8.4.27 beide erfolgreich ausgeführt: keine Syntaxfehler. Keine lokale Datenbank-/Laufzeitprüfung. Kein Hintergrunddienst nötig.

Umgebung, API-Vertrag und nächste Aufgaben: [SERVER-TEST.md](../SERVER-TEST.md), [TODO.md](../TODO.md).

## Mailtest (S04, ab 20.11.2026)

`mail-test.php` prüft einmalig, ob der Server Mails versenden kann – über PHP `mail()` und über SMTP mit Anmeldung (SSL, Port 465). Ablauf: `mail-config.example.php` ausgefüllt als `private/mail-config.php` ablegen (echtes Postfach, nicht nur Alias; Datei nie ins Repository), `mail-test.php` in den geschützten Testordner kopieren, ohne Parameter aufrufen (zeigt nur die Umgebung), dann `?modus=mail` und `?modus=smtp` je einmal. Zustellung, Spam-Ordner und Kopfzeilen (SPF/DKIM) der Testmails prüfen. Danach `mail-test.php` vom Server löschen. Lokal mit PHP 8.4.27 auf Syntax geprüft. Am 20.11.2026 vom Nutzer auf dem Server ausgeführt: beide Wege zugestellt, `mail()` im Spam, SMTP im Posteingang → Versand per SMTP. Skript danach vom Server gelöscht; `private/mail-config.php` bleibt. Beim Hochladen kopieren, nicht aus dem Repository verschieben.
