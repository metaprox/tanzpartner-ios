# Changelog – Tanzpartner iOS App

Alle wichtigen Änderungen an der iOS-App sind hier dokumentiert.

## [0.2.1] - 2026-11-15

### 🔧 Stabilisierung & UI-Korrekturen

#### Geändert
- **`Models.swift`** – Zentrale Auswahloptionen (`Profile.cities`, `Profile.availableStyles`, `Profile.roles`, `Profile.levels`, `Profile.goals`) als Single Source of Truth ergänzt; ungültige SF Symbols korrigiert (`hourglass.fill` → `hourglass`, `return.down.back.icon.fill` → `arrow.uturn.backward`).
- **`ProfileListView.swift`** –
  - Status-Filterung ergänzt: Die Tanzpartner-Liste zeigt ausschließlich lokal freigegebene Profile (`profile.status == .approved`).
  - Filter und Editor nutzen gemeinsame Optionen (`Profile.availableStyles` inkl. `Bachata` & `Zumba`).
  - Suche und Ortsfilter berücksichtigen neben `city` nun auch `places`.
  - `ProfileEditorView` bewahrt bestehende `places` und erlaubt deren Bearbeitung über „Mögliche Tanzorte“ (Hauptort bleibt immer enthalten).
  - `MultiSelectPicker` auf `.buttonStyle(.plain)` umgestellt und Force-Unwrap beim Abwählen entfernt.
  - `TextArea` / `UITextViewWrapper` entfernt und durch natives `TextField(..., axis: .vertical)` mit `.lineLimit(5...10)` ersetzt (kein UIKit-Workaround / Observer-Leak mehr).
- **`ModerationView.swift`** – `SettingsView` in einen `NavigationStack` eingebettet (`.navigationTitle("Einstellungen")` sichtbar) und ungültige SF Symbols korrigiert (`note.fill` → `note.text`, `arrow.triangle.2.circlepath.fill` → `arrow.triangle.2.circlepath`).
- **`KI-LEITFADEN.md`** – Aktuellen Stand (15.11.2026), Deployment Target `17.0`, Single-Source-Optionen, `places`-Verhalten und offene Cleanup-Punkte nachgezogen.

---

## [0.2.0] - 2026-11-14

### 🎉 Kernlogik implementiert (App voll funktionsfähig)

#### Hinzugefügt
- **`Models.swift`** – `Profile` + `ModerationStatus` (Codable, toleranter Decoder für Schema-Erweiterungen)
- **`ProfileStore.swift`** – zentrale Datenquelle mit JSON-Persistenz (`Documents/profiles.json`), 8 Seed-Profile beim ersten Start
- **Profil-Editor** – neu + bearbeiten, inkl. Moderations-Sektion (Status + Notiz)

#### Geändert
- **`ProfileListView.swift`** – store-basiert: Suche, Filter-Sheet (Ort/Stil/Rolle), Tap → bearbeiten, Wischen → löschen
- **`ModerationView.swift`** – echte Profile statt Mock-Daten: Status-Filter-Pills mit Zählern, Sortierung (offen zuerst), Tap → bearbeiten
- **`App.swift`** – `ProfileStore` via `environmentObject` injiziert (geteilt zwischen beiden Tabs)
- **`ContentView.swift`** – Preview mit Store (Crash-Schutz)
- **`project.pbxproj`** – `Models.swift` + `ProfileStore.swift` registriert

#### Anmerkungen
- **Local-first:** Daten liegen in einer JSON-Datei auf dem Gerät; Backend-Sync (`store.mjs`) ist der nächste Schritt
- **Build:** `BUILD SUCCEEDED`, 0 Swift-Warnings (nur AppIcon-Asset-Warnung, kosmetisch)
- **Doku:** `KI-LEITFADEN.md` auf Ist-Zustand aktualisiert (Startpunkt für nachfolgende KIs)

---

## [0.1.0] - 2026-11-14

### 🎉 Erste Version (Vorbereitung)

#### Hinzugefügt
- **Xcode-Projektstruktur** vorbereitet
- **Web-App kopiert** aus ki-web-labor/tanzpartner-ostfriesland (~21 MB)
- **Dokumentation erstellt**
  - `docs/README.md` – Einstieg und Projektübersicht
  - `docs/ARCHITEKTUR.md` – Technische Details und Datenfluss

#### Geplant (nicht implementiert)
- Xcode Projekt erstellen
- SwiftUI Views implementieren
- SQLite-Integration

### Technologien
- **SwiftUI** für UI (kostenlos, Teil von iOS SDK)
- **WKWebView** für bestehende Web-App (kostenlos)
- **SQLite** native API (öffentliches Domain)

---

## Format

Die Einträge folgen dem [Keep a Changelog](https://keepachangelog.com/de/1.0.0/) Format.