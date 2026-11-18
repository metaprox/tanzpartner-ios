# Server-Test – Übergabe 16.11.2026

Separater technischer Versuch für eine spätere Erweiterung; kein Bestandteil der Offline-V1 und iOS-Leseansicht seit 16.11. als Debug-Tab implementiert, erfolgreicher Demo-Abruf auf iPhone 16 Pro Max mit iOS 27.2.1 vom Nutzer bestätigt; weitere Abnahmefälle offen. Nachweise: Screenshots und Rückmeldungen des Nutzers in der gemeinsamen Einrichtung. Keine unabhängige Serverinspektion oder vollständige Sicherheitsprüfung durch Codex.

## Produktentscheidung

Spätere Partnersuche als digitales schwarzes Brett: eigene Gesuche erstellen, bearbeiten, pausieren/löschen, Gesuche suchen/filtern, melden und administrativ entfernen. **Kein Chat, kein internes Kontaktanfrage-System.** Kontakt außerhalb der App über bewusst freigegebene Kontaktdaten. Sichtbarkeit dieser Daten noch festzulegen (nur angemeldete Nutzer war ein Vorschlag, keine finale Entscheidung). Gesuche sollen ablaufen und eine erneute Bestätigung benötigen; genaue Frist offen. Der Test verwendet 30 Tage.

## Umgebung und Pfade

- manitu Webhosting M, PHP 8.4 laut Verwaltungsansicht; MariaDB, genaue Version offen. Kein zusätzlicher Server bestellt.
- Testadresse: `https://ios-test.tanzpartner-ostfriesland.de`; Zielordner `/htdocs/ios-test/`. Nach anfänglicher Deaktivierung für die Tests aktiviert; Zugang über HTTP Basic Auth geschützt.
- Hauptwebsite blieb nach Nutzerangabe separat deaktiviert; spätere Hauptwebsite-Konfiguration nicht erneut geprüft. Nicht ungefragt aktivieren oder ändern.
- SSL: Let's Encrypt und automatische HTTPS-Umleitung eingestellt. Nutzer konnte den HTTPS-Endpunkt aufrufen; Zertifikatslaufzeit und Erneuerung nicht separat geprüft.
- Dateizugriff: Cyberduck, Bearbeitung ausschließlich in VS Code als reiner Text. TextEdit hatte HTML als sichtbaren Text eingebettet. FTP-SSL (FTPS) vom Nutzer am 16.11.2026 bestätigt.
- In Cyberduck sichtbare Pfade beziehen sich auf `/home/sites/site100047965/web/`.
- Datenbank: `db138017`, MariaDB auf `mysql14.manitu.net`, Port 3306; Benutzer `u138017`. Bestehende ältere Datenbank nicht verändern. Nur PHP greift intern auf MariaDB zu, kein direkter Datenbankzugriff aus der App.
- Konfiguration: `/private/db-config.php` außerhalb von `htdocs`; PHP lädt `/home/sites/site100047965/web/private/db-config.php`. Gibt ein Array mit `host`, `database`, `username`, `password` zurück. Die echte Datei und Passwörter niemals ins Repository übernehmen.
- Passwortdatei: `/.htpasswd` außerhalb von `htdocs`. `.htaccess` in `/htdocs/ios-test/` nutzt `AuthType Basic`, `AuthName "Tanzpartner"`, `AuthUserFile /home/sites/site100047965/web/.htpasswd`, `Require valid-user`. Der Schutz wurde aus dem getrennten Website-Ordner kopiert; Geschwisterordner erben ihn nicht.

## Daten und Schnittstelle

Tabelle `demo_gesuche`: `id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY`, `anzeigename VARCHAR(80)`, `ort VARCHAR(100)`, `tanzstil VARCHAR(80)`, `beschreibung TEXT`, `ablaufdatum DATE`; alle Pflichtfelder `NOT NULL`. InnoDB, `utf8mb4_unicode_ci`.

Drei fiktive Gesuche ohne Kontaktdaten, vom Nutzer eingefügt und über die Schnittstelle zurückgeliefert:

| ID | Anzeigename | Ort | Tanzstil | Ablaufdatum |
|---|---|---|---|---|
| 1 | Demo Anna | Norden | Discofox | 2026-12-15 |
| 2 | Demo Ben | Aurich | Salsa | 2026-12-15 |
| 3 | Demo Clara | Emden | Standard | 2026-12-15 |

Beschreibungen beginnen mit „Fiktives Testgesuch“. SQL beim Wiederaufnehmen nicht erneut einfügen; sonst entstehen Duplikate.

`GET /gesuche.php` liest via PDO, filtert `ablaufdatum >= CURDATE()` und sortiert nach ID. Keine Schreibfunktion. Ausgabe: `Content-Type: application/json; charset=utf-8`, `Cache-Control: no-store`.

```json
{"gesuche":[{"id":1,"anzeigename":"Demo Anna","ort":"Norden","tanzstil":"Discofox","beschreibung":"Fiktives Testgesuch: Suche jemanden für einen Anfängerkurs.","ablaufdatum":"2026-12-15"}]}
```

Beispiel gekürzt auf einen Eintrag. IDs werden als Zahlen ausgegeben. Ohne aktive Gesuche: `{"gesuche":[]}`. Bei abgefangenen Fehlern HTTP 500 mit `{"fehler":"Gesuche konnten nicht geladen werden."}`; keine technischen Fehlerdetails an Clients. Fehler-/Leerfälle bisher nicht getestet. Nach dem Ablaufdatum sind leere Ergebnisse erwartbar.

## Verifizierungsstand

| Prüfung durch Nutzer | Berichtetes Ergebnis |
|---|---|
| `index.html` nach Korrektur in VS Code | Überschrift sichtbar |
| `test.php` | „PHP funktioniert“ |
| `db-test.php` | Verbindung erfolgreich, drei Demo-Gesuche |
| HTTPS-Aufruf `gesuche.php` mit Anmeldung | Drei Gesuche samt Umlauten und Ablaufdatum geliefert |
| Privater Browseraufruf, Anmeldung abgebrochen | HTTP 401 Unauthorized, keine Gesuche |

Entfernung von `test.php` und `db-test.php` am 16.11.2026 ausdrücklich vom Nutzer bestätigt. Am selben Tag Zugriffstest wiederholt und vom Nutzer bestätigt: ohne Anmeldung 401, mit Anmeldung drei Demo-Gesuche. `index.html`, `gesuche.php` und `.htaccess` sollen im Testordner verbleiben. Die am 16.11.2026 vom Nutzer heruntergeladene `gesuche.php` ist jetzt unverändert unter [server-test/](server-test/README.md) gesichert, zusammen mit einer Konfigurationsvorlage ohne Geheimnisse und dem Schema aus dem Chat. Kein erneuter Upload oder unabhängiger Live-Test durch Codex; lokale Syntaxprüfung beider PHP-Dateien mit Homebrew PHP 8.4.27 am 16.11.2026 erfolgreich, keine Laufzeitprüfung.

## Nächste Arbeit

Aufgaben S01–S04 in [TODO.md](TODO.md). Vor App-Anbindung: aktuelle Serverdatei ohne Geheimnisse lokal versionieren, sicherstellen, dass der Passwortschutz weiterhin greift, Ausgangsbuild prüfen. Testzugang ist kein Nutzerkontensystem. Keine Passwörter fest in App-Code/Bundle oder Git speichern; Eingabe zur Laufzeit, bei dauerhafter Speicherung Keychain vorsehen.

Offen vor öffentlichem Betrieb: Backups inklusive Wiederherstellung, Ressourcen-/Mail-Limits, Konten/Berechtigungen, Moderation, Löschung, Kontaktdatensichtbarkeit, Datenschutz und Betriebsverantwortung. Der bisherige Test ist keine öffentliche Freigabe.

## Geräteabnahme der Online-Testansicht (S03 teilweise offen)

Nutzerbericht vom 16.11.2026: Tab sichtbar, Demo-Daten erfolgreich auf dem iPhone geladen. Positiver Abrufpfad bestätigt; folgende übrige Fälle bleiben zu prüfen.

Aus Xcode als Debug-Build starten → Tab „Online-Test“. Benutzername/Passwort des Website-Schutzes eingeben, nicht Datenbankzugang. Keine Geheimnisse in Screenshots/Chat teilen.

- Mit gültigem Zugang drei Demo-Gesuche laden (nur solange noch nicht abgelaufen).
- Falsches Passwort: verständlicher Zugriffshinweis, keine Ergebnisse.
- Im Flugmodus laden: Netzfehler anzeigen, keine alten Ergebnisse als aktuell ausgeben.
- Tab verlassen/zurückkehren und App in Hintergrund bringen: Zugang/Ergebnisse gelöscht.
- Laden starten, sofort Tab verlassen: kein spätes Wiederbefüllen.
- Leere Antwort und Serverfehler noch gezielt prüfen, ohne vorhandene Testdaten zu löschen.

Nur der Debug-Build bietet den Tab; keine Veröffentlichung des Serverversuchs mit der Offline-V1. Bestehende Datenschutztexte sind für eine spätere öffentliche Online-Funktion erneut abzugleichen. Die Ansicht erklärt den Online-Test und das flüchtige Speichern; keine Nutzerkonten oder echte Gesuche.
