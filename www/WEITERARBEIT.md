> **Aktualisierung: SQLite ist jetzt angebunden.** Die bisherigen Beschreibungen unten dokumentieren teilweise die Vorgängerversion. Maßgeblich sind Speicherung, Start, Migration und Grenzen in [SQL-LOKAL.md](docs/SQL-LOKAL.md).

# Wiedereinstieg

Lokale Version 0.2, Zweig `codex/tanzpartner-v0.2`. Online bleibt nach zuletzt bestätigtem Stand Version 0.1. Referenz vor Dokumentationsübergabe: `e1736c5`.

Start im Projektordner: `npm start`, danach http://127.0.0.1:4173/#my-profile . Betreiberansicht: `/#moderation`.

Für eine weitere KI zuerst [KI-Übergabe](docs/KI-UEBERGABE.md) lesen und getrennten Worktree mit eigenem Port verwenden. [README](README.md), [Architektur](docs/ARCHITEKTUR.md) und [Testplan](docs/TESTPLAN.md) beschreiben Stand und Grenzen.

Profilablauf, Betreiberprüfung und Verwaltungslink sind lokale Simulationen. Nächste größere Entscheidung vor echten Mitgliedern: Drupal oder eigene Serveranwendung. Kein Umbau beschlossen. Offene Hostingfrage: Protokollfelder und Aufbewahrungsfristen bei manitu.


## Ergänzung: SQLite-Experiment (14. November 2026)

`db.js`, `db-test.js` und `data.sqlite` wurden experimentell ergänzt. Sie sind **nicht an die Website angebunden**: Die Suche verwendet `profiles.js`, eigene Profile und Prüfstände bleiben im Browserspeicher. Ein anderer Browser übernimmt diese Daten nicht. SQLite könnte später hinter einer Server-API genutzt werden; dafür ist ein Wechsel zu MySQL nicht zwingend nötig. Keine Datenbankmigration beschlossen.

`npm test` prüft wieder die tatsächlich verwendete Filterfunktion (sechs Tests) und benötigt keine Zusatzpakete. Der getrennte Datenbanktest ist `npm run test:db` und benötigt vorher die Installation der Paketabhängigkeiten (`npm ci`). Sein Erfolg belegt keine Integration in die Website. Die Verbindung wartet jetzt auf die vollständige Tabellenerstellung und meldet Fehler direkt. `npm run test:db:integration` prüft Schreiben, erneutes Öffnen, dauerhafte Speicherung und Datenbankregeln in einer separaten temporären Datei. Die vorhandene data.sqlite bleibt dabei unverändert. Für einen Produktivbetrieb fehlen weiterhin versionierte Migrationen und eine abgesicherte Server-API.

Die SQLite-Datei und `.env` sind bereits in Git erfasst, trotz Ignore-Regel für `.env`. Keine echten Daten oder Zugangsdaten dort hinterlegen. Datenbank bei Fehlern **nicht löschen**; zunächst Kopie sichern und Ursache prüfen. Datenbank und Testskript werden vom lokalen Webserver nicht ausgeliefert.

## Nächste Entwicklungsetappen

Der [Plan für echten Mehrbenutzerbetrieb](docs/MEHRBENUTZER-PLAN.md) beschreibt getrennte Profile, sichere Verwaltungslinks, Betreiberanmeldung, Migration, Abnahmetests und Vorbereitung für Commit/Push. Diese Funktionen sind noch nicht implementiert.
