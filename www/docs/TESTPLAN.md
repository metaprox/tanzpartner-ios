> **Aktualisierung: SQLite ist jetzt angebunden.** Die bisherigen Beschreibungen unten dokumentieren teilweise die Vorgängerversion. Maßgeblich sind Speicherung, Start, Migration und Grenzen in [SQL-LOKAL.md](SQL-LOKAL.md).

# Testplan

Nur fiktive Daten. Experimente auf separatem Port/Browserprofil. Bestandstests wurden im bisherigen Projektverlauf erfolgreich ausgeführt; diese Dokumentationsänderung ist kein erneuter vollständiger UI-Test.

## Automatisch

Im Projektunterordner `npm test`. Erwartet: 6 erfolgreiche Tests, keine Fehlschläge. Geprüft werden Ausgangsprofil-IDs/Orte, gemeinsame Filter, Nulltreffer, Erfahrung/Ziel, leere Filter und Wohnort/Kursort. Nicht abgedeckt: DOM, Speicher, Token, Moderation, Sicherheit, echtes Hosting.

## Basis-Suche

1. Frischer Origin ohne gespeicherte Werkstattprofile: 8 Treffer.
2. Norden + Ersten Kurs beginnen: Mara und Timo.
3. Zusätzlich Standard / Latein + Folgend + Ohne Vorkenntnisse: Mara.
4. Emden + Tango Argentino: Leerzustand. Zurücksetzen stellt Ausgangsmenge wieder her.
5. Profil öffnen, Kontakt simulieren: explizit kein Versand. Schließen über Schaltfläche und Escape.

Bei vorhandenen freigegebenen Testprofilen steigt die Ausgangsmenge entsprechend. Nicht blind von acht Treffern ausgehen.

## Eigenes Profil

1. `/#my-profile`: Beispiel ausfüllen, Vorschau und Pflichtfelder prüfen. Leere/Leerzeichen-Eingaben nicht akzeptieren.
2. Einreichen → pending, Testnummer und Verwaltungslink; noch kein zusätzliches Suchprofil.
3. Betreiberansicht: eigenes Profil prüfen und freigeben → genau ein zusätzlicher Treffer.
4. Neuladen: Profil, Zustand und Link erhalten.
5. Text ändern und einreichen → pending, zusätzlicher Treffer verschwindet bis zur erneuten Freigabe.
6. Zurückstellen ohne Hinweis verhindern; mit Hinweis → returned, Hinweis erscheint am eigenen Formular.
7. Erneut einreichen → Hinweis entfällt, pending; Freigabe → sichtbar.
8. Pausieren → nicht sichtbar. Erneutes Einreichen/Freigeben möglich.
9. Eigenes Testprofil löschen, Bestätigung zuerst abbrechen: erhalten. Danach bestätigen: Profil, Speicherzuordnung und zusätzlicher Treffer entfernt. Nur selbst angelegte Testdaten entfernen.

## Zusatzqueue

1. Drei Testeinreichungen ergänzen → genau drei, erneutes Hinzufügen ohne Duplikate.
2. Fenja freigeben → in Suche; Enno mit Hinweis zurückstellen → nicht in Suche; Kaja pending.
3. Jeden Statusfilter prüfen; Zähler und leere Auswahl korrekt. Details zeigen vollständiges Profil.
4. Neuladen → Entscheidungen und Hinweise erhalten.
5. Zurückgestelltes Beispiel erneut einreichen; freigegebenes pausieren.
6. Zusatzdaten entfernen → eigenes Profil und acht Ausgangsprofile bleiben erhalten.

## Verwaltungslink

1. Link kopieren und im selben Browser öffnen → „erkannt“, Formular sichtbar.
2. Neuladen → weiterhin erkannt. Profiländerung behält Link.
3. Link ersetzen zunächst abbrechen → unverändert. Bestätigen → neuer Link; alter Link zeigt ungültig, neuer erkannt.
4. Zufälliger falscher Link → verständlicher Fehler; keine Behauptung echter Zugriffssperre.
5. Anderer Port/Browser ohne Zustand → nicht erkannt; keine angebliche E-Mail-Wiederherstellung.
6. Nach Profil-Löschung ist vorheriger Link ungültig. Links nicht in Testberichte kopieren.

## Robustheit und Bedienbarkeit

- Breiten etwa 390 und 1280 Pixel, kein horizontaler Überlauf; lange Vorstellung und langer Hinweis.
- Tastatur: Labels, sichtbarer Fokus, Details, Dialogschließen und Statusmeldungen.
- Erfundener Text mit `&`, `<`, `>`, Anführungszeichen: als Text sichtbar, kein HTML ausgeführt, auch im Dialog und nach Neuladen.
- Speicher deaktiviert/ungültig: kein vollständiger Absturz; Fehlerhinweise prüfen. Bestehende Daten nicht für Tests ungefragt löschen.
- Keine ausgehenden Kontaktanfragen oder externen Tracking-/Asset-Abrufe.

## Ergebnis dokumentieren

Commit/Branch, Browser, verwendeter Origin, geprüfte Fälle und Ergebnis festhalten. Nicht getestete Punkte ausdrücklich nennen. Ein erfolgreicher manueller Durchlauf ist kein Nachweis von Produktionssicherheit oder Rechtskonformität.


## Ergänzung: SQLite-Experiment (14. November 2026)

`db.js`, `db-test.js` und `data.sqlite` wurden experimentell ergänzt. Sie sind **nicht an die Website angebunden**: Die Suche verwendet `profiles.js`, eigene Profile und Prüfstände bleiben im Browserspeicher. Ein anderer Browser übernimmt diese Daten nicht. SQLite könnte später hinter einer Server-API genutzt werden; dafür ist ein Wechsel zu MySQL nicht zwingend nötig. Keine Datenbankmigration beschlossen.

`npm test` prüft wieder die tatsächlich verwendete Filterfunktion (sechs Tests) und benötigt keine Zusatzpakete. Der getrennte Datenbanktest ist `npm run test:db` und benötigt vorher die Installation der Paketabhängigkeiten (`npm ci`). Sein Erfolg belegt keine Integration in die Website. Die Verbindung wartet jetzt auf die vollständige Tabellenerstellung und meldet Fehler direkt. `npm run test:db:integration` prüft Schreiben, erneutes Öffnen, dauerhafte Speicherung und Datenbankregeln in einer separaten temporären Datei. Die vorhandene data.sqlite bleibt dabei unverändert. Für einen Produktivbetrieb fehlen weiterhin versionierte Migrationen und eine abgesicherte Server-API.

Die SQLite-Datei und `.env` sind bereits in Git erfasst, trotz Ignore-Regel für `.env`. Keine echten Daten oder Zugangsdaten dort hinterlegen. Datenbank bei Fehlern **nicht löschen**; zunächst Kopie sichern und Ursache prüfen. Datenbank und Testskript werden vom lokalen Webserver nicht ausgeliefert.
