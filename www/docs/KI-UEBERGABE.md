> **Aktualisierung: SQLite ist jetzt angebunden.** Die bisherigen Beschreibungen unten dokumentieren teilweise die Vorgängerversion. Maßgeblich sind Speicherung, Start, Migration und Grenzen in [SQL-LOKAL.md](SQL-LOKAL.md).

# Übergabe an eine weitere KI

## Auftrag und Produktidee

Eigentümer: Sven Schley. Privates Repository `metaprox/ki-web-labor`. Kommunikation auf Deutsch, verständlich und in kleinen Etappen. Der Nutzer möchte mit einer weiteren KI experimentieren, ohne den bisherigen Stand zu beschädigen. Diese Übergabe autorisiert keine neue Funktion oder Veröffentlichung von sich aus.

Der bisherige Prototyp und die Gestaltung gefallen dem Nutzer. Kein allgemeines Redesign und keine vorsorgliche CMS-Migration. Gewünschter späterer Ablauf: Profil einreichen → Betreiber prüft → Freigabe → Mitglied verwaltet über persönlichen geheimen Link, möglichst ohne Passwortkonto. Eine öffentliche Profilnummer allein darf keine Rechte verleihen.

Aktuell sind alle diese Abläufe lokal simuliert. Die technische Grundlage für echte Mitglieder ist offen. Drupal wurde wegen früherer Erfahrung des Nutzers diskutiert, aber nicht ausgewählt. Eine eigene Serveranwendung ist ebenfalls nur eine Option.

## Referenz und Arbeitsschutz

Geprüfter Ausgangscommit: `e1736c5dfdf9187027e9fb695af28bae0b2c2f1f` (13.11.2026). Diese Dokumentation kommt danach hinzu. Vor Arbeitsbeginn Status und Verlauf neu lesen, denn der Branch kann weiterentwickelt worden sein.

Empfehlung: eigener Worktree außerhalb des bestehenden Projektordners. Beispielbefehle vom Repository-Hauptordner aus; Namen nur verwenden, wenn sie noch frei sind:

```sh
git status --short --branch
git log -5 --oneline
git worktree list
# Erst nach Sicherung/Commit der gewünschten Ausgangsfassung:
git worktree add -b experiment/zweite-ki ../ki-web-labor-zweite-ki codex/tanzpartner-v0.2
```

Dann **ausschließlich `../ki-web-labor-zweite-ki` als Arbeitsordner der anderen KI öffnen**. Der Worktree besitzt eigene Dateien und einen eigenen Branch, teilt aber die Git-Verwaltung. Er schützt nicht gegen absichtlich destruktive Git-Befehle. Keine Änderungen im ursprünglichen Ordner, kein Force-Push, Reset/Clean oder eigenmächtiger Merge. Bei höherem Isolationsbedarf eine eigenständige Kopie/Klon außerhalb des Originalordners verwenden.

Der Worktree entsteht aus einem Commit, nicht aus uncommitteten Änderungen. Deshalb zuerst die Dokumentation committen, wenn die neue KI sie beim Anlegen bereits erhalten soll. Keinen bestehenden Experimentordner überschreiben.

## Browserdaten und Server ebenfalls trennen

Zwei Arbeitsordner auf `http://127.0.0.1:4173` teilen denselben lokalen Browserspeicher. Ein Branch trennt diesen nicht!

Im **Experiment-Worktree** kann die KI die feste Portnummer in `server.mjs` von 4173 auf beispielsweise 4174 ändern, einschließlich Konsolenausgabe. Danach `npm start` dort und http://127.0.0.1:4174 öffnen. Loopback-Bindung beibehalten. Der bestehende Server auf 4173 bleibt unberührt. Verwaltungslinks sind originabhängig und nicht zwischen den Ports übertragbar. Alternativ zusätzlich ein separates Browserprofil verwenden.

## Arbeitsweise

1. AGENTS.md, README, Architektur und Testplan lesen.
2. Konkreten Experimentauftrag des Nutzers festhalten; offene Fragen nicht stillschweigend entscheiden.
3. Unveränderte Ausgangsfassung mit `npm test` prüfen und eigenes Experiment getrennt starten.
4. Kleine Änderungen, ausschließlich fiktive Daten; relevante Browserabläufe testen.
5. Ergebnis mit geänderten Dateien, Testnachweisen, Grenzen und Rückweg dokumentieren.
6. Eigene Commits auf dem Experimentbranch. Push nur entsprechend dem Nutzerauftrag; keine Hosting-Veröffentlichung.
7. Übernahme zurück in den bisherigen Entwicklungszweig erst nach Review und Entscheidung des Nutzers. Zum Verwerfen genügt zunächst, den ursprünglichen Worktree weiterzuverwenden; nichts muss sofort gelöscht werden.

## Nächste fachliche Entscheidung

Vor realen Mitgliedern entscheiden: CMS oder eigene Serveranwendung? Dafür Speicherung, sichere Token-Prüfung und Widerruf auf dem Server, Betreiberanmeldung, E-Mail-Bestätigung und Wiederherstellung, Validierung, Missbrauchsschutz, Backups und Datenlöschung planen. Nicht einfach die lokale Werkstatt als fertiges Backend behandeln.

Keine realen Zugangsdaten für das Verständnis erforderlich. Hosting-Zugang, private E-Mails, Chatverlauf und Browserdaten nicht anfordern oder in Dokumentation kopieren.


## Ergänzung: SQLite-Experiment (14. November 2026)

`db.js`, `db-test.js` und `data.sqlite` wurden experimentell ergänzt. Sie sind **nicht an die Website angebunden**: Die Suche verwendet `profiles.js`, eigene Profile und Prüfstände bleiben im Browserspeicher. Ein anderer Browser übernimmt diese Daten nicht. SQLite könnte später hinter einer Server-API genutzt werden; dafür ist ein Wechsel zu MySQL nicht zwingend nötig. Keine Datenbankmigration beschlossen.

`npm test` prüft wieder die tatsächlich verwendete Filterfunktion (sechs Tests) und benötigt keine Zusatzpakete. Der getrennte Datenbanktest ist `npm run test:db` und benötigt vorher die Installation der Paketabhängigkeiten (`npm ci`). Sein Erfolg belegt keine Integration in die Website. Die Verbindung wartet jetzt auf die vollständige Tabellenerstellung und meldet Fehler direkt. `npm run test:db:integration` prüft Schreiben, erneutes Öffnen, dauerhafte Speicherung und Datenbankregeln in einer separaten temporären Datei. Die vorhandene data.sqlite bleibt dabei unverändert. Für einen Produktivbetrieb fehlen weiterhin versionierte Migrationen und eine abgesicherte Server-API.

Die SQLite-Datei und `.env` sind bereits in Git erfasst, trotz Ignore-Regel für `.env`. Keine echten Daten oder Zugangsdaten dort hinterlegen. Datenbank bei Fehlern **nicht löschen**; zunächst Kopie sichern und Ursache prüfen. Datenbank und Testskript werden vom lokalen Webserver nicht ausgeliefert.

## Nächste Entwicklungsetappen

Der [Plan für echten Mehrbenutzerbetrieb](MEHRBENUTZER-PLAN.md) beschreibt getrennte Profile, sichere Verwaltungslinks, Betreiberanmeldung, Migration, Abnahmetests und Vorbereitung für Commit/Push. Diese Funktionen sind noch nicht implementiert.
