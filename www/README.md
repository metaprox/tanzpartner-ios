> **Aktualisierung: SQLite ist jetzt angebunden.** Die bisherigen Beschreibungen unten dokumentieren teilweise die Vorgängerversion. Maßgeblich sind Speicherung, Start, Migration und Grenzen in [SQL-LOKAL.md](docs/SQL-LOKAL.md).

# Tanzpartner Ostfriesland · lokale Version 0.2

Stand der Dokumentation: 14. November 2026.

Menschen aus Norden, Emden und Aurich zusammenbringen, die gemeinsam tanzen lernen, nach einer Pause wieder einsteigen oder Kenntnisse vertiefen möchten. **Keine Dating-App**, keine Kursvermittlung. Seriöse Gestaltung in Petrol, Sand und Grün.

## Aktueller Stand

- Version 0.1 wurde vom Nutzer bei manitu unter https://tanzpartner-ostfriesland.de veröffentlicht und erfolgreich getestet. Diese Angabe stammt aus dem Projektverlauf; sie ist kein erneuter Live-Abgleich.
- Version 0.2 bleibt lokal: eigenes Testprofil, Freigabe/Zurückstellung, Betreiberansicht, Verwaltungslink-Simulation.
- Referenzstand vor dieser Dokumentation: `e1736c5dfdf9187027e9fb695af28bae0b2c2f1f`, Branch `codex/tanzpartner-v0.2`; Nutzer bestätigte Commit und Push.
- `package.json` enthält historisch noch `0.1.0`; die Oberfläche bezeichnet den lokalen Entwicklungsstand als 0.2. Daraus keinen Deployment-Stand ableiten.
- Keine Build-Pipeline, keine automatische Veröffentlichung, keine Zusatzpakete für die Browser-Demo; die SQLite-Werkzeuge benötigen die Pakete aus package.json.

## Starten und testen

Node.js ab Version 20. Im Projektunterordner:

```sh
npm start
```

Öffnen: http://127.0.0.1:4173/ . Terminal offen lassen, zum Beenden Strg+C.

| Einstieg | Adresse |
|---|---|
| Suche | http://127.0.0.1:4173/#suche |
| Eigenes Testprofil | http://127.0.0.1:4173/#my-profile |
| Betreiberansicht | http://127.0.0.1:4173/#moderation |

Nicht `index.html` per Doppelklick öffnen: ES-Module benötigen hier einen Webserver. Der kleine Node-Server liefert Dateien aus; er implementiert weder API noch Datenbank. Er hört ausschließlich auf `127.0.0.1`, nicht im WLAN. Für mobile Darstellung Browserfenster verkleinern.

```sh
npm test
```

Sechs automatische Tests prüfen die ursprünglichen Profile und Filter. Für Verwaltungsfunktionen siehe [Testplan](docs/TESTPLAN.md).

## Was funktioniert?

- Acht fiktive Ausgangsprofile; fünf kombinierte Filter, Profilansicht, Kontakt-Simulation ohne Versand.
- Ein eigenes fiktives Profil pro Browser-Origin: anlegen, bearbeiten, pausieren, löschen.
- Einreichen führt zu `pending`; erst Freigabe macht das Profil lokal in der Suche sichtbar. Änderungen ziehen es bis zur erneuten Freigabe zurück.
- Betreiberansicht: eigenes Profil und drei zuschaltbare Beispiele, Statusfilter, Freigabe und Zurückstellung mit Pflicht-Hinweis.
- Persönlicher Link wird lokal erzeugt, kopiert, erkannt und ersetzt. Ein alter Link wird nach Austausch als ungültig angezeigt.

## Wichtige Grenzen

**Kein echtes Mitgliedersystem und keine Zugriffskontrolle.** Formulare und Betreiberansicht sind direkt erreichbar, auch ohne gültigen Verwaltungslink. Der Link ist eine Ablauf-Simulation, keine Autorisierung. Kein E-Mail-Versand, keine E-Mail-Bestätigung, keine Wiederherstellung per Mail, keine gemeinsame Datenbank.

Eigene Profile, Token und Prüfstände werden in `localStorage` gespeichert. Sie gelten nur für denselben Browser und denselben Origin (Protokoll, Host, Port). Keine Cookies, Analyse, externen Schriftarten oder Bildabrufe im Anwendungscode. Kontakt-Simulationen werden nicht dauerhaft gespeichert. Nur erfundene Profilangaben verwenden. Betreiberangaben in den Rechtstexten sind dagegen reale, zuvor vom Nutzer bereitgestellte Angaben.

Daten gezielt über „Testprofil löschen“ und „Zusätzliche Testdaten entfernen“ entfernen. Nicht pauschal den gesamten Browserspeicher löschen. Verwaltungslinks nicht in Fehlerberichte oder Git übernehmen.

## Weiterentwicklung und Übergabe

- [Sichere KI-Übergabe](docs/KI-UEBERGABE.md)
- [Architektur, Ereignisse, Datenmodell und Grenzen](docs/ARCHITEKTUR.md)
- [Manuelle Tests und erwartete Ergebnisse](docs/TESTPLAN.md)
- [Kurzer Wiedereinstieg](WEITERARBEIT.md)

## Hosting und Veröffentlichung

Die Online-Demo 0.1 wurde manuell über WebFTP hochgeladen. Ihr Upload umfasste `index.html`, `style.css`, `app.js`, `profiles.js`, `impressum.html`, `datenschutz.html`, `robots.txt`. Die gleichnamigen Dateien dieses Branches sind inzwischen teilweise Version 0.2 und kein unverändertes 0.1-Releasepaket.

**Diesen Entwicklungsordner nicht komplett hochladen.** Die neue Werkstatt enthält bewusst ungeschützte Betreiberfunktionen. Node-Server, Tests, Dokumentation, Git-Verzeichnis und Zugangsdaten gehören nicht in das öffentliche Webverzeichnis. Vor jeder Veröffentlichung separat prüfen und Nutzerfreigabe einholen.

Offen: genaue Protokollfelder und Aufbewahrungsfristen bei manitu. AV-Vertrag laut Nutzer abgeschlossen; IP-Ersetzung laut damaliger Hosting-Einstellung aktiviert. Rechtstexte sind keine bestätigte rechtliche Vollprüfung und müssen zum tatsächlichen Betrieb passen. `noindex` ist kein Zugriffsschutz.


## Ergänzung: SQLite-Experiment (14. November 2026)

`db.js`, `db-test.js` und `data.sqlite` wurden experimentell ergänzt. Sie sind **nicht an die Website angebunden**: Die Suche verwendet `profiles.js`, eigene Profile und Prüfstände bleiben im Browserspeicher. Ein anderer Browser übernimmt diese Daten nicht. SQLite könnte später hinter einer Server-API genutzt werden; dafür ist ein Wechsel zu MySQL nicht zwingend nötig. Keine Datenbankmigration beschlossen.

`npm test` prüft wieder die tatsächlich verwendete Filterfunktion (sechs Tests) und benötigt keine Zusatzpakete. Der getrennte Datenbanktest ist `npm run test:db` und benötigt vorher die Installation der Paketabhängigkeiten (`npm ci`). Sein Erfolg belegt keine Integration in die Website. Die Verbindung wartet jetzt auf die vollständige Tabellenerstellung und meldet Fehler direkt. `npm run test:db:integration` prüft Schreiben, erneutes Öffnen, dauerhafte Speicherung und Datenbankregeln in einer separaten temporären Datei. Die vorhandene data.sqlite bleibt dabei unverändert. Für einen Produktivbetrieb fehlen weiterhin versionierte Migrationen und eine abgesicherte Server-API.

Die SQLite-Datei und `.env` sind bereits in Git erfasst, trotz Ignore-Regel für `.env`. Keine echten Daten oder Zugangsdaten dort hinterlegen. Datenbank bei Fehlern **nicht löschen**; zunächst Kopie sichern und Ursache prüfen. Datenbank und Testskript werden vom lokalen Webserver nicht ausgeliefert.

## Nächste Entwicklungsetappen

Der [Plan für echten Mehrbenutzerbetrieb](docs/MEHRBENUTZER-PLAN.md) beschreibt getrennte Profile, sichere Verwaltungslinks, Betreiberanmeldung, Migration, Abnahmetests und Vorbereitung für Commit/Push. Diese Funktionen sind noch nicht implementiert.
