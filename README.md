# Tanzpartner Ostfriesland iOS

Native iOS-App für Tanzpartner Ostfriesland, basierend auf dem bestehenden Web-Projekt in [ki-web-labor](https://github.com/metaprox/ki-web-labor).

## 📱 Status

**Projektstart:** 14. November 2026  
**Ziel:** Eine native iOS-App mit SwiftUI + WKWebView  

---

## 🛠️ Technologie

| Komponente | Technologie |
|---|---|
| UI-Framework | SwiftUI |
| WebView | WKWebView |
| Datenbank | SQLite (native API) |
| Build-Tool | Xcode |

**Keine externen Kosten** – alles Open Source oder Teil von Apple SDKs.

---

## 📁 Projektstruktur

```
tanzpartner-ios/
├── TanzpartnerOstfrieslandiOS.xcodeproj/     # Xcode Projekt (in Vorbereitung)
│   └── project.pbxproj                        # Projektkonfiguration
├── TanzpartnerOstfrieslandiOS/               # Swift-Quellcode
│   ├── App.swift                              # Hauptklasse
│   ├── ContentView.swift                      # Tab-Navigation
│   ├── ProfileListView.swift                  # Tanzpartner-Liste
│   └── ModerationView.swift                   # Moderations-Queue
├── www/                                       # Kopie des Web-Projekts (~21 MB)
│   ├── index.html, app.js, style.css
│   └── data.sqlite                            # SQLite-Datenbank (8 Profile)
├── docs/
│   ├── README.md                              # Einstieg für iOS-Entwicklung
│   ├── ARCHITEKTUR.md                         # Technische Details
│   └── CHANGELOG.md                           # Versionshistorie
├── SETUP.md                                   # GitHub Desktop-Anleitung
└── KI-LEITFADEN.md                            # 🤖 Für nachfolgende KIs (STARTPUNKT)
```

---

## 📚 Dokumentation

| Datei | Zweck |
|---|---|
| **KI-LEITFADEN.md** | 🤖 **Startpunkt für weitere KIs** – Übersicht, Architektur, Nächste Schritte |
| **README.md** | Kurzübersicht und Technologie |
| **SETUP.md** | Anleitung für GitHub Desktop-Nutzer |
| **docs/README.md** | iOS-spezifische Details |
| **docs/ARCHITEKTUR.md** | Technische Architektur (SwiftUI, WKWebView, SQLite) |

---

## 🔄 Datenfluss

```
SwiftUI + WKWebView → SQLite (data.sqlite)
                       ↓
                   native iOS APIs
                       ↓
           Push, Kamera, Biometrie (optional)
```

---

## 🧪 Erster Start (für eine neue KI)

1. **Öffne das Projekt in Xcode**
   ```bash
   open "/Users/svenschley/Documents/GitHub/tanzpartner-ios/TanzpartnerOstfrieslandiOS.xcodeproj"
   ```

2. **Prüfe die Developer Directory-Einstellung**
   - In Xcode: `Settings > Locations`
   - Command Line Tools auf `Xcode 27.2` setzen

3. **Wähle ein Ziel** (z.B. iPhone 15 oder My Mac)
4. **Starte die App** mit dem Run-Button (▶️)

---

## 📝 Nächste Schritte

1. **Xcode Projekt erstellen** (SwiftUI App Template)
2. **WKWebView konfigurieren** für bestehende Web-App
3. **SQLite-Integration** testen
4. **Views implementieren**
   - `ContentView.swift` – Hauptansicht mit Tab-Navigation ✅
   - `ProfileListView.swift` – Profil erstellen/bearbeiten ✅
   - `ModerationView.swift` – Moderations-Queue ✅

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