# TODO – Kleine Aufgaben bis zur ersten Store-Version

Stand: 20.11.2026. Ziel und Entscheidungen: [ROADMAP.md](ROADMAP.md). Reihenfolge: P0 vor P1 vor P2; Abhängigkeiten beachten. Je Sitzung möglichst **eine** Aufgabe, meist 15–45 Minuten. Wird sie größer, vor Umsetzung in Teilaufgaben mit eigener ID zerlegen. `[ ]` = offen, auch bei Teilergebnis; `[x]` nur mit erfüllten Kriterien und Nachweis im [Arbeitslog](ARBEITSLOG.md). Blockaden und „in Arbeit“ im Log festhalten.

Am 20.11.2026 neu ausgerichtet: Ziel ist eine echte Tanzpartner-Börse statt eines Offline-Lexikons. Frühere Aufgaben F01–F05b und L01–L05 sind entfallen bzw. in I01 zusammengefasst; der alte Stand liegt in der Git-Historie (Commit `1f5ad60`).

## P0 – Grundlage

- [x] **D01 – Dokumentationsgrundlage erstellen.** Nachweis: ARBEITSLOG; Commit `1c40043`.
- [x] **D02 – Dokumentation nach GitHub übertragen/verifizieren.** Nachweis 20.11.2026: Commit `556d63c` vom Nutzer gepusht; nach `git fetch` steht `origin/main` auf `556d63c`.
- [x] **V01 – Ausgangsbuild und Mindest-iOS prüfen.** Nachweis 16.11.2026 im ARBEITSLOG (Xcode 27.2, effektives Mindest-iOS 17.0).

## P0 – Konzept

- [x] **K01 – Offene Entscheidungen festlegen.** Nachweis 20.11.2026: Nutzer entschied Mindestalter 18, Laufzeit 30 Tage, Pflicht-/Optionalfelder und vorläufigen Absender; in ROADMAP eingetragen. Feldlängen nach K02 verschoben.
- [x] **K02 – Datenmodell und API-Vertrag beschreiben.** Nachweis 20.11.2026: [docs/K02-DATENMODELL-API.md](docs/K02-DATENMODELL-API.md); Nutzer bestätigte alle Vorschläge aus Abschnitt 6. Fristen werden in K03 nur noch in die Abläufe übernommen. Abhängigkeit: K01. Akzeptanz: Feldlängen und erlaubte Werte; Tabellen (Gesuche, Bestätigungs-/Verwaltungstoken, Meldungen, Sperrliste, ggf. Protokoll für Spamschutz) mit Feldern und Status; Endpunkte mit Anfrage, Antwort und Fehlercodes als JSON-Beispiele; Statusübergänge (unbestätigt → wartet auf Freigabe → sichtbar → abgelaufen/gelöscht/abgelehnt). Kein Code.
- [x] **K03 – Abläufe und Texte festlegen.** Nachweis 20.11.2026: [docs/K03-ABLAEUFE-TEXTE.md](docs/K03-ABLAEUFE-TEXTE.md); Nutzer bestätigte die Vorschläge aus Abschnitt 7. Offen nur: Aufbewahrung der Betreiber-Mails (Abschnitt 3), Klärung in P01. Abhängigkeit: K02. Akzeptanz: Ablauf für Aufgeben/Bestätigen/Freigabe/Erinnerung/Verlängern/Löschen, Kontaktweiterleitung, Meldung und Sperre beschrieben; Entwürfe aller Mails und App-Hinweise; Fristen und was gespeichert/gelöscht wird.

## P1 – Server

- [ ] **S04 – Betriebsvoraussetzungen klären.** Akzeptanz: MariaDB-Version, Backup/Restore, Mail-Limits und Absender (SPF/DKIM) beim Hoster, Cronjobs, Verantwortlichkeit dokumentiert. Vorgezogen, da Mailversand zentral ist. Teilstand 20.11.: Alias `kontakt@` und echtes Versandpostfach eingerichtet, Limit 100 Mails/Stunde, DKIM laut manitu-FAQ aktiv; Mailtest erfolgreich, Versand per SMTP festgelegt (`mail()` landete im Spam). SPF und DKIM bestehen, DMARC-Eintrag fehlt noch (DNS). Offen: DMARC, MariaDB-Version, Backup/Restore, Cronjobs.
- [ ] **B01 – Schema anlegen.** Abhängigkeit: K02. Akzeptanz: neue Tabellen in der Testdatenbank; `demo_gesuche` unverändert; Schema-Datei ohne Geheimnisse im Repository.
- [ ] **B02 – Öffentliche Leseschnittstelle.** Abhängigkeit: B01. Akzeptanz: liefert nur freigegebene, nicht abgelaufene Gesuche ohne E-Mail-Adressen; Leer- und Fehlerfall wie im API-Vertrag; vorerst weiter hinter dem Testzugangsschutz.
- [ ] **B03 – Gesuch annehmen und bestätigen.** Abhängigkeit: B01, K03, S04. Akzeptanz: Eingaben serverseitig geprüft; Bestätigungsmail mit Link; unbestätigte Gesuche verfallen; Schutz gegen Massenanfragen; gesperrte Adressen abgewiesen.
- [ ] **B04 – Kontaktweiterleitung.** Abhängigkeit: B03. Akzeptanz: Nachricht wird per Mail weitergeleitet, Adresse des Gesuchs bleibt verborgen; Absender bestätigt Alter/Hinweis; Begrenzung pro Absender/Zeitraum; Sperrliste wirkt.
- [ ] **B05 – Meldungen.** Abhängigkeit: B01. Akzeptanz: Meldung mit Grund gespeichert; Betreiber wird benachrichtigt; Gesuch bleibt sichtbar bis zur Entscheidung oder wird ab Schwelle ausgeblendet (Entscheidung in K03).
- [ ] **B06 – Ablauf, Erinnerung, Verlängern/Löschen.** Abhängigkeit: B03, S04. Akzeptanz: Erinnerungsmail vor Ablauf; Verlängern und endgültiges Löschen per Link; abgelaufene Daten nach festgelegter Frist gelöscht.
- [ ] **B07 – Admin-Webseite.** Abhängigkeit: B03, B05. Akzeptanz: geschützt; freigeben/ablehnen, Meldungen bearbeiten, Adressen sperren, Gesuche löschen; nicht in der App.
- [ ] **B08 – Sicherheitsprüfung Server.** Abhängigkeit: B02–B07. Akzeptanz: Eingaben/SQL, Header, Fehlermeldungen ohne Interna, Geheimnisse außerhalb von Git und Webverzeichnis, Protokollierung und Löschfristen geprüft; Befunde behoben.

## P1 – App

- [ ] **F10 – Gesuche vom Server anzeigen.** Abhängigkeit: B02. Akzeptanz: Liste, Suche/Filter und Detail auf Basis der bisherigen Ansichten; Laden, leeres Ergebnis, Serverfehler und fehlendes Netz verständlich (übernimmt die offenen Fälle aus S03).
- [ ] **F11 – Gesuch aufgeben.** Abhängigkeit: B03, F10. Akzeptanz: Formular mit Pflichtfeldern, Altersbestätigung und Datenschutzhinweis; Hinweis auf Bestätigungsmail und Freigabe; Fehler verständlich.
- [ ] **F12 – Kontaktformular.** Abhängigkeit: B04, F10. Akzeptanz: Nachricht und eigene E-Mail-Adresse; Hinweis, dass kein Chat stattfindet und die Antwort per Mail kommt.
- [ ] **F13 – Gesuch melden.** Abhängigkeit: B05, F10. Akzeptanz: aus der Detailansicht erreichbar; Rückmeldung nach dem Absenden.
- [ ] **F14 – Altlasten entfernen.** Abhängigkeit: F10. Akzeptanz: fiktive Profile, lokale Profilspeicherung, Kontakt-Simulation, Moderations-Tab, Push-/Sync-Schalter und Debug-Tab aus der Store-Version entfernt; Hintergrundmodi und `armv7` aus `Info.plist`; Mindest-iOS einheitlich 17.0. (Ersetzt F02; Nutzerentscheidung 20.11.: Push-Schalter bis dahin unverändert.)
- [ ] **F15 – Datenschutz und Impressum in der App.** Abhängigkeit: K03, P02. Akzeptanz: Texte entsprechen der tatsächlichen Verarbeitung; Kontaktmöglichkeit für Meldungen sichtbar; Verweis auf die öffentliche Datenschutzerklärung.

## P1 – Test und Datenschutz

- [ ] **Q01 – Testmatrix anlegen.** Abhängigkeit: F10–F15, B02–B07. Akzeptanz: Fälle für Lesen, Aufgeben, Bestätigen, Freigabe, Kontakt, Meldung, Sperre, Ablauf/Verlängern/Löschen, Offline und Serverfehler; Soll-Ergebnis pro Fall.
- [ ] **Q02 – Matrix auf Simulator und echtem Gerät durchführen.** Abhängigkeit: Q01. Akzeptanz: Build-Commit, Geräte/OS, Ist-Ergebnisse und Fehler erfasst.
- [ ] **Q03 – Bedienbarkeit und Fehlernachtest.** Abhängigkeit: Q02. Akzeptanz: große Schrift, VoiceOver, Hell/Dunkel geprüft; blockierende Fehler behoben und nachgetestet.
- [ ] **P01 – Tatsächliche Datenflüsse prüfen.** Abhängigkeit: Q02. Akzeptanz: welche Daten App, Server, Mails und Protokolle speichern, wie lange und wer sie sieht; Hoster als Auftragsverarbeiter berücksichtigt.
- [ ] **P02 – Datenschutzerklärung und Impressum abgleichen.** Abhängigkeit: P01. Akzeptanz: Texte decken reale Verarbeitung, Löschung und Kontakt ab; öffentliche Webadresse und In-App-Text stimmen überein; Gegenlesen durch eine fachkundige Person empfohlen.
- [ ] **P03 – Apple-Datenschutzangaben prüfen.** Abhängigkeit: P01, P02. Akzeptanz: aktuelle Apple-Vorgaben zum Prüfdatum nachgelesen; App-Privacy-Angaben und ggf. Privacy Manifest anhand der realen App; Quellen/Datum/Ergebnis dokumentiert.

## P2 – Store

- [ ] **A01 – Store-Unterlagen vorbereiten.** Abhängigkeit: Q03, P02, P03. Akzeptanz: Name/Beschreibung/Screenshots als regionale Tanzpartner-Börse (kein Dating); Support- und Datenschutz-URL erreichbar; Altersfreigabe passend zum Mindestalter; Hinweise für die Prüfung (Server läuft, Testablauf); Händlerstatus als nicht gewerblich.
- [ ] **A02 – Release-Kandidat freigeben.** Abhängigkeit: A01. Akzeptanz: Signierung, Bundle-ID, Version/Build, Archiv/Validierung und Gerätetest geprüft; aktuelle Prüfrichtlinien nachgelesen; Testzugangsschutz des Servers für den Betrieb ersetzt; Release-Entscheidung protokolliert.
- [ ] **A03 – Einreichung und Rückmeldung dokumentieren.** Abhängigkeit: A02. Akzeptanz: Datum/Build/Status erfasst; Rückfragen als neue Aufgaben. „Eingereicht“ bedeutet nicht „zugelassen“.

## Später

- [ ] **I01 – Mehrwert für Nutzer bewerten:** Tanzlexikon oder „Wo kann ich in Ostfriesland tanzen?“; Nutzen und Aufwand vergleichen, keine implizite Zusage. Inhaltsstandard für ein Lexikon in ROADMAP.

## Server-Test (Grundlage, abgeschlossen bzw. aufgegangen)

- [x] **S01 – Geschützten Lesetest einrichten.** Nutzerberichte 16.11.2026; Belege in [SERVER-TEST.md](SERVER-TEST.md).
- [x] **S02 – Server-Test reproduzierbar sichern.** Abgeschlossen 16.11.2026; Nachweis im ARBEITSLOG.
- [ ] **S03 – Kleine native Leseansicht anbinden.** Zweck erreicht: iOS-App lädt über HTTPS/PHP Daten aus der MariaDB (Gerät bestätigt; doppelte Passworteingabe am 20.11. behoben). Restfälle gehen in F10 auf; Aufgabe wird damit nicht weiterverfolgt.
