# Arbeitslog – aktuelle Übergabe

## Stand 16.11.2026 – Online-Testansicht implementiert, Geräteabnahme offen

- **Arbeitsordner:** `/Users/svenschley/Documents/GitHub/tanzpartner-ios`; Branch `main`.
- **Sitzungsbasis:** `85cfb5e8a2c5914b75fd8d812d52e41c80ab053c`; Arbeitsverzeichnis anfangs sauber. Frühere Dokumentation lokal committed, Remote nicht neu geprüft.
- **Entscheidung:** Offline-V1 bleibt bestehen; spätere Partnersuche als schwarzes Brett ohne Chat/interne Kontaktanfragen. Kontaktdatensichtbarkeit noch offen.
- **S01:** Nutzer bestätigte HTTPS/PHP/MariaDB mit drei Demo-Gesuchen und HTTP 401 ohne Anmeldung; kein unabhängiger Live-Test. Details in SERVER-TEST.md.
- **S02 abgeschlossen:** Nutzerdatei `Downloads/gesuche.php` geprüft und bytegleich unter `server-test/gesuche.php` gesichert. Keine enthaltenen Passwörter. Konfigurationsvorlage mit Platzhaltern, Schema-Referenz und kurze Wiederherstellungs-/Prüfhinweise ergänzt. Git-Ausschlussregeln für echte Konfiguration und Passwortdateien ergänzt.
- **Prüfungen:** Dateiidentität, Links, Whitespace, Ausschlussregeln und unveränderte App-Dateien geprüft. Homebrew PHP 8.4.27 installiert; beide PHP-Dateien mit `/opt/homebrew/opt/php@8.4/bin/php -l` erfolgreich geprüft. Kein Datenbank-/Laufzeittest, kein Hintergrunddienst gestartet. Kein Schema-Export, Serverzugriff oder Upload in dieser Sitzung.
- **Abnahme S02 (16.11.2026):** Nutzer bestätigt ausdrücklich Entfernung von `test.php`/`db-test.php`, danach erneuten Browser-Test: Anmeldung abgebrochen → HTTP 401; nach Anmeldung → drei Demo-Gesuche. FTP-SSL ebenfalls bestätigt. Nutzerprüfung, keine unabhängige Serverinspektion; S02 abgehakt.
- **Nächster kleiner Schritt:** Nach der Pause verbleibende S03-Fälle prüfen: falscher Zugang, fehlendes Netz, leere Antwort/Serverfehler und Löschen des Zugangs beim Verlassen/Hintergrundwechsel. Keine erneuten Seed-Inserts.
- **V01 abgeschlossen:** 16.11.2026, Xcode 27.2 (27B52), Debug, generischer iOS-Simulator, SDK 27.2, effektives Deployment Target 17.0, Swift 5.0. `BUILD SUCCEEDED`, keine Fehler; ein Hinweis „Metadata extraction skipped, no AppIntents.framework dependency found“. Durch Codex kein App-Start, Gerätetest, Release-Build oder Funktionsnachweis. Erste eingeschränkte Einstellungsabfrage konnte Xcode-Dienste nicht erreichen; wiederholte Abfrage mit erforderlichem Zugriff erfolgreich.
- **Gerätetest (Nutzerbericht vom 16.11.2026):** App zwischenzeitlich auf iPhone 16 Pro Max mit iOS 27.2.1 installiert und getestet; laut Nutzer funktioniert der bisherige Stand grundsätzlich. Installierter Commit/Build und einzelne Testfälle nicht erfasst. Kein vollständiger Abnahmetest; offene Funktionen und Q01–Q03 bleiben offen.
- **Reproduzieren:** `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer xcodebuild -project TanzpartnerOstfrieslandiOS.xcodeproj -scheme TanzpartnerOstfrieslandiOS -configuration Debug -destination "generic/platform=iOS Simulator" -derivedDataPath /tmp/tanzpartner-v01-build CODE_SIGNING_ALLOWED=NO build`. Effektive Einstellungen mit gleichen Parametern und `-showBuildSettings -json` ausgelesen.
- **S03 Teilstand:** Neue `OnlineTestView.swift`, Tab nur unter `#if DEBUG`, Xcode-Dateiregistrierung ergänzt. Ephemere URLSession ohne Credential-/Cookie-/URL-Cache; feste HTTPS-Adresse, Redirects abgelehnt. Zugang/Ergebnisse werden beim Tab-Verlassen, Hintergrundwechsel oder Löschen geleert; laufender Request abgebrochen und veraltetes Ergebnis verworfen. 401/403, 5xx, Netzfehler, Timeout, falsches JSON und leere Liste behandelt. Keine Zugangsdaten fest eingebaut oder auf Platte gespeichert.
- **S03 Korrektur:** Nutzer sah nur drei Tabs. Ursache: Swift-Debug-Bedingung fehlte trotz Debug-Konfiguration; nur C-Präprozessor-DEBUG war gesetzt. `SWIFT_ACTIVE_COMPILATION_CONDITIONS = "$(inherited) DEBUG"` ausschließlich für Debug ergänzt. Erneuter Simulator-Build erfolgreich; Swift-Compiler-Aufruf mit `-DDEBUG` im Buildlog verifiziert. Erster Build-Erfolg allein war kein Sichtbarkeitsnachweis. Nutzer hat anschließend den sichtbaren Tab und erfolgreichen Demo-Abruf auf dem Gerät bestätigt.
- **S03 Prüfungen:** Debug- und Release-Build für generischen iOS-Simulator erfolgreich (Xcode 27.2); nur AppIntents-Metadatenhinweis. Tatsächliche Decodable-Modelle mit lokalem Swift-Test geprüft: gültiger Eintrag/Umlaute, leere Liste, fehlerhafte Antwort. Kein echter Login, UI-/Gerätetest oder Netzwerkfehlertest durch Codex; S03 bleibt offen.
- **Git:** aktuelle App- und Dokumentationsänderungen uncommitted; Commit/Push durch Nutzer. Bestehende Profilfunktionen nicht bearbeitet; Server und Datenbank unverändert.
- **Arbeitsweise:** Cyberduck + VS Code; kurze Einzelschritte, Screenshots nur bei Unklarheit.

## Knappe Übergabevorlage

```text
Datum / Bearbeiter / Aufgabe-ID:
Branch / Basis-Commit / vorhandene Änderungen:
Ergebnis / Dateien / Entscheidung:
Prüfung: Schritte, Umgebung, Soll/Ist und Ergebnis:
Nicht geprüft / Blockade / offene Kriterien:
Nächster kleiner Schritt:
Commit / Push / PR: Nachweis oder offen:
```

- **Weitere Ursache des fehlenden Tabs:** Xcode war auf `/Users/svenschley/Documents/tanzpartner-ios/` geöffnet (alter Arbeitsstand). Am 16.11. wurde per UI das aktuelle Projekt unter `/Users/svenschley/Documents/GitHub/tanzpartner-ios/` geöffnet; `OnlineTestView.swift` ist dort im Navigator sichtbar. Aktuelles Ziel nach Öffnen: Simulator iPhone 18 Pro. Nutzer muss für Gerätetest „iPhone von Sven“ auswählen und Run starten. Alte Projektkopie nicht verändert.

- **S03 Erfolg (Nutzerbericht vom 16.11.2026):** Online-Test funktioniert; Demo-Daten erscheinen auf dem iPhone (zuvor genannt: iPhone 16 Pro Max, iOS 27.2.1). Damit positiver Abrufpfad am Gerät bestätigt. Fehler-/Leerfälle und Löschen des flüchtigen Zugangs noch nicht vom Nutzer bestätigt; S03 bleibt teilweise offen. Pause bleibt bestehen.
