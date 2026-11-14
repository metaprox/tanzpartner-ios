# Architektur – Tanzpartner iOS App

## Übersicht

Die iOS-App wird als **SwiftUI + WKWebView**-Hybrid realisiert.

### Warum SwiftUI?

| Vorteil | Erklärung |
|---|---|
| **Native Performance** | Direkter Zugriff auf iOS APIs |
| **Modernes UI-Framework** | Deklarative Syntax, reaktives Datenbinding |
| **Keine externen Abhängigkeiten** | Teil von macOS/iOS SDK |
| **Xcode-Integration** | Live-Vorschau, Preview-Engine |

### Warum WKWebView?

| Vorteil | Erklärung |
|---|---|
| **Bestehendes Web-Frontend nutzen** | Kein Neuschreiben der HTML/CSS/JS-Logik nötig |
| **Native Geschwindigkeit** | Basierend auf Safari's WebKit |
| **API-Zugriff** | Kommunikation zwischen Swift und JavaScript möglich |

---

## Komponenten-Aufbau

```
TanzpartnerOstfrieslandiOS/
│
├── ContentView.swift              # Hauptansicht mit WebView + Tab-Navigation
├── ProfileView.swift              # Profil erstellen / bearbeiten
├── ModerationView.swift           # Moderations-Queue anzeigen
├── AppStorage.swift               # App-spezifische Einstellungen
└── assets/
    ├── AppIcon.appiconset/        # App Icons (1024x1024 etc.)
    └── LaunchScreen.storyboard    # Splash Screen
```

---

## Datenfluss

### 1. App-Start

```
iOS Start → ContentView.swift → WKWebView lädt /www/index.html
                                             ↓
                                    app.js initialisiert
                                             ↓
                                    SQLite-Datenbank öffnen (data.sqlite)
```

### 2. Profil-Erstellung

```
Nutzer tippt auf "Profil erstellen"
        ↓
ProfileView.swift (SwiftUI Formular)
        ↓
WKWebView sendet Event an Swift: profileCreated({...})
        ↓
Swift speichert in SQLite via store.mjs API
```

### 3. Moderation

```
ModerationView.swift lädt Daten von /api/state/moderation-queue
        ↓
SQLite-Tabelle moderation_queue auslesen
        ↓
Liste anzeigen mit Status (pending/approved/paused/returned)
```

---

## SQLite-Integration

Die App nutzt die bestehende `data.sqlite`-Datei.

### Optionen für Swift-SQLite

| Library | Lizenz | Vorteile |
|---|---|---|
| **SQLite.swift** | MIT | Deklarative Swift-API, sehr populär |
| **GRDB** | MIT | Vollständige Funktionalität |
| **Apple native SQLite API** | Public Domain | Keine Abhängigkeit nötig |

**Empfehlung:** Start mit **Apple native SQLite API**, da:
- ✅ Keine zusätzliche Abhängigkeit
- ✅ Bereits in iOS SDK enthalten
- ✅ Ausreichend für unser Datenmodell

---

## Dateistruktur im App-Bundle

```
TanzpartnerOstfriesland.app/
├── Info.plist
├── TanzpartnerOstfriesland       # Hauptexecutable
├── Assets/
│   ├── AppIcon.appiconset/
│   └── LaunchScreen.storyboardc/
└── www/                          # Web-App-Inhalte
    ├── index.html
    ├── app.js
    ├── style.css
    ├── moderation.js
    ├── profiles.js
    ├── store.mjs
    ├── db.js
    ├── storage.js
    └── data.sqlite               # ⚠️ Wichtig: mit ins Bundle kopieren!
```

---

## API-Endpunkte (für WKWebView)

Die Web-App erwartet folgende Endpunkte:

| Endpoint | Methode | Zweck |
|---|---|---|
| `/api/state/{key}` | GET | Lade App-Zustand aus SQLite |
| `/api/state/{key}` | POST | Speichere App-Zustand in SQLite |

Da die Web-App lokal läuft (`file://`), müssen wir:
- ✅ **Lokale Dateien** über `file://` laden können
- ✅ **API-Endpunkte** entweder als Proxy oder direkt via `fetch()` erreichen

### Lösungsvorschlag: Lokaler Server in Swift

Für API-Zugriff auf die SQLite-Datenbank kann eine kleine **in-memory HTTP-Server** in Swift laufen:

```
Swift App startet
   ↓
Startet lokalen Server (z.B. auf port 8080)
   ↓
WKWebView lädt von file:// + http://localhost:8080/api/...
```

Alternativ kann die API direkt über **JavaScript-Bindings** erreicht werden:

```swift
// In Swift
let value = webView.evaluateJavaScript("getStoreValue('my-key')") { result, error in
    // Verarbeite Ergebnis
}
```

---

## Native Features (zukünftig)

| Feature | Swift API | Hinweis |
|---|---|---|
| **Push-Benachrichtigungen** | UserNotifications.framework | Optional |
| **Kamera für Profil-Foto** | AVFoundation | Optional |
| **Biometrie (Face ID/Touch ID)** | LocalAuthentication | Optional |
| **File Sharing** | UIDocumentPickerViewController | Für Export/Import |

---

## Lizenz-Übersicht

| Komponente | Lizenz | Kosten |
|---|---|---|
| Xcode | Apple EULA | Gratis (mit macOS) |
| SwiftUI | Apple | Gratis |
| WKWebView | Apple | Gratis |
| SQLite (native) | Public Domain | Gratis |
| **Gesamt** | — | **Keine externen Kosten** |

---

## Nächste Schritte

1. ✅ Xcode Projekt erstellen
2. ⏳ SwiftUI-View-Komponenten implementieren
3. ⏳ SQLite-Integration testen
4. ⏳ Web-App in WKWebView laden
5. ⏳ Testen im Simulator