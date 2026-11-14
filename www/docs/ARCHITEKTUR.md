> **Aktualisierung: SQLite ist jetzt angebunden.** Die bisherigen Beschreibungen unten dokumentieren teilweise die Vorgängerversion. Maßgeblich sind Speicherung, Start, Migration und Grenzen in [SQL-LOKAL.md](SQL-LOKAL.md).

# Architektur und Datenfluss

## Technik und Dateikarte

Buildloses HTML/CSS/JavaScript mit nativen ES-Modulen. Node.js dient ausschließlich als lokaler Dateiserver. Kein Framework, kein Bundler, keine externe Laufzeitbibliothek, keine API.

| Datei | Verantwortung |
|---|---|
| `index.html` | Layout, statische Abschnitte, Suche, Dialog und Container der Werkstatt; lädt app.js, workflow.js, moderation.js |
| `style.css` | Petrol/Sand/Grün, responsive Raster, Formulare, Fokus, Dialoge und Werkstatt |
| `profiles.js` | Acht Startprofile (IDs 1–8), exportiertes veränderliches Array und `filterProfiles` |
| `app.js` | Filter, Suchkarten, Profil-Dialog, simulierte Kontaktanfrage; reagiert auf `profiles-updated` |
| `workflow.js` | Eigenes Profil, Formular/Vorschau, Zustand, eigener lokaler Speicher, Verwaltungslink |
| `moderation.js` | Zusätzliche Beispieldaten, Betreiberansicht, Prüfentscheidungen, Statusfilter |
| `server.mjs` | Explizite URL-Allowlist, MIME-Typen, Loopback-Port 4173; keine Schreiboperationen/API |
| `profiles.test.js` | Sechs Node-Tests ausschließlich für Ausgangsprofile und Filter |
| `impressum.html`, `datenschutz.html` | Rechtstexte mit Grenzen und offenen Hosting-Angaben |
| `robots.txt` | Öffentliche Crawling-Hinweise; vom aktuellen lokalen Server nicht ausgeliefert |
| `package.json` | `npm start` und `npm test`; historische Paketversion 0.1.0 |

Neue JS-Dateien ausdrücklich zur Server-Allowlist hinzufügen. Unbekannte Pfade liefern 404; Fragmente werden nicht an den Server gesendet.

## Profilmodell

Suchprofile: `{id, name, city, styles: string[], role, level, goal, places: string[], time, bio}`.

Alle fünf Suchfilter werden mit UND verbunden. Ort = Wohnort (`city`), nicht Kursorte (`places`). Rollen sind exakte Werte; „Beides“ ist kein impliziter Joker. Erfahrung und Tanzziel sind unabhängig.

Die Werkstatt erfasst nur einen Tanzstil (`style`) und setzt mögliche Kursorte beim Einfügen in die Suche auf `[city]`. Die acht statischen Profile können mehrere Stile/Kursorte besitzen. Diese Asymmetrie ist der aktuelle Stand, keine allgemeine fachliche Vorgabe.

## Speicher und Identitäten

| localStorage-Schlüssel | Inhalt |
|---|---|
| `tanzpartner-local-profile-v02` | Ein Objekt `{number, token, status, data, note?}`; `data` enthält name, city, style, role, level, goal, time, bio |
| `tanzpartner-moderation-v02` | Array von `{id, status, note}` für die drei fest definierten Zusatzprofile; deren Inhalte kommen aus dem Code |

Eigene Suchprofil-ID: 1001. Betreiberansicht verwendet dafür die Kennung `own`. Weitere Profile: IDs 2001–2003 (Fenja, Enno, Kaja). Eigene Testnummer `TEST-…` ist eine Kennzeichnung, kein Geheimnis. Token entsteht mit `crypto.randomUUID()`.

Nur freigegebene Werkstattprofile werden dem gemeinsam importierten `profiles`-Array hinzugefügt. Synchronisierung entfernt zuvor das jeweilige eigene Element und fügt es ggf. erneut ein. Neuladen rekonstruiert alles aus den Ausgangsdaten plus lokal gespeichertem Zustand. Keine Synchronisierung zwischen Browsern, Geräten oder offenen Tabs implementiert.

## Zustände

| Aktion | Ergebnis |
|---|---|
| Eigenes Profil erstmalig oder geändert einreichen | `pending`; nicht in Suche, vorherige Freigabe entfällt, alter Rückstellungshinweis entfällt |
| Pending-Profil freigeben | `approved`; in Suche sichtbar |
| Pending-Profil mit nichtleerem Hinweis zurückstellen | `returned`; Hinweis sichtbar, nicht in Suche |
| Freigegebenes Profil pausieren | `paused`; nicht in Suche |
| Zurückgestelltes/pausiertes eigenes Profil erneut einreichen | `pending` |
| Zusätzliche Beispiele nach Rückstellung/Pause erneut einreichen | `pending`; Inhalte bleiben die vordefinierten Beispieldaten |
| Eigenes Profil löschen | Eigener Speichereintrag entfernt; Token-Zuordnung ebenfalls entfernt |
| Zusätzliche Testdaten entfernen | Nur Zusatzqueue geleert; eigenes Profil und acht Ausgangsprofile erhalten |

Es gibt keine Revisionserhaltung der bisher veröffentlichten Profilfassung. Die UI schützt Zustandswechsel für die Simulation, ist aber keine Sicherheitsgrenze.

## Ereignisse zwischen Modulen

Alle Ereignisse sind synchron auf `document`, nicht über Netzwerk:

- `profiles-updated`: workflow/moderation → app; Suche neu rendern.
- `own-profile-updated`, `detail = state oder null`: workflow → moderation; eigenes Profil in Queue aktualisieren.
- `request-own-profile`: moderation → workflow; Initialzustand anfordern, damit Lade-Reihenfolge abgefangen wird.
- `moderate-own-profile`, `detail = {status, note}`: moderation → workflow; Entscheidung für eigenes pending-Profil anwenden und speichern.

## Verwaltungslink

Format: `origin + pathname + #verwalten=<token>`. Token wird im localStorage im Klartext gehalten. Beim Öffnen wird nur verglichen und eine Meldung angezeigt; das Formular bleibt auch ohne Link erreichbar. Bei Austausch bleibt Profil erhalten, alter Token wird ersetzt. Bearbeiten/erneutes Einreichen behält Token. Bei Löschung entfällt Zuordnung. Keine Ablaufzeit, Rate-Limits, Mail-Wiederherstellung oder serverseitige Token-Verwaltung.

**Nicht als Authentifizierung wiederverwenden.** Auch ein als ungültig erkannter Link sperrt die lokale Werkstatt nicht.

## Darstellung und bekannte technische Grenzen

- Eigene Vorschau nutzt `textContent`; andere Ansichten HTML-Templates. `workflow.sync()` escaped die eigenen Daten vor Einfügen in das gemeinsame Sucharray. Betreiberkarten escapen separat die Rohdaten. Bei Refactoring auf doppelte Escapes und unsichere Interpolation achten.
- localStorage ist nicht vertrauenswürdig. Eigener Ladevalidator prüft nur Teile des Schemas, nicht alle optionalen Felder umfassend. Speicherfehler werden teilweise angezeigt; kein robustes Migrations-/Backupkonzept.
- Formularänderungen vor dem Einreichen sind nicht dauerhaft gespeichert. Keine Warnung vor Verlust ungesendeter Änderungen.
- Native Bestätigungsdialoge für Löschen und Linkaustausch. Clipboard kann scheitern; manueller Kopierhinweis vorgesehen.
- Kein produktives Sicherheitsreview. Keine automatisierten Ende-zu-Ende-Tests für Verwaltungsfunktionen.
- Node-Version 26 war bei früheren Prüfungen vorhanden; dokumentiertes Mindestziel 20 ist keine vollständig getestete Versionsmatrix.


## Ergänzung: SQLite-Experiment (14. November 2026)

`db.js`, `db-test.js` und `data.sqlite` wurden experimentell ergänzt. Sie sind **nicht an die Website angebunden**: Die Suche verwendet `profiles.js`, eigene Profile und Prüfstände bleiben im Browserspeicher. Ein anderer Browser übernimmt diese Daten nicht. SQLite könnte später hinter einer Server-API genutzt werden; dafür ist ein Wechsel zu MySQL nicht zwingend nötig. Keine Datenbankmigration beschlossen.

`npm test` prüft wieder die tatsächlich verwendete Filterfunktion (sechs Tests) und benötigt keine Zusatzpakete. Der getrennte Datenbanktest ist `npm run test:db` und benötigt vorher die Installation der Paketabhängigkeiten (`npm ci`). Sein Erfolg belegt keine Integration in die Website. Die Verbindung wartet jetzt auf die vollständige Tabellenerstellung und meldet Fehler direkt. `npm run test:db:integration` prüft Schreiben, erneutes Öffnen, dauerhafte Speicherung und Datenbankregeln in einer separaten temporären Datei. Die vorhandene data.sqlite bleibt dabei unverändert. Für einen Produktivbetrieb fehlen weiterhin versionierte Migrationen und eine abgesicherte Server-API.

Die SQLite-Datei und `.env` sind bereits in Git erfasst, trotz Ignore-Regel für `.env`. Keine echten Daten oder Zugangsdaten dort hinterlegen. Datenbank bei Fehlern **nicht löschen**; zunächst Kopie sichern und Ursache prüfen. Datenbank und Testskript werden vom lokalen Webserver nicht ausgeliefert.
