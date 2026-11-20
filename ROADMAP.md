# Roadmap – erste Store-Version

## Ziel

Eine **unabhängige, regionale Tanzpartner-Börse für Ostfriesland** im öffentlichen App Store. Anlass: Tanzwillige finden in Ostfriesland schwer einen Tanzpartner, und Tanzschulen bieten selbst keine Vermittlung an. Hobbyprojekt ohne finanzielle Interessen. Ein öffentlicher Store-Eintrag ist nötig, weil Laien eine Zusatz-App wie TestFlight kaum installieren. Bis dahin wird die App auf dem eigenen iPhone/iPad vorgeführt.

Die Store-Version muss eine **echte, vollständige App** sein. Eine Demo mit fiktiven Profilen reicht nicht (siehe Apple-Anforderungen).

## Entscheidungen (Nutzer, 20.11.2026)

| Thema | Entscheidung |
|---|---|
| Zielgruppe | Tanzwillige direkt; Tanzschulen haben kein Interesse an Vermittlung. Kontakte zu zwei Tanzschulen bestehen (z. B. für Bekanntmachung). |
| Region | Nur Ostfriesland. Orte als Daten pflegen, nicht fest im Code. |
| Konten | **Keine Benutzerkonten.** Ein Gesuch wird per E-Mail-Link bestätigt und lässt sich darüber verlängern oder löschen. |
| Kontakt | Kontaktformular in der App; der Server leitet die Nachricht per E-Mail weiter, die Adresse des Gesuchs bleibt verborgen. **Kein Chat.** Die weitere Kommunikation läuft direkt per E-Mail außerhalb der App. Ersetzt die frühere Formulierung „kein internes Kontaktanfrage-System, Kontakt über freigegebene Kontaktdaten“. |
| Moderation | Gesuche erscheinen erst nach Freigabe durch den Betreiber. Moderation über eine geschützte Admin-Webseite, nicht in der öffentlichen App. |
| Betreiber | Nutzer als Privatperson; nicht gewerblich. |
| Lexikon | Später als zusätzlicher Mehrwert, nicht Teil der ersten Store-Version. |
| Präsentation bis zum Store | Eigenes iPhone/iPad (Notlösung). |
| Mindestalter (K01) | 18 Jahre für Gesuche und Kontaktaufnahme, per Bestätigung beim Absenden. |
| Laufzeit (K01) | 30 Tage; danach Verlängerung per Mail-Link. |
| Felder eines Gesuchs (K01) | Pflicht: Anzeigename, Ort, Tanzstile, Rolle. Optional: Erfahrung, Ziel, mögliche Tanzorte, Zeiten, Freitext. Kein Foto, keine Kontaktdaten im sichtbaren Text. Die E-Mail-Adresse wird erfasst, aber nie angezeigt. |
| Absender (K01) | Antwortadresse `kontakt@tanzpartner-ostfriesland.de` (Alias); Versand über ein eigenes Postfach per SMTP (SSL, Port 465, mit Anmeldung) – im Test 20.11. zugestellt, `mail()` landete im Spam. Höchstens 100 Mails/Stunde. |

## Offene Punkte

- **Feldlängen, erlaubte Werte, Fristen, Begrenzungen:** in K02 festgelegt (20.11.), siehe [docs/K02-DATENMODELL-API.md](docs/K02-DATENMODELL-API.md).
- **Betrieb:** MariaDB-Version, Backup/Restore und Cronjobs beim Hoster (Rest von S04).

## Erste Store-Version – Umfang

**App:** Freigegebene Gesuche laden, suchen, filtern, Details ansehen; Gesuch aufgeben (mit Altersbestätigung und Datenschutzhinweis); Kontaktformular; Gesuch melden; Datenschutz/Impressum; verständliche Lade-, Leer- und Fehlerzustände.

**Server:** Öffentliche Leseschnittstelle nur für freigegebene, nicht abgelaufene Gesuche; Annahme von Gesuchen, Kontaktanfragen und Meldungen mit Prüfung der Eingaben und Schutz gegen Spam und Massenanfragen; Mails für Bestätigung, Weiterleitung und Erinnerung vor dem Ablauf; Verlängern/Löschen per Link; Sperrliste für E-Mail-Adressen; geschützte Admin-Webseite (freigeben, ablehnen, Meldungen bearbeiten, sperren).

**Entfällt in der Store-Version:** fiktive Beispielprofile, lokale Profilspeicherung, Kontakt-Simulation, Moderations-Tab, Push-/Sync-Schalter, Hintergrundmodi, Debug-Tab „Online-Test“.

**Ausdrücklich nicht in der ersten Version:** Konten, Chat, Fotos, Push, Bezahlung, andere Regionen, Lexikon.

## Apple-Anforderungen (gelesen am 20.11.2026)

Quellen: [App Review Guidelines](https://developer.apple.com/app-store/review/guidelines/) und [Unlisted App Distribution](https://developer.apple.com/support/unlisted-app-distribution/). Die Abschnitte 1.2, 2.1 und 2.2 wurden im Wortlaut gelesen; 4.2, 4.3(b) und 5.1.1(v) nur als Zusammenfassung. Vor der Einreichung erneut prüfen (P03, A02).

- **2.2:** Demos, Betas und Probeversionen gehören nicht in den App Store, dafür ist TestFlight vorgesehen.
- **2.1:** Keine Platzhalter oder vorläufigen Inhalte. Server muss während der Prüfung laufen; Apple braucht nötige Testhinweise.
- **1.2 (Inhalte von Nutzern):** Filter gegen anstößige Inhalte, Meldefunktion mit zeitnaher Reaktion, Sperren missbräuchlicher Nutzer, veröffentlichte Kontaktmöglichkeit.
- **4.3(b), laut Zusammenfassung:** Neue Dating-Apps nur mit deutlichem Unterschied. Deshalb klar als regionale Tanzpartner-Börse für Kurse und Übung auftreten, nicht als Dating.
- **5.1.1(v):** Wer Konten anbietet, muss Kontolöschung in der App ermöglichen. Entfällt bei der Entscheidung ohne Konten, Löschen eines Gesuchs per Link bleibt nötig.
- **Unlisted Distribution:** Ebenfalls mit Prüfung und ohne Beta/Vorabstand; für dieses Ziel nicht nötig.

Das ist keine Rechtsberatung. Impressum und Datenschutz gelten auch für ein Hobbyprojekt, sobald fremde Personen Daten eingeben.

## Reihenfolge

1. **Konzept (K01–K03):** offene Entscheidungen, Datenmodell und API-Vertrag, Abläufe und Texte.
2. **Server (S04, B01–B08):** Betriebsvoraussetzungen, Schema, Schnittstellen, Mails, Admin-Webseite, Sicherheitsprüfung. Der Server-Test (S01–S03) ist die technische Grundlage.
3. **App (F10–F15):** Anbindung, Formulare, Altlasten entfernen.
4. **Test (Q01–Q03):** Simulator und echtes Gerät, Fehlerfälle, Bedienbarkeit.
5. **Datenschutz/Recht (P01–P03):** reale Datenflüsse, Texte, Apple-Angaben.
6. **Store (A01–A03):** Unterlagen, Release-Kandidat, Einreichung. Einreichung ist keine zugesagte Zulassung.

Aufgaben und Akzeptanzkriterien ausschließlich in [TODO.md](TODO.md); aktuelle Übergabe in [ARBEITSLOG.md](ARBEITSLOG.md); Serverumgebung in [SERVER-TEST.md](SERVER-TEST.md).

## Geprüfter Stand – 20.11.2026

Basis-Commit `1f5ad60`. Simulator-Build Debug und Release mit Xcode 27.2 erfolgreich (Claude, 20.11.). Am iPhone (iOS 27.2.1) vom Nutzer bestätigt: App läuft, Online-Test lädt Daten aus der MariaDB.

| Befund | Beleg (unter `TanzpartnerOstfrieslandiOS/`) |
|---|---|
| Lokale Profile mit acht fiktiven Beispielen, JSON-Speicherung, Suche/Filter, Detail, Kontakt-Simulation, Moderation | `ProfileStore.swift`, `ProfileListView.swift`, `ProfileDetailView.swift`, `ModerationView.swift` |
| Push-/Sync-Schalter ohne Funktion; Hintergrundmodi `fetch`/`remote-notification` ungenutzt | `SettingsView.swift`, `Info.plist` |
| `UIRequiredDeviceCapabilities = armv7` veraltet; Projektwert Mindest-iOS 16.0, Code benötigt iOS 17 | `Info.plist`, `project.pbxproj` |
| Online-Abruf über HTTPS mit flüchtigem Zugang, nur im Debug-Build | `OnlineTestView.swift` |
| Kein Testziel (Unit-Tests) vorhanden | Projektdatei |

Wiederverwendbar für die Store-Version: Listen-, Filter- und Detailansichten sowie Auswahlwerte (`Models.swift`). Die lokale Profildatenhaltung wird durch die Server-Anbindung ersetzt.

## Später

- **I01 – Mehrwert für Nutzer:** Tanzlexikon oder eine Übersicht „Wo kann ich in Ostfriesland tanzen?“ (Tanzschulen, Tanzabende, Kurstermine mit Links). Nutzen und Aufwand vergleichen.
- **Inhaltsstandard für ein Lexikon:** pro Eintrag stabile ID, Titel, Kategorie, Suchbegriffe, Kurzbeschreibung, Fachtext, Quellen mit Herausgeber/Titel/URL/Abrufdatum, Prüfstatus/-datum und Prüfer. Quellen tatsächlich lesen; keine ungeprüften KI-Texte oder fremden Medien ohne geklärte Rechte.
