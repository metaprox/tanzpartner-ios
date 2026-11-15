# KI-Leitfaden

## Start in jeder Sitzung

1. Branch, letzten Commit und `git status` prüfen; bestehende Änderungen erhalten.
2. Diesen Leitfaden und [ARBEITSLOG.md](ARBEITSLOG.md) lesen, dann eine Aufgabe aus [TODO.md](TODO.md) wählen. [ROADMAP.md](ROADMAP.md) nur für Scope/Stand, betroffene Code-Dateien gezielt lesen. Nicht das ganze Repository einlesen.
3. Eine kleine Aufgabe bearbeiten (ca. 15–45 Minuten); größere Aufgaben aufteilen. Keine Funktionen außerhalb V1 ohne Auftrag ergänzen.
4. Passend zur Änderung prüfen. Checkbox nur bei erfüllten Akzeptanzkriterien mit Nachweis setzen; nicht ausgeführte Tests ausdrücklich benennen.
5. Arbeitslog knapp aktualisieren: Ergebnis, Prüfnachweis, Blockade, nächster Schritt, Git-Status. Erledigte Detailhistorie entfernen, wichtige Entscheidungen bewahren. Commit/Push übernimmt derzeit der Nutzer über GitHub Desktop.

## Technische Orientierung

Alle folgenden Dateien liegen in `TanzpartnerOstfrieslandiOS/`:

| Datei | Verantwortung |
|---|---|
| `App.swift`, `ContentView.swift` | Gemeinsamer ProfileStore, Theme, drei Tabs |
| `Models.swift` | Profile/Moderationsstatus, gemeinsame Auswahlwerte, toleranter Decoder |
| `ProfileStore.swift` | JSON laden/speichern, CRUD, acht Seed-Profile, Demo-Reset |
| `ProfileListView.swift` | Profilsuche/Filter, Editor; Liste zeigt nur freigegebene Profile |
| `ProfileDetailView.swift` | Details, Bearbeiten, lokale Kontakt-Simulation |
| `ModerationView.swift` | Statusfilter, Sortierung, Bearbeitung |
| `SettingsView.swift` | Theme, lokale Schalter, Reset, Datenschutz/Impressum |
| `Info.plist` | App-Konfiguration; Hintergrundmodi vor Release prüfen |

Persistenz: `Documents/profiles.json` und `UserDefaults`. Neue Modellfelder optional oder mit Decoder-Default; bei inkompatiblen Änderungen Migration vorsehen. Den gemeinsamen Store nutzen, keine parallele Profil-Datenhaltung einführen. Speichern/Neustart und Bestandserhalt bei Persistenzänderungen testen.

Code und reproduzierbare Tests belegen den Ist-Stand; Roadmap beschreibt den Plan. Widersprüche protokollieren. Keine Build-Erfolge, Quellenprüfungen oder Veröffentlichungen ohne Nachweis behaupten. Keine Zugangsdaten oder privaten Testdaten dokumentieren; keine kostenpflichtigen oder modellspezifischen Werkzeuge voraussetzen.
