# Nächste Schritte: Mehrbenutzerbetrieb

Stand: 14. November 2026. Dies ist ein Entwicklungsplan, keine bereits implementierte Funktion und keine Freigabe für Veröffentlichung.

## Ausgangspunkt

Die lokale SQLite-Anbindung funktioniert. Eingereichte Profile, Prüfstände, Hinweise und Verwaltungslink-Token liegen dauerhaft in data.sqlite. Browser-Neuladen und Serverneustart verlieren gespeicherte Daten nicht. Ungesendete Formulartexte, Suchfilter und simulierte Kontaktanfragen werden bewusst nicht gespeichert.

Der aktuelle app_state-Speicher hat nur EIN gemeinsames eigenes Testprofil. Die Betreiberansicht und die Zustands-API sind ohne Anmeldung zugänglich. Verwaltungslinks erkennen lediglich einen Token; sie beschränken keine Zugriffe. Mehrere Browser sind deshalb noch keine voneinander getrennten Mitglieder. Maßgeblicher Ist-Stand: [SQL-LOKAL.md](SQL-LOKAL.md).

## Etappe 1: Eigenständige Profile und Migration

- Ein Datensatz je Profil mit stabiler interner ID, öffentlicher Profilnummer, Profildaten, Status, Prüfhinweis, Zeitstempeln und Revision.
- Die bestehenden experimentellen Tabellen zuerst prüfen. Nicht ungeprüft wiederverwenden und nicht neben app_state eine zweite maßgebliche Datenquelle schaffen.
- Versionierte, transaktionale Migration aus app_state entwickeln; vorher Sicherung erstellen. Vorhandene Profile und Prüfstände erhalten. Doppelte Ausgangsprofile vermeiden. Migration muss wiederholbar geprüft werden; Rückweg dokumentieren.
- API und Formulare auf einzelne Profile umstellen. Öffentliche Suche liefert ausschließlich freigegebene Profile und keine internen Hinweise oder Token.
- Abnahme: Zwei getrennte Browser können unabhängig unterschiedliche Profile einreichen; Bearbeiten oder Löschen eines Profils verändert das andere nicht. Neustart erhält beide.

## Etappe 2: Sichere Verwaltung ohne Passwortkonto

- Kryptografisch zufälligen geheimen Verwaltungslink je Profil serverseitig erzeugen. Öffentliche Nummer allein verleiht niemals Rechte.
- Nur einen Hash des Tokens speichern. Geheimnis nicht in Protokolle, öffentliche API-Antworten oder Git übernehmen. Link sicher an die berechtigte Person übergeben; für reale Nutzung verifizierten Kontakt und Wiederherstellung festlegen.
- Lesen privater Profildaten, Ändern, Pausieren, Löschen und Linkaustausch auf dem Server autorisieren. Ein ungültiger Link darf nicht bloß eine Warnung anzeigen.
- Austausch/Widerruf des Links durchsetzen, Fehlversuche begrenzen und sichere Sitzungs-/CSRF-Handhabung passend zum gewählten Ablauf umsetzen.
- Abnahme: Link A kann ausschließlich Profil A verwalten. Ohne Link, mit falschem oder widerrufenem Link sind private Daten und Änderungen gesperrt, auch bei direkten API-Aufrufen.

## Etappe 3: Geschützte Betreiberansicht

- Betreiberanmeldung und serverseitige Rollenprüfung für die Prüfwarteschlange und sämtliche Entscheidungen einführen; Zugangsdaten nicht im Quelltext hinterlegen.
- Gültige Statuswechsel zentral prüfen. Rückstellung braucht Hinweis; geänderte Profile benötigen erneute Prüfung. Entscheiden, ob die vorherige freigegebene Fassung bis dahin sichtbar bleiben soll.
- Abnahme: Mitglieder können weder sich selbst freigeben noch andere Einreichungen oder interne Hinweise einsehen. Betreiber kann gezielt freigeben, zurückstellen und pausieren.

## Etappe 4: Verlässlicher Betrieb und Freigabe

- Serverseitige Feld-/Längenprüfung, sichere Textdarstellung, Konflikterkennung bei gleichzeitigen Änderungen und verständliche Speicherfehler testen.
- Sicherung und tatsächliche Wiederherstellung, Datenlöschung, Aufbewahrung und Zugriff auf Datenbankdateien festlegen. Mit zwei getrennten Browsersitzungen vollständige Ende-zu-Ende-Tests durchführen.
- Kontaktanfragen bleiben Simulation, bis Versand, Missbrauchsschutz und Umgang mit Kontaktdaten separat beauftragt und umgesetzt sind.
- Hosting klären: Der lokale Node-Server kann nicht einfach als statische Website zu manitu hochgeladen werden. Unterstützte Laufzeit bzw. passende Serverlösung vorab prüfen. SQLite ist für mehrere Mitglieder grundsätzlich geeignet; Schreiblast und Hosting bestimmen, ob später ein anderes Datenbanksystem nötig ist.
- Vor echten Mitgliedern HTTPS, Betriebskonzept und zum tatsächlichen Betrieb passende Datenschutzinformationen prüfen. Öffentliche Bereitstellung nur nach ausdrücklicher Nutzerfreigabe.

## Reihenfolge und Tests

Zuerst Datenmodell/Migration, danach profilbezogene Berechtigungen und Betreiberanmeldung; anschließend vollständige Abnahme. Bis alle Zugriffskontrollen umgesetzt sind ausschließlich lokal und mit fiktiven Daten arbeiten.

Bestehende Prüfungen weiterhin ausführen: `npm test`, `npm run test:db:integration`, `node --test api.test.js`. Diese belegen noch keinen sicheren Mehrbenutzerbetrieb. Für jede Etappe die oben genannten Negativ- und Funktionstests ergänzen.

## Commit und Push

Code, package-lock.json, Tests, Dokumentation und ausdrücklich die ausschließlich fiktive data.sqlite gehören in dieses private Repository. Nutzerentscheidung: Der Teststand soll zwischen mehreren Macs über Git mitgenommen werden. .env bleibt lokal und wurde nur aus dem Git-Index entfernt; die lokale Datei bleibt erhalten. Frühere Versionen bleiben in der Historie. Keine echten Mitgliederdaten oder produktiven Zugangsschlüssel in die versionierte Testdatenbank aufnehmen.

### Rechnerwechsel

1. Auf Mac A den lokalen Server mit Strg+C beenden, damit keine Schreibvorgänge mehr laufen.
2. Code, Dokumentation und data.sqlite gemeinsam committen und pushen.
3. Auf Mac B vor Änderungen pullen; anschließend bei geänderten Abhängigkeiten `npm ci`, dann `npm start`.
4. Vor dem Rückwechsel dieselbe Reihenfolge einhalten. Die Datenbank niemals auf beiden Macs parallel bearbeiten.

SQLite ist eine Binärdatei: Git kann gleichzeitige Datenbankänderungen nicht sinnvoll zusammenführen. Bei einem Konflikt beide Dateien separat sichern und bewusst einen Stand wählen bzw. Daten gezielt übertragen; nicht blind überschreiben. Git ist hier ein Transport für aufeinanderfolgende Tests, keine laufende Mehrbenutzer-Synchronisierung. Nur data.sqlite wird versioniert, nicht temporäre Journal-/WAL-Dateien oder Sicherungen.

Ein frischer Klon übernimmt die mitgeführte Testdatenbank. Fehlt die Datei, legt `npm start` sie neu an und befüllt sie mit acht fiktiven Startprofilen. Die bisherigen Browserdaten sind nur nach bestätigter Übernahme in SQLite auf dem anderen Rechner verfügbar.

Vorschlag für den Commit: `Lokale SQLite-Speicherung anbinden und Mehrbenutzer-Ausbau dokumentieren`. Vor Commit die Änderungsliste prüfen; Commit/Push ist keine Veröffentlichung bei manitu.
