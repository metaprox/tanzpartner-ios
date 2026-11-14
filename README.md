# Tanzpartner Ostfriesland iOS

Native iOS-App für Tanzpartner Ostfriesland, basierend auf dem bestehenden Web-Projekt in [ki-web-labor](https://github.com/metaprox/ki-web-labor).

## 📱 Status

**Projektstart:** 14. November 2026  
**Stand (14.11.2026):** ✅ App baut und läuft – Kernlogik implementiert (Speichern, Bearbeiten, Löschen, Filter, Moderation)  
**Ziel:** Eine native iOS-App mit SwiftUI (local-first, später Backend-Sync)  

---

## 🛠️ Technologie

| Komponente | Technologie | Status |
|---|---|---|
| UI-Framework | SwiftUI (rein nativ) | ✅ in use |
| Datenhaltung | JSON-Datei via `ProfileStore` (local-first) | ✅ in use |
| WebView | WKWebView (`www/`) | ⏳ geplant, noch nicht in use |
| Datenbank | SQLite (native API) | ⏳ geplant, noch nicht in use |
| Build-Tool | Xcode | ✅ in use |

**Keine externen Kosten** – alles Open Source oder Teil von Apple SDKs.

---

## 📁 Projektstruktur

```
tanzpartner-ios/
├── TanzpartnerOstfrieslandiOS.xcodeproj/     # Xcode Projekt ✅
│   └── project.pbxproj                        # Projektkonfiguration
├── TanzpartnerOstfrieslandiOS/               # Swift-Quellcode
│   ├── App.swift                              # Hauptklasse (injiziert ProfileStore)
│   ├── ContentView.swift                      # Tab-Navigation (3 Tabs)
│   ├── Models.swift                           # Profile + ModerationStatus (Codable)
│   ├── ProfileStore.swift                     # Zentrale Datenquelle, JSON-Persistenz
│   ├── ProfileListView.swift                  # Tanzpartner-Liste + Editor
│   └── ModerationView.swift                   # Moderations-Tab (+ SettingsView)
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
SwiftUI-Views → ProfileStore (ObservableObject)
                       ↓
              JSON-Datei (Documents/profiles.json, local-first)
                       ↓
        später: Backend-Sync via store.mjs API (geplant)
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

**Erledigt:** Xcode-Projekt, alle Views, Kernlogik (Speichern/Bearbeiten/Löschen/Filter/Moderation) ✅

1. **Backend-Sync** – `ProfileStore` mit der `store.mjs`-API verbinden (local-first beibehalten)
2. **App-Icon** – PNGs in `Assets.xcassets/AppIcon.appiconset/` ergänzen
3. **Detailansicht** für einzelne Profile (optional)
4. **Native Features** – Push-Benachrichtigungen, Kamera für Profil-Fotos, Biometrie

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