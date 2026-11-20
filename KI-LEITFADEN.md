# KI-Leitfaden

## Start in jeder Sitzung

1. Branch, letzten Commit und `git status` prüfen; bestehende Änderungen erhalten.
2. Diesen Leitfaden und [ARBEITSLOG.md](ARBEITSLOG.md) lesen, dann eine Aufgabe aus [TODO.md](TODO.md) wählen. [ROADMAP.md](ROADMAP.md) nur für Scope/Stand, betroffene Code-Dateien gezielt lesen. Nicht das ganze Repository einlesen.
3. Eine kleine Aufgabe bearbeiten (ca. 15–45 Minuten); größere Aufgaben aufteilen. Keine Funktionen außerhalb des Umfangs der ersten Store-Version (ROADMAP) ohne Auftrag ergänzen.
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
| `OnlineTestView.swift` | Geschützter Demo-Abruf, Zugang nur flüchtig; Tab ausschließlich Debug |
| `Info.plist` | App-Konfiguration; Hintergrundmodi vor Release prüfen |

Die lokale Profilverwaltung ist ein Prototyp und wird durch die Server-Anbindung ersetzt (F10–F14); Ansichten und Auswahlwerte möglichst wiederverwenden.

Persistenz bisher: `Documents/profiles.json` und `UserDefaults`. Neue Modellfelder optional oder mit Decoder-Default; bei inkompatiblen Änderungen Migration vorsehen. Den gemeinsamen Store nutzen, keine parallele Profil-Datenhaltung einführen. Speichern/Neustart und Bestandserhalt bei Persistenzänderungen testen.

Code und reproduzierbare Tests belegen den Ist-Stand; Roadmap beschreibt den Plan. Widersprüche protokollieren. Keine Build-Erfolge, Quellenprüfungen oder Veröffentlichungen ohne Nachweis behaupten. Keine Zugangsdaten oder privaten Testdaten dokumentieren; keine kostenpflichtigen oder modellspezifischen Werkzeuge voraussetzen.

## Bei Serverarbeiten

Nur dann zusätzlich [SERVER-TEST.md](SERVER-TEST.md) lesen. Nutzer bevorzugt kleine Schritte mit Zweck und erwartetem Ergebnis; Screenshots nur bei unklarer Oberfläche. Cyberduck für Dateien, VS Code zum Bearbeiten. Der Server ist Kernbestandteil der Store-Version (Aufgaben S04, B01–B08); bestehende Demo-Tabelle und ältere Datenbank nicht verändern. Zugangsschutz nicht ohne Auftrag entfernen, Hauptwebsite nicht ungefragt aktivieren; Geheimnisse bleiben außerhalb von Git und App-Code.
