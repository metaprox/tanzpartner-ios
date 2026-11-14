# Tanzpartner iOS App – Entwickler-Dokumentation

## 📱 Projektübersicht

Die **Tanzpartner Ostfriesland iOS App** ist eine native iOS-Anwendung, basierend auf dem bestehenden Web-Projekt in `../ki-web-labor/tanzpartner-ostfriesland`.

### Ziel
Eine native iOS-App erstellen, die:
- ✅ Das bestehende Web-Frontend integriert (HTML/CSS/JS)
- ✅ SQLite-Datenbank nutzt (lokal)
- ✅ Native Features bereitstellt (Push-Benachrichtigungen, Kamera, Biometrie)
- ✅ Kostenlos bleibt (keine externen kostenpflichtigen Tools)

---

## 🛠️ Architektur

### Technologie-Stack

| Komponente | Technologie |
|---|---|
| **UI-Framework** | SwiftUI |
| **WebView** | WKWebView (für Web-Inhalte) |
| **Datenbank** | SQLite (native API oder SQLite.swift) |
| **Speicherung** | File System + Core Data (optional) |
| **Build-Tool** | Xcode (offiziell von Apple) |

### Projektstruktur

```
tanzpartner-ios/
├── TanzpartnerOstfrieslandiOS/     # Xcode Projekt
│   ├── Assets.xcassets/
│   ├── Preview Content/
│   ├── ContentView.swift           # Hauptansicht mit WebView
│   ├── ProfileView.swift           # Profil erstellen
│   ├── ModerationView.swift        # Moderations-UI
│   └── ...
├── www/                             # Kopie des Web-Projekts
│   ├── index.html
│   ├── app.js
│   ├── style.css
│   └── ...
├── docs/
│   ├── README.md                   # Diese Datei
│   ├── ARCHITEKTUR.md              # (zukünftig)
│   └── TESTPLAN.md                 # (zukünftig)
└── assets/                          # Icons, Launch Screens etc.
```

---

## 🔄 Datenfluss

```
┌─────────────────────────────────────────────────────┐
│         iOS App (SwiftUI + WKWebView)              │
├─────────────────────────────────────────────────────┤
│                                                     │
│  ┌──────────────┐      ┌──────────────────────┐   │
│  │   SwiftUI UI │◄────►│   WKWebView (www/)    │   │
│  │   (Buttons,   │      │   HTML/CSS/JS-App    │   │
│  │    Lists...) │      │   - app.js           │   │
│  └──────────────┘      │   - moderation.js    │   │
│                         │   - profiles.js      │   │
│                         └──────────────────────┘   │
│                                    │                │
│                                    ▼                │
│                         ┌──────────────────────┐   │
│                         │   SQLite (data.sqlite)│   │
│                         │   - profiles         │   │
│                         │   - moderation_queue │   │
│                         │   - app_state        │   │
│                         └──────────────────────┘   │
└─────────────────────────────────────────────────────┘
```

---

## 📝 Status

### Aktueller Stand (2026-11-14)

| Komponente | Status |
|---|---|
| **Xcode Projekt** | ⏳ Planung in Vorbereitung |
| **Web-Inhalte kopiert** | ✅ Fertig (`www/`) |
| **Datenbankstruktur** | ✅ Bekannt (SQLite) |
| **Native Features** | 📋 Geplant |

---

## 🚀 Nächste Schritte

1. **Xcode Projekt erstellen**
   - SwiftUI App Template
   - WKWebView für bestehende Web-App
   - SQLite-Integration

2. **WebView-Konfiguration**
   - Lokale Dateien laden (`file://`)
   - API-Endpunkte proxyen (für `store.mjs`-Funktionen)
   - Deep Linking unterstützen

3. **Native Features hinzufügen**
   - Splash Screen
   - App Icon & Launch Screen
   - Push-Benachrichtigungen (optional)

4. **Testen & Optimieren**
   - Simulator-Tests
   - Gerätetests auf echtem iPhone

---

## 🤝 Team-Arbeit

Das Projekt ist als **Team-Projekt** konzipiert:

- ✅ GitHub Repository für Versionierung
- ✅ Branch-Strategie (z.B. `feature/`, `bugfix/`)
- ✅ Dokumentation in `docs/`
- ✅ Keine externen Kosten (rein Open Source)

---

## 📚 Verwandte Projekte

| Projekt | Pfad | Beschreibung |
|---|---|---|
| **Web-App** | `../ki-web-labor/tanzpartner-ostfriesland` | Ursprüngliches Web-Projekt |
| **Arbeitsordner Bionic** | `~/Documents/TanzpartnerOstfrieslandArbeitsordnerBionic` | Zentraler Arbeitsordner |

---

## 📄 Lizenz

Das Projekt nutzt ausschließlich kostenlose Tools:
- **Xcode** (Apple, kostenlos mit macOS)
- **SwiftUI** (Apple, kostenlos)
- **SQLite** (public domain)
- **WKWebView** (Apple, kostenlos)

Keine externen kostenpflichtigen Abhängigkeiten geplant.