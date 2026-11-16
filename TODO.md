# TODO – Kleine Aufgaben für V1

Stand: 16.11.2026. Reihenfolge: P0 vor P1 vor P2; Abhängigkeiten beachten. Je Sitzung möglichst **eine** Aufgabe, meist 15–45 Minuten. Wird sie größer, vor Umsetzung in Teilaufgaben mit eigener ID zerlegen. `[ ]` = offen, auch bei Teilergebnis; `[x]` nur mit erfüllten Kriterien und Nachweis im [Arbeitslog](ARBEITSLOG.md). Blockaden und „in Arbeit“ im Log festhalten. Keine parallelen konkurrierenden Änderungen derselben Aufgabe.

## P0 – Grundlage und ehrlicher Umfang

- [x] **D01 – Dokumentationsgrundlage erstellen.** Akzeptanz: ROADMAP, TODO, ARBEITSLOG und Verweise in README/KI-Leitfaden vorhanden; historische Aussagen abgegrenzt; keine App-Codeänderung. Nachweis: aktueller Stand im ARBEITSLOG; Dokumentation im lokalen Commit `1c40043` vorhanden; Remote-Stand nicht frisch geprüft.
- [ ] **D02 – Dokumentation nach GitHub übertragen/verifizieren.** Abhängigkeit: D01. Bisherige Dokumentation lokal auf `main` in `1c40043` committed. Akzeptanz: aktuelle Ergänzungen committed/gepusht; Remote-Commit und Branch im Log bestätigt.
- [ ] **V01 – Ausgangsbuild und Mindest-iOS prüfen.** Akzeptanz: effektive Build-Einstellungen, Xcode-Version, Zielgerät/OS, vollständiges Build-Ergebnis und Abweichungen dokumentiert; ältere Build-Meldung nicht als neuen Test verwenden.
- [ ] **F01 – Profil-Prototyp durchgehend kennzeichnen.** Akzeptanz: Liste, Detail, Editor, Moderation und Einstieg erklären lokale Demo/fiktive Beispiele; kein Eindruck echter Nutzer, Vermittlung oder Nachrichten; selbst eingegebene Daten nicht pauschal als fiktiv ausgeben. Sichtprüfung dokumentiert.
- [ ] **F02 – Irreführende Einstellungen bereinigen.** Akzeptanz: Push/Sync nicht als verfügbare Funktionen bedienbar; Hintergrundmodi auf Notwendigkeit geprüft; lokale Speicherung verständlich erklärt. Entscheidung und Test dokumentiert.

## P1 – Offline-Lexikon in kleinen Schritten

- [ ] **L01 – Eintragsschema und Themenliste festlegen.** Akzeptanz: Schema nach ROADMAP, genau 15–20 geplante Titel und stabile IDs; Favoriten beziehen sich auf Lexikon-Einträge. Noch keine fachliche Freigabe behaupten.
- [ ] **L02 – Erste fünf Einträge recherchieren und prüfen.** Abhängigkeit: L01. Akzeptanz: fünf selbst formulierte Texte mit belastbaren, tatsächlich geöffneten Quellen, Abruf-/Prüfdatum, Prüfer und geklärten Nutzungsrechten; widersprüchliche Angaben aufgelöst oder benannt. Bei Zeitbedarf je Eintrag unterteilen.
- [ ] **L03 – Einträge 6–10 recherchieren und prüfen.** Abhängigkeit: L02. Akzeptanz: dieselben Kriterien wie L02, zehn geprüfte Einträge insgesamt.
- [ ] **L04 – Einträge 11–15 recherchieren und prüfen.** Abhängigkeit: L03. Akzeptanz: dieselben Kriterien wie L02, mindestens 15 geprüfte Einträge insgesamt.
- [ ] **L05 – Inhaltsfreigabe für 15–20 Einträge.** Abhängigkeit: L04. Akzeptanz: Endzahl festgehalten; optional 16–20 nach gleichen Kriterien; alle IDs eindeutig, alle Pflichtfelder vollständig, keine ungeprüften Platzhalter; fachliche und sprachliche Schlussprüfung mit Nachweis.
- [ ] **F03a – Lokales Lexikonmodell und Bundle-Daten einbinden.** Abhängigkeit: L01, V01. Akzeptanz: stabile IDs und Quellenfelder ladbar, Fehlerfall definiert; kein Download zum ersten Start nötig. Entwicklungsdaten klar als ungeprüft markieren.
- [ ] **F03b – Native Liste und Detailansicht ergänzen.** Abhängigkeit: F03a. Akzeptanz: sämtliche Einträge, vollständige Texte und Quellen offline lesbar; Lexikon gut erreichbar; Darstellungsfehler dokumentiert/behebbar.
- [ ] **F04 – Lexikonsuche ergänzen.** Abhängigkeit: F03b. Akzeptanz: Titel und Suchbegriffe durchsuchbar, Groß-/Kleinschreibung und Umlaute sinnvoll behandelt; leere Suche zeigt alle, kein Treffer verständlichen Hinweis; konkrete Suchfälle im Log.
- [ ] **F05a – Lokale Favoriten speichern.** Abhängigkeit: F03a. Akzeptanz: IDs lokal gespeichert; Hinzufügen/Entfernen ohne Duplikate; Zustand bleibt nach App-Neustart; unbekannte IDs führen nicht zum Absturz.
- [ ] **F05b – Favoritenansicht ergänzen.** Abhängigkeit: F05a, F03b. Akzeptanz: Merken/Entmerken aus Details, Liste aktualisiert sofort, leerer Zustand verständlich; Profil-Reset löscht Lexikon-Favoriten nicht unbeabsichtigt.

## P1 – Test und Datenschutzprüfung nach Umsetzung

- [ ] **Q01 – Reproduzierbare Testmatrix anlegen.** Abhängigkeit: V01, F01–F05b, L05. Akzeptanz: Fälle für Erststart im Flugmodus, 15–20 Einträge, Quellenanzeige, Suche (leer/Treffer/kein Treffer/Umlaute), Favoriten + Neustart, Demo/Reset und vorhandene Profilfunktionen; Soll-Ergebnis pro Fall. Eigenen nativen Testplan erstellen.
- [ ] **Q02 – Matrix auf Simulator und echtem Gerät durchführen.** Abhängigkeit: Q01. Akzeptanz: Build-Commit, Geräte/OS, Ist-Ergebnisse und Fehler erfasst; Offline-Funktionen auch nach Neustart geprüft. Fehlendes Gerät als Blockade dokumentieren.
- [ ] **Q03 – Bedienbarkeit und Fehlernachtest.** Abhängigkeit: Q02. Akzeptanz: große Schrift, VoiceOver, Hell/Dunkel und unterstützte Größen/Orientierungen geprüft; Abstürze, Datenverlust und irreführende Funktionsversprechen behoben und nachgetestet; Restrisiken ausdrücklich erfasst.
- [ ] **P01 – Tatsächliche Datenflüsse prüfen.** Abhängigkeit: Q03. Akzeptanz: lokale Profile, Favoriten, Einstellungen, Backups, externe Links, Berechtigungen, eingebundene SDKs und beobachteter Netzwerkverkehr inventarisiert; Abweichungen vom Offline-Ziel geklärt. „Kein Server“ allein gilt nicht als abgeschlossene Datenschutzprüfung.
- [ ] **P02 – Datenschutzhinweise und Anbieterangaben abgleichen.** Abhängigkeit: P01. Akzeptanz: Texte decken reale Speicherung, Löschung/Reset, Backup-Verhalten und Links ab; Verantwortlicher/Kontakt bestätigt; öffentliche Datenschutzadresse und In-App-Text stimmen überein; offene rechtliche Fragen vor Release geklärt.
- [ ] **P03 – Apple-Datenschutzangaben prüfen.** Abhängigkeit: P01, P02. Akzeptanz: aktuell geltende offizielle Apple-Vorgaben zum Prüfdatum recherchiert; App-Privacy-Angaben sowie gegebenenfalls Privacy Manifest/Required Reason APIs anhand realer App geprüft; Quellen/Datum/Ergebnis dokumentiert, keine pauschale „keine Daten“-Annahme.

## P2 – Store-Vorbereitung und Einreichung

- [ ] **A01 – Store-Unterlagen vorbereiten.** Abhängigkeit: Q03, P02, P03. Akzeptanz: Name/Beschreibung/Screenshots zeigen Lexikon-Nutzen und Demo ehrlich; Support-/Datenschutz-URLs erreichbar; Altersfreigabe, Inhaltsrechte und Review-Hinweise geprüft; keine echte Partnersuche versprochen.
- [ ] **A02 – Release-Kandidat freigeben.** Abhängigkeit: A01. Akzeptanz: Developer-Zugang, Signierung, Bundle-ID, Version/Build, Archive/Validierung und Gerätetest geprüft; aktuelle Review-Vorgaben nachgeschlagen; keine blockierenden Fehler; Release-Entscheidung des Verantwortlichen protokolliert. Zulassung nicht als sicher darstellen.
- [ ] **A03 – App-Store-Einreichung und Rückmeldung dokumentieren.** Abhängigkeit: A02. Akzeptanz: freigegebenen Build eingereicht; Datum/Build/Status erfasst; Rückfragen als neue Aufgaben. „Eingereicht“ bedeutet nicht „zugelassen“; Zulassung/Veröffentlichung erst nach Bestätigung vermerken.

## Später, ausdrücklich außerhalb V1

- [ ] **I01 – Erweiterungsideen bewerten:** Lernkarten, Querverweise, Übungsnotizen; Nutzen/Aufwand prüfen, keine implizite Zusage.
- [ ] **I02 – Echte Partnersuche separat planen:** Digitales schwarzes Brett ohne Chat/interne Kontaktanfragen; Konten, externe Kontaktdaten, Ablauf/Bestätigung, Moderation und Betrieb planen. Details: SERVER-TEST.md.

## Separater Server-Test – außerhalb Offline-V1

- [x] **S01 – Geschützten Lesetest einrichten.** Akzeptanz erfüllt laut Nutzerberichten vom 16.11.2026: drei fiktive Gesuche über HTTPS/PHP/MariaDB abrufbar; ohne Anmeldung HTTP 401. Belege/Grenzen in [SERVER-TEST.md](SERVER-TEST.md).
- [ ] **S02 – Server-Test reproduzierbar sichern.** Aktuelle `gesuche.php` ohne Zugangsdaten versionieren; Schema und Konfigurationsvorlage ohne Geheimnisse sichern; entfernte Testdateien, verschlüsselten Dateitransfer und GET mit/ohne Anmeldung prüfen. Akzeptanz: reproduzierbare Dateien und Prüfergebnisse vorhanden; keine Secrets im Diff.
- [ ] **S03 – Kleine native Leseansicht anbinden.** Abhängigkeit: S02, V01. Zugang zur Laufzeit eingeben (keine fest eingebauten Passwörter; dauerhafte Speicherung nur Keychain). Akzeptanz: drei Demo-Gesuche sichtbar; Laden, leeres Ergebnis, 401, 500 und fehlendes Netz verständlich behandelt; bestehende Offline-Funktionen unverändert.
- [ ] **S04 – Betriebsvoraussetzungen klären.** Akzeptanz: Datenbankversion, Backup/Restore, Hosting-/Mail-Limits und Verantwortlichkeit dokumentiert; keine öffentliche Freigabe vor separater Datenschutz-/Sicherheitsprüfung.
