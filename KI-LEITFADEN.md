# 🤖 KI-Leitfaden – Tanzpartner Ostfriesland iOS

## 🎯 Ziel dieses Leitfadens

Eine weitere KI (oder Entwickler) soll nach diesem Leitfaden das Projekt **Tanzpartner Ostfriesland iOS** verstehen, weiterentwickeln und verwalten können.

---

## 📁 Projektübersicht

| Element | Wert |
|---|---|
| **Projektname** | Tanzpartner Ostfriesland iOS |
| **Repository-Pfad** | `/Users/svenschley/Documents/GitHub/tanzpartner-ios` |
| **GitHub-Repo** | `metaprox/tanzpartner-ios` (lokal) |
| **Web-App-Quelle** | `../ki-web-labor/tanzpartner-ostfriesland` |
| **Status** | Vorbereitung für iOS-Entwicklung |

---

## 🗂️ Projektstruktur

```
tanzpartner-ios/
├── TanzpartnerOstfrieslandiOS.xcodeproj/      # Xcode-Projekt (aktuell manuell erstellt)
│   ├── project.pbxproj                         # Kernkonfiguration für Xcode
│   └── project.xcworkspace/                   # Workspace für Swift-Pakete
├── TanzpartnerOstfrieslandiOS/                # Swift-Quellcode
│   ├── App.swift                               # Hauptklasse: @main struct
│   ├── ContentView.swift                       # Tab-Navigation (3 Tabs)
│   ├── ProfileListView.swift                   # Liste mit Filter & Suchfunktion
│   ├── ModerationView.swift                    # Moderations-Queue anzeigen
│   └── Info.plist                              # App-Konfiguration
├── www/                                        # Kopie des Web-Projekts (~21 MB)
│   ├── index.html, app.js, style.css          # Web-App-Inhalte
│   └── data.sqlite                             # SQLite-Datenbank (8 Profile)
├── docs/
│   ├── README.md                               # Einstieg für iOS-Entwicklung
│   ├── ARCHITEKTUR.md                          # Technische Details
│   └── CHANGELOG.md                            # Versionshistorie
├── SETUP.md                                    # Anleitung für GitHub Desktop
└── KI-LEITFADEN.md                             # Dieser Leitfaden (aktuell)
```

---

## 🚀 Erster Start (für eine neue KI)

### Voraussetzungen

| Komponente | Version | Status |
|---|---|---|
| macOS | 27.2+ | ✅ Vorhanden |
| Xcode | 16.0+ | ✅ Empfohlen (mit aktueller Version erstellt) |
| GitHub Desktop | beliebig | ✅ Für einfache Workflows |
| Git | beliebig | ✅ Standard |

### Schritte zum Start

1. **Öffne das Projekt in Xcode**
   ```bash
   open "/Users/svenschley/Documents/GitHub/tanzpartner-ios/TanzpartnerOstfrieslandiOS.xcodeproj"
   ```

2. **Prüfe die Developer Directory-Einstellung**
   - In Xcode: `Settings > Locations`
   - Command Line Tools auf `Xcode 27.2` setzen (nicht auf CommandLineTools alone)

3. **Wähle ein Ziel** (z.B. iPhone 15 oder My Mac)
4. **Starte die App** mit dem Run-Button (▶️)

---

## 🧩 Software-Architektur

### Technologie-Stack

| Ebene | Technologie | Verwendung |
|---|---|---|
| **UI-Framework** | SwiftUI | Declarative UI, native Performance |
| **WebView** | WKWebView | Integration der bestehenden Web-App |
| **Datenbank** | SQLite (native API) | Speicherung von Profilen und Moderation |
| **Speicherung** | File System + Core Data (optional) | Lokale Datenhaltung |

### Datenfluss

```
┌─────────────────────────────────────────────┐
│       iOS App (SwiftUI + WKWebView)        │
├─────────────────────────────────────────────┤
│  ┌──────────────┐     ┌─────────────────┐ │
│  │   SwiftUI UI │◄───►│  WKWebView      │ │
│  │   (Tabs,     │      │  www/           │ │
│  │    Lists...) │      │  - app.js       │ │
│  └──────────────┘      │  - moderation.js│ │
│                         │  - profiles.js  │ │
│                         └─────────────────┘ │
│                                    │         │
│                                    ▼         │
│                         ┌───────────────┐   │
│                         │ SQLite        │   │
│                         │ - profiles    │   │
│                         │ - moderation  │   │
│                         │ - app_state   │   │
│                         └───────────────┘   │
└─────────────────────────────────────────────┘
```

---

## 📱 App-Funktionen (Status Quo)

### Umgesetzt

| Feature | Status | Anmerkung |
|---|---|---|
| **Tab-Navigation** | ✅ Implemented | Tanzpartner, Moderation, Einstellungen |
| **Profil-Liste** | ✅ Implemented | Mit Filter nach Ort/Stil/Rolle |
| **Filterleiste** | ✅ Implemented | Suche und Filter-Pills |
| **Moderations-Queue** | ✅ Implemented | Status: pending/approved/paused/returned |
| **SQLite-Datenbank** | ⏳ Integriert (www/) | `data.sqlite` mit 8 Testprofilen |

### Geplant

| Feature | Phase | Hinweis |
|---|---|---|
| **Profil-Editor** | ✅ In ProfileListView.swift implementiert | `ProfileEditorView()` |
| **Detailansicht** | 📋 Geplant | Für einzelnes Profil |
| **WebView-Integration** | ⏳ Vorbereitet | Web-App aus `www/` laden |
| **Push-Benachrichtigungen** | 📋 Optional | UserNotifications.framework |

---

## 🔧 Swift-Code-Übersicht

### App.swift
- Hauptklasse: `TanzpartnerOstfrieslandiOSApp`
- `@main`-Annotation für SwiftUI-Start
- Konfiguriert `WindowGroup` mit `ContentView()`

### ContentView.swift
- TabView mit 3 Tabs:
  - **Tab 0:** ProfileListView (Tanzpartner)
  - **Tab 1:** ModerationView (Moderation)
  - **Tab 2:** SettingsView (Einstellungen)

### ProfileListView.swift
- `ProfileListViewModel` – State Management für Liste
- Filter: Ort, Tanzstil, Rolle
- `ProfileEditorView()` – Formular zum Erstellen neuer Profile

### ModerationView.swift
- Zeigt Moderations-Queue an
- Status-Indikatoren (pending/approved/returned/paused)
- Optional: Hinzufügen neuer Einträge

---

## 📊 Datenbank (SQLite)

Die Web-App bringt bereits eine `data.sqlite` mit:

### Tabellen

| Tabelle | Inhalt |
|---|---|
| **profiles** | 8 fiktive Tanzpartner (Mara, Jan, Alva etc.) |
| **moderation_queue** | Moderations-Queue (aktuell leer) |
| **app_state** | JSON-Dokumente mit Revisionsnummern |

### Wichtige Spalten (profiles)

- `id`, `number`, `name`, `city`
- `style` (z.B. "Standard / Latein", "Salsa")
- `role` ("Führend", "Folgend", "Beides")
- `level`, `goal`, `time`, `bio`

---

## 🌐 Web-App (www/)

Das Verzeichnis `www/` enthält die kopierte Web-App:

### Wichtige Dateien

| Datei | Zweck |
|---|---|
| **index.html** | Startseite mit Suche |
| **app.js** | Profil-Filter-Logik |
| **moderation.js** | Moderations-UI |
| **profiles.js** | 8 fiktive Profile als JavaScript-Array |
| **db.js** | SQLite-Verbindung (Node.js, nicht iOS-relevant) |
| **store.mjs** | API für App-Zustand |
| **data.sqlite** | Datenbank mit Profilen |

---

## 🧪 Testen & Debuggen

### Simulator
- Ziel wählen (z.B. iPhone 15)
- Run-Button (▶️) klicken
- Tab-Navigation testen
- Filter und Suche ausprobieren

### Logging
- Xcode Console für Swift-Logs
- WebKit Inspector für WebView-Inhalte (entwickle > Inspect > [App-Name])

---

## 🔍 Known Issues & To-Dos

| Problem | Status | Lösungsvorschlag |
|---|---|---|
| **Developer Directory** | ⚠️ Zu prüfen | Auf `Xcode.app` statt `CommandLineTools` stellen |
| **Bundle Identifier** | ✅ Konfigurierbar | In Xcode > General > Signing & Capabilities |
| **App-Icon** | 📋 Vordefiniert (Contents.json) | Fehlt noch das PNG-Bild |
| **WebView-Integration** | ⏳ Vorbereitet | `file://`-Pfade zu `www/` konfigurieren |

---

## 🚢 Nächste Schritte

### Sofort (für ersten Test)
1. Developer Directory prüfen/anpassen
2. App im Simulator starten
3. Tab-Navigation und Filter testen

### Kurzfristig
1. App-Icon hinzufügen (SVG/PNG)
2. WebView-Integration finalisieren
3. Detailansicht für Profile implementieren

### mittelfristig
1. Push-Benachrichtigungen einrichten
2. Kamera-Integration für Profil-Fotos
3. Biometrie-Login (Face ID/Touch ID)

---

## 📚 Verwandte Dokumentation

| Datei | Zweck |
|---|---|
| **README.md** | Einstieg & Übersicht |
| **SETUP.md** | GitHub Desktop-Anleitung |
| **docs/README.md** | iOS-spezifische Details |
| **docs/ARCHITEKTUR.md** | Technische Architektur |
| **docs/CHANGELOG.md** | Versionshistorie |

---

## ✅ Fertig – los geht's!

Mit diesem Leitfaden sollte eine weitere KI das Projekt verstehen und weiterentwickeln können.

**Startpunkt:** Öffne Xcode → Projekt laden → Run (▶️)

Viel Erfolg beim Weitermachen! 🎉