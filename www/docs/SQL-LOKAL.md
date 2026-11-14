# Lokale SQLite-Werkstatt

Stand: 14. November 2026. Dieser Text ersetzt frühere Aussagen zur ausschließlichen Browser-Speicherung.

## Start

Im Projektordner einmal `npm ci`, dann `npm start`. Einen älteren lokalen Server vorher mit Strg+C beenden. Adresse: http://127.0.0.1:4173. Nur Loopback, keine Veröffentlichung.

## Speicherung

`data.sqlite` ist die maßgebliche Datei. Die neue Tabelle `app_state` enthält JSON-Dokumente mit Revisionsnummer: `base-profiles` (acht vollständige Startprofile), `tanzpartner-local-profile-v02` (vollständiges eigenes Testprofil, Prüfstatus, Hinweis und Verwaltungslink-Token), `tanzpartner-moderation-v02` (zusätzliche Testprofile und Prüfstände). Bestehende experimentelle Tabellen `profiles` und `moderation_queue` bleiben unangetastet; sie sind nicht die Datenquelle der Oberfläche. Neue Startprofile werden einmalig aus profiles.js übernommen. Keine stille Löschung alter SQL-Daten.

Die Werkstatt verwaltet weiterhin EIN gemeinsames eigenes Testprofil, nicht mehrere echte Mitglieder. Alle Browser am selben lokalen Server sehen nach Neuladen denselben Stand. Formulareingaben werden erst beim Einreichen gespeichert. Suchfilter, ungesendete Formulartexte und ausdrücklich simulierte Kontaktanfragen bleiben flüchtig. Kein Nachrichtenversand.

Browserdaten werden beim ersten Öffnen zur Übernahme angeboten, wenn der zugehörige SQL-Eintrag noch nie gespeichert wurde. Die alte Browserkopie bleibt als Sicherung erhalten, wird aber nicht mehr aktualisiert. Nach SQL-Löschung verhindert die Revisionsnummer ein erneutes automatisches Importangebot. Andere Browserstände werden nicht über bestehende SQL-Daten geschrieben.

## Schnittstelle und Grenzen

GET /api/profiles; GET/PUT /api/state/<Schlüssel>. Parametrisierte SQL-Abfragen, Größenbegrenzung und Zustandsprüfung. Revisionen verhindern stilles Überschreiben aus veralteten Fenstern (409: neu laden). Schreibfehler werden angezeigt, keine erfolgreiche Speicherung vorgetäuscht. Host-/Origin-Prüfung und Bindung an Loopback. Kein automatischer Live-Abgleich offener Fenster.

Die Betreiberansicht bleibt bewusst OHNE Anmeldung. Verwaltungslinks sind weiterhin Simulation, keine Berechtigungsprüfung. Ausschließlich fiktive Daten; diese lokale API niemals öffentlich betreiben. Keine produktiven Daten oder Token hochladen. Ausnahme für dieses private Repository: Die ausschließlich fiktive Testdatenbank wird auf ausdrücklichen Nutzerwunsch zwischen Macs versioniert; siehe Mehrbenutzer-Plan. Vor Sicherung Server beenden und Datei kopieren. Node-Backend ist nicht automatisch auf dem manitu-Webspace lauffähig.

## Tests

`npm test`: Suchfilter. `npm run test:db:integration`: isolierte SQLite-Schreibtests. `node --test api.test.js`: echte HTTP-Anfragen an separaten Server mit temporärer Datenbank, Neustart, Konflikt- und Zugriffskontrollen. `npm run test:db`: prüft die ältere Profiltabelle, nicht den aktuellen app_state-Bestand.

Manuell: Browserdaten ggf. übernehmen, Testprofil einreichen, freigeben, anderen Browser öffnen, Profil/Status prüfen; Server neu starten und erneut prüfen. Danach bearbeiten, zurückstellen, pausieren, Link ersetzen und löschen. Nur eigene fiktive Tests löschen.

## Nächste Entwicklungsetappen

Der [Plan für echten Mehrbenutzerbetrieb](MEHRBENUTZER-PLAN.md) beschreibt getrennte Profile, sichere Verwaltungslinks, Betreiberanmeldung, Migration, Abnahmetests und Vorbereitung für Commit/Push. Diese Funktionen sind noch nicht implementiert.
