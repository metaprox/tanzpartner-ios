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
├── TanzpartnerOstfrieslandiOS/     # Xcode Projekt (in Vorbereitung)
├── www/                             # Kopie des Web-Projekts
│   ├── index.html
│   ├── app.js
│   ├── style.css
│   └── data.sqlite
├── docs/
│   ├── README.md                    # Einstieg
│   ├── ARCHITEKTUR.md               # Technische Details
│   └── CHANGELOG.md                 # Versionshistorie
└── assets/                          # Icons, Launch Screens
```

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

## 📝 Nächste Schritte

1. **Xcode Projekt erstellen** (SwiftUI App Template)
2. **WKWebView konfigurieren** für bestehende Web-App
3. **SQLite-Integration** testen
4. **Views implementieren**
   - `ContentView.swift` – Hauptansicht mit Tab-Navigation
   - `ProfileView.swift` – Profil erstellen/bearbeiten
   - `ModerationView.swift` – Moderations-Queue

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