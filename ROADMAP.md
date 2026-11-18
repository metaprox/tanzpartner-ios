# Roadmap V1

## Ziel

Native SwiftUI-App mit **offline Tanzlexikon (15–20 geprüfte Einträge), Suche und lokalen Lexikon-Favoriten**. Der vorhandene Profilbereich bleibt eine eindeutig bezeichnete lokale Demo ohne echte Vermittlung, Konten oder Nachrichtenversand.

Außerhalb V1: Backend/Mehrbenutzerbetrieb, Cloud-Sync, Push, Fotos, Biometrie und öffentlich bearbeitbare Inhalte. Spätere Ideen erst bewerten, nicht nebenbei implementieren.

## Geprüfter Stand – 15.11.2026

Quellcodebasis: `fbb950b77b6fdd453161e3983f937c037e1c9dd7`. Quellcodeprüfung vom 15.11.; zusätzlich am 16.11.2026 erfolgreicher Simulator-Debug-Build von Commit `85cfb5e8a2c5914b75fd8d812d52e41c80ab053c` mit Xcode 27.2. Kein App-Start durch Codex. Ergänzender Nutzerbericht vom 16.11.: bisheriger Stand auf iPhone 16 Pro Max mit iOS 27.2.1 grundsätzlich funktionsfähig; installierter Build und Testfälle nicht erfasst, keine vollständige Abnahme.

| Befund | Beleg (unter `TanzpartnerOstfrieslandiOS/`, sofern nicht anders angegeben) |
|---|---|
| Drei native Tabs; gemeinsamer Store | `App.swift`, `ContentView.swift` |
| Acht Beispielprofile, lokale JSON-Persistenz, CRUD und Reset | `ProfileStore.swift` |
| Profilsuche/Filter, Detail, fiktive Beispiele und Kontakt-Simulation | `ProfileListView.swift`, `ProfileDetailView.swift` |
| Theme, Push-/Sync-Schalter nur lokal gespeichert; rechtliche Texte vorhanden, ungeprüft | `SettingsView.swift` |
| Hintergrundmodi `fetch`/`remote-notification`; Bedarf offen | `Info.plist` |
| Effektives Mindest-iOS im geprüften Debug-Simulator-Build: 17.0; Projektwert 16.0, Target nutzt empfohlene Variable. Release-Einstellungen separat prüfen. | `TanzpartnerOstfrieslandiOS.xcodeproj/project.pbxproj` |
| Kein Lexikonmodell, Lexikon-Datensatz oder Favoritenspeicher gefunden | Native Swift-Dateien und Projekt-Dateiliste |

Quellcode vorhanden bedeutet nicht Laufzeit geprüft. Insbesondere Neustart/Persistenz, Fehlerfälle, vollständige Demo-Kennzeichnung und Datenschutz sind offen.

## Reihenfolge und Abschlusskriterien

1. **Grundlage:** Änderungen übernehmen und Ausgangsbuild/Mindest-iOS dokumentieren (D02, V01).
2. **Inhalte:** 15–20 eigenständig formulierte, fachlich geprüfte Einträge mit Quellen und geklärten Rechten (L01–L05).
3. **Funktionen:** Texte ab Erststart offline lesbar, Suche nutzbar, Favoriten nach Neustart erhalten, Demo konsequent bezeichnet (F01–F05b).
4. **Test:** Simulator und echtes Gerät, Offline-/Neustartfälle, Bedienbarkeit und Fehlernachtests; keine blockierenden Fehler (Q01–Q03).
5. **Datenschutz/Release:** Reale Datenflüsse und Texte abgleichen, aktuelle Apple-Vorgaben prüfen, Store-Unterlagen/Release freigeben (P01–P03, A01–A02).
6. **Einreichung:** Build/Datum/Review-Status protokollieren (A03). Einreichung ist keine zugesagte Zulassung.

## Inhaltsstandard

Pro Eintrag: stabile ID, Titel, Kategorie, Suchbegriffe, Kurzbeschreibung, Fachtext, Quellen mit Herausgeber/Titel/URL/Abrufdatum, Prüfstatus/-datum und Prüfer. Quellen tatsächlich lesen; ungeklärte oder regionale Varianten kennzeichnen. Keine ungeprüften KI-Texte oder fremden Medien ohne geklärte Rechte veröffentlichen. Nur Quellenlinks dürfen Internet benötigen, alle Kerntexte müssen offline vorliegen.

Aufgaben und Akzeptanzkriterien ausschließlich in [TODO.md](TODO.md); aktuelle Übergabe in [ARBEITSLOG.md](ARBEITSLOG.md).

## Separater Serverversuch / spätere Erweiterung

Seit 16.11.2026 ist ein geschützter PHP-/MariaDB-Lesetest mit drei fiktiven Gesuchen durch Nutzerberichte bestätigt; Debug-Leseansicht seit 16.11. implementiert und gebaut, echter App-Login noch nicht abgenommen. Späteres Ziel: digitales schwarzes Brett, ausdrücklich ohne Chat und internes Kontaktanfrage-System; externe Kontaktaufnahme, Ablauf/Bestätigung von Gesuchen. Details und offene Entscheidungen: [SERVER-TEST.md](SERVER-TEST.md). Offline-V1 bleibt unverändert.
