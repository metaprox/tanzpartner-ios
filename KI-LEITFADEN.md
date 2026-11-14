# 🤖 KI-Leitfaden – Tanzpartner Ostfriesland iOS

## 🎯 Ziel dieses Leitfadens

Eine weitere KI (oder Entwickler) soll nach diesem Leitfaden das Projekt **Tanzpartner Ostfriesland iOS** verstehen, weiterentwickeln und verwalten können.

> **⚠️ Wichtig:** Dieser Leitfaden beschreibt den **tatsächlichen Stand** der App (14.11.2026).
> Die Dokumente `docs/README.md` und `docs/ARCHITEKTUR.md` beschreiben die *geplante* Hybrid-Architektur (WKWebView + SQLite) – die ist **noch nicht** in der laufenden App enthalten.

---

## ✅ Aktueller Stand (14. November 2026)

| Element | Status |
|---|---|
| **Build** | ✅ `BUILD SUCCEEDED` (Xcode, iOS Simulator), 0 Swift-Warnings |
| **App läuft** | ✅ 3 Tabs: Tanzpartner, Moderation, Einstellungen |
| **Kernlogik** | ✅ Profile speichern, bearbeiten, löschen; Suche + Filter; Moderations-Status |
| **Persistenz** | ✅ Local-first: JSON-Datei in `Documents/profiles.json` (8 Seed-Profile beim ersten Start) |
| **Backend-Sync** | ⏳ Nächster Ausbauschritt – Voraussetzung: Web-Etappe 1 (Mehrbenutzer, s. u.) |

---

## 🗂️ Projektstruktur

```
tanzpartner-ios/
├── TanzpartnerOstfrieslandiOS.xcodeproj/      # Xcode-Projekt
│   └── project.pbxproj                        # Kernkonfiguration (objectVersion 56)
├── TanzpartnerOstfrieslandiOS/                # Swift-Quellcode
│   ├── App.swift                              # @main: injiziert ProfileStore via environmentObject
│   ├── ContentView.swift                      # TabView (3 Tabs) + Preview mit Store
│   ├── Models.swift                           # Profile + ModerationStatus (Codable)
│   ├── ProfileStore.swift                     # Zentrale Datenquelle, JSON-Persistenz
│   ├── ProfileListView.swift                  # Tanzpartner-Tab: Liste, Filter, Editor
│   ├── ModerationView.swift                   # Moderations-Tab + SettingsView
│   ├── Info.plist                             # App-Konfiguration (Deployment Target 16.0)
│   └── Assets.xcassets/                       # AppIcon (⚠️ nur Contents.json, PNGs fehlen)
├── www/                                       # Kopie der Web-App (~21 MB, noch NICHT von iOS genutzt)
│   ├── index.html, app.js, style.css
│   ├── store.mjs                              # API für App-Zustand (Ziel des Backend-Syncs)
│   └── data.sqlite                            # SQLite-Datenbank (8 Profile, Referenz)
├── docs/                                      # Dokumentation (teilweise veraltet, s. o.)
│   ├── README.md, ARCHITEKTUR.md, CHANGELOG.md
├── SETUP.md                                   # GitHub-Desktop-Anleitung
└── KI-LEITFADEN.md                            # Dieser Leitfaden (STARTPUNKT)
```

---

## 🚀 Erster Start (für eine neue KI)

### Voraussetzungen

| Komponente | Status |
|---|---|
| macOS + Xcode (im `/Applications/Xcode.app`) | ✅ installiert |
| Deployment Target | iOS 16.0 (deckt alle verwendeten APIs ab) |

### Schritte

1. **Projekt öffnen**
   ```bash
   open "/Users/svenschley/Documents/GitHub/tanzpartner-ios/TanzpartnerOstfrieslandiOS.xcodeproj"
   ```

2. **Falls `xcodebuild` in der Shell fehlschlägt** (xcode-select zeigt auf CommandLineTools):
   ```bash
   sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
   ```

3. **Build aus der Shell** (vollständiger Pfad nötig, wenn xcode-select nicht gesetzt):
   ```bash
   /Applications/Xcode.app/Contents/Developer/usr/bin/xcodebuild \
     -project TanzpartnerOstfrieslandiOS.xcodeproj \
     -scheme TanzpartnerOstfrieslandiOS \
     -destination 'generic/platform=iOS Simulator' build 2>&1 | grep -E "error:|BUILD" | sort -u
   ```

4. **In Xcode:** Simulator wählen (z. B. iPhone 15) → Run (▶️)

---

## 🧩 Architektur (tatsächlicher Stand)

### Technologie-Stack

| Ebene | Technologie | Verwendung |
|---|---|---|
| **UI** | SwiftUI (rein nativ) | Alle 3 Tabs, keine WKWebView |
| **Datenhaltung** | `ProfileStore` (ObservableObject) + JSON-Datei | Local-first, kein Backend nötig |
| **Datenmodell** | `Profile` + `ModerationStatus` (Codable) | Geteilt zwischen Tanzpartner- und Moderations-Tab |

### Datenfluss

```
┌──────────────────────────────────────────────────────┐
│              iOS App (reines SwiftUI)               │
├──────────────────────────────────────────────────────┤
│                                                      │
│  ProfileListView ◄────► ModerationView              │
│        (Tab 1)             (Tab 2)                  │
│             └────────┬─────────┘                    │
│                      ▼                              │
│            ProfileStore (ObservableObject)          │
│        @Published profiles: [Profile]               │
│                      │                              │
│              upsert / delete                        │
│                      ▼                              │
│        persist() → Documents/profiles.json          │
│                                                      │
└──────────────────────────────────────────────────────┘
```

**Wichtig:** Beide Tabs teilen sich denselben `ProfileStore` (via `environmentObject`).
Jede Änderung (`upsert`, `delete`) aktualisiert `updatedAt` und schreibt sofort die JSON-Datei.

---

## 🔧 Swift-Code-Übersicht (Datei für Datei)

### `App.swift`
- `@StateObject private var store = ProfileStore()` → `.environmentObject(store)` an ContentView
- Erzwingt `colorScheme .light`

### `ContentView.swift`
- TabView mit 3 Tabs: Tanzpartner (0), Moderation (1), Einstellungen (2)
- `ContentView_Previews` hat `.environmentObject(ProfileStore())` (Canvas-Crash-Schutz)

### `Models.swift`
- **`Profile`** (Identifiable, Hashable, Codable): `id: Int`, `name`, `city`, `styles: [String]`, `role: String?`, `level`, `goal`, `places: [String]`, `time`, `bio` + Moderation: `status: ModerationStatus`, `note: String?`, `updatedAt: Date?`
- **Toleranter `init(from:)`:** alle Felder außer `id/name/city` mit Defaults (`decodeIfPresent`) – ältere JSON-Dateien überleben Schema-Erweiterungen
- **`ModerationStatus`** (String, CaseIterable, Codable): `pending`/`approved`/`returned`/`paused` mit `displayText`, `shortText` (für Filter-Pills), `icon`, `priority` (Sortierung: offen zuerst)

### `ProfileStore.swift`
- `@Published private(set) var profiles: [Profile]` – Mutationen nur über Methoden
- `upsert(_:)`: neu hinzufügen ODER bestehende ID aktualisieren, setzt `updatedAt`, persistiert
- `delete(_:)`, `nextID()` (max-ID + 1)
- `persist()`: JSONEncoder `.prettyPrinted, .sortedKeys` → atomar nach `Documents/profiles.json`
- `seedProfiles()`: 8 Beispieldaten (Mara, Jan, Alva, Timo, Jule, Lukas, Sarah, Finn) – nur beim allerersten Start

### `ProfileListView.swift` (Tanzpartner-Tab)
- Liste aus `store.profiles`, gefiltert per computed Property `filteredProfiles` (Suchtext in Name+Ort, exakte Matches für Ort/Stil/Rolle)
- **Filter-Sheet** (`FilterSheet`): optionale Picker mit `String?.none/.some`-Tags, Abbrechen/Zurücksetzen/OK
- **Tap auf Zeile** → `ProfileEditorView(profile:)` als Sheet (Bearbeiten)
- **Wischen** → `store.delete(...)`
- **"+" im Toolbar** → `ProfileEditorView()` (neu, Default `.pending`)
- Enthält wiederverwendbare Komponenten: `FilterBar`, `FilterPill` (wird auch vom Moderations-Tab genutzt), `ProfileRow`, `MultiSelectPicker`, `TextArea` + `UITextViewWrapper` (Placeholder-Emulation, da UITextView keins hat)

### `ModerationView.swift` (Moderations-Tab)
- Status-Filter-Pills horizontal scrollbar: Alle + 4 Status mit Zählern (`selectedStatus: ModerationStatus?`)
- Liste nach `status.priority` sortiert (offen zuerst), dann Name
- **Tap auf Zeile** → `ProfileEditorView(profile:)` (Status + Notiz ändern)
- `ModerationRow`: Status-Kreis mit Icon, Name, Status-Badge, `updatedAt` (falls gesetzt), Notiz
- **`SettingsView`** in derselben Datei (wird von ContentView referenziert – nicht verschieben!)

---

## 💾 Datenmodell & Persistenz

### JSON-Datei: `Documents/profiles.json`
```json
[ { "id": 1, "name": "Mara", "city": "Norden", "styles": ["Standard / Latein"],
    "role": "Folgend", ..., "status": "Lokal freigegeben", "note": null,
    "updatedAt": "2026-11-14T..." }, ... ]
```

### Regeln für Schema-Änderungen
1. Neue Felder **immer** optional ODER mit Default im toleranten `init(from:)` ergänzen
2. Bestehende Felder nicht umbenennen/löschen (oder Migration in `ProfileStore.init` schreiben)
3. Nach Änderungen: JSON-Datei im Simulator prüfen (`~/Library/Developer/CoreSimulator/Devices/<UDID>/data/Containers/Data/Application/<UUID>/Documents/profiles.json`)

---

## 📱 App-Funktionen (Status Quo)

### Umgesetzt ✅

| Feature | Wo |
|---|---|
| Tab-Navigation (3 Tabs) | ContentView.swift |
| Profil-Liste mit Suche + Filter-Sheet (Ort/Stil/Rolle) | ProfileListView.swift |
| Profil-Editor: **neu + bearbeiten** (alle Felder) | ProfileListView.swift (`ProfileEditorView`) |
| **Speichern** (persistiert in JSON) | ProfileStore.swift (`upsert`) |
| **Löschen** per Wischen-Geste | ProfileListView.swift (`.onDelete`) |
| Moderations-Tab: Status-Filter-Pills, Sortierung offen zuerst | ModerationView.swift |
| **Moderation: Status + Notiz ändern** (Tap → Editor) | ModerationView.swift |
| Einstellungen-Tab (Mock: Push, Sync, Theme) | ModerationView.swift (`SettingsView`) |

### Geplant ⏳ (empfohlene Reihenfolge)

| Feature | Hinweis |
|---|---|
| **Backend-Sync** | `ProfileStore` mit der Web-API (`store.mjs`, Kopie in `www/`) verbinden. **Voraussetzung:** Die aktuelle Web-API speichert nur einen gemeinsamen Zustand (Tabelle `app_state`, ein Testprofil) – für echtes Mehrprofil-Syncen zuerst **Etappe 1 des Web-Mehrbenutzer-Plans** umsetzen (eigene Tabelle je Profil: stabile ID, Status, Token-Hash; Plan liegt in `ki-web-labor/tanzpartner-ostfriesland/docs/MEHRBENUTZER-PLAN.md`). Danach: Push/Pull je Profil. Local-first beibehalten: JSON bleibt Quelle, Sync als Overlay. **Das ist der wichtigste nächste Schritt.** |
| **App-Icon** | PNGs in `Assets.xcassets/AppIcon.appiconset/` (aktuell nur Contents.json → Build-Warnings) |
| **Detailansicht** für Profile | Optional – der Editor deckt aktuell Bearbeiten ab |
| **Profil-Fotos** | Kamera-Integration (PhotosUI) |
| **Push-Benachrichtigungen** | UserNotifications.framework, SettingsView-Vorbereitung vorhanden |
| **Biometrie-Login** | LocalAuthentication (optional) |

---

## 🔍 Known Issues & To-Dos

| Problem | Status | Lösungsvorschlag |
|---|---|---|
| **App-Icon PNGs fehlen** | ⚠️ Build-Warnings (kosmetisch) | 1024×1024 + iOS-Größen in AppIcon.appiconset legen |
| **Leere Extra-Ordner** im Source-Verzeichnis (`Assets.app/`, `Content/`, `Preview Content/`) | 🧹 Cleanup-Kandidaten | Löschen (sind leer, nicht im pbxproj referenziert) |
| **`www/`-Ordner (~21 MB)** | ℹ️ Noch nicht von iOS genutzt | Bleibt als Referenz + Ziel für Backend-Sync; ggf. später aus dem Repo auslagern |
| **xcode-select → CommandLineTools** | ⚠️ Shell-Builds schlagen ohne vollen Pfad fehl | `sudo xcode-select -s /Applications/Xcode.app/Contents/Developer` |
| **SettingsView = Mock** | ℹ️ Toggles tun noch nichts | Mit ProfileStore/Backend verdrahten, wenn Sync kommt |

---

## 🚢 Nächste Schritte (empfohlen)

1. **Backend-Sync:** Zuerst Web-Etappe 1 (Mehrbenutzer: eigene Tabelle je Profil) im Web-Repo umsetzen – die aktuelle `app_state`-API kennt nur ein gemeinsames Testprofil. Danach: `ProfileStore` um Push/Pull je Profil erweitern, Konfliktstrategie definieren. **Praktisch:** Der lokale Server bindet an 127.0.0.1 → iOS-Simulator erreicht ihn, echtes iPhone im WLAN nicht (dann Bindung in `server.mjs` anpassen). Die `www/`-Kopie ist aktuelle Referenz (nur Doku-Änderungen im Web-Repo nicht nachgezogen).
2. **App-Icon** ergänzen (Warnings beseitigen)
3. **Leere Ordner** im Source-Verzeichnis aufräumen
4. **Detailansicht** für Profile (wenn gewünscht)
5. **Native Features:** Push, Kamera, Biometrie

---

## 📚 Verwandte Dokumentation

| Datei | Zweck |
|---|---|
| **KI-LEITFADEN.md** | 🤖 Dieser Leitfaden – **aktuelle Wahrheit**, Startpunkt |
| **README.md** | Kurzübersicht, Technologie, Status |
| **SETUP.md** | GitHub-Desktop-Anleitung |
| **docs/CHANGELOG.md** | Versionshistorie (aktuell halten!) |
| **docs/README.md / ARCHITEKTUR.md** | ⚠️ Beschreiben die *geplante* WKWebView+SQLite-Architektur (noch nicht umgesetzt) |

---

## ✅ Fertig – los geht's!

Mit diesem Leitfaden sollte eine weitere KI das Projekt verstehen und weiterentwickeln können.

**Startpunkt:** Xcode öffnen → Projekt laden → Run (▶️) · **Wichtigster nächster Schritt:** Backend-Sync

Viel Erfolg beim Weitermachen! 🎉
