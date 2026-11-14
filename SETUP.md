# Setup – GitHub Desktop

## Xcode-Projekt mit GitHub Desktop öffnen

Das **TanzpartnerOstfrieslandiOS**-Projekt ist so aufgebaut, dass es **automatisch von GitHub Desktop erkannt** wird.

---

## 📂 Projektstruktur

```
tanzpartner-ios/
├── TanzpartnerOstfrieslandiOS.xcodeproj/      # ← Xcode-Projekt (wird automatisch erkannt)
│   ├── project.pbxproj                         # Projektkonfiguration
│   └── project.xcworkspace/                   # Workspace für Swift-Pakete
├── TanzpartnerOstfrieslandiOS/                # Swift-Quellcode
│   ├── App.swift                               # App-Startpunkt
│   ├── ContentView.swift                       # Hauptansicht mit Tab-Navigation
│   ├── ProfileListView.swift                   # Tanzpartner-Liste
│   ├── ModerationView.swift                    # Moderations-Queue
│   └── Info.plist                              # App-Konfiguration
├── www/                                        # Web-App-Inhalte (kostenlos kopiert)
├── docs/                                       # Dokumentation
└── .gitignore                                  # Für GitHub Desktop optimiert
```

---

## 🚀 Schritt-für-Schritt-Anleitung

### 1. Projekt öffnen in GitHub Desktop

1. Öffne **GitHub Desktop**
2. Klicke auf **"File > Add Local Repository"** (oder "Clone a repository")
3. Wähle den Ordner:
   ```
   /Users/svenschley/Documents/GitHub/tanzpartner-ios
   ```
4. Klicke auf **"Add Repository"**

GitHub Desktop erkennt automatisch die `.xcodeproj`-Datei und zeigt sie als Projekt an.

---

### 2. Xcode-Projekt in Xcode öffnen

#### Variante A: Doppelklick (empfohlen)

1. Gehe in den Ordner `TanzpartnerOstfrieslandiOS.xcodeproj`
2. **Doppelklicke** auf `project.pbxproj` → öffnet sich automatisch in Xcode (vorausgesetzt, Xcode ist installiert)

#### Variante B: Aus GitHub Desktop

1. In GitHub Desktop, wähle das Repository
2. Klicke auf **"Open in Finder"**
3. Doppelklicke auf `TanzpartnerOstfrieslandiOS.xcodeproj`

---

### 3. Erste Konfiguration in Xcode

#### Projektinformationen anpassen

1. In Xcode: Öffne das **Project Editor** (linke Sidebar)
2. Wähle **"TanzpartnerOstfrieslandiOS"** unter "PROJECT"
3. Passe folgende Werte an:

| Feld | Wert |
|---|---|
| **Bundle Identifier** | `com.deinname.tanzpartnerostfrieslandios` (oder wie gewünscht) |
| **Team** | Dein Apple Developer Team (optional, für Test-Deployment) |
| **Version** | `1.0` |
| **Build** | `1` |

---

### 4. App testen im Simulator

1. In Xcode: Wähle das Ziel **"iPhone 15"** (oder dein bevorzugtes Gerät)
2. Klicke auf den **"Run"-Button** (▶️) oben links
3. Xcode startet den Simulator und lädt die App

---

## 📱 GitHub Desktop-Specific Features

### Branch-Strategie

Empfohlene Branch-Namen für Team-Arbeit:

| Branch | Zweck |
|---|---|
| `main` | Production-ready Code |
| `feature/webview-integration` | Neue Funktionen |
| `bugfix/sync-issues` | Fehlerbehebungen |
| `docs/update-readme` | Dokumentation |

### Pull Requests

Da das Projekt in GitHub Desktop geöffnet ist:

1. Erstelle neue Branch (z.B. `feature/new-view`)
2. Ändere Dateien
3. Committe mit aussagekräftiger Nachricht
4. Klicke auf **"Publish branch"**
5. Erstelle Pull Request über GitHub

---

## 🧩 Was ist enthalten?

| Komponente | Inhalt |
|---|---|
| **SwiftUI Views** | ContentView, ProfileListView, ModerationView |
| **Assets** | AppIcon (vordefinierte Größen) |
| **Info.plist** | Konfiguration für Push, Background Modes etc. |
| **www/** | Web-App-Inhalte (kostenlos kopiert, ~21 MB) |

---

## 💡 Tipps für GitHub Desktop

### Häufige Befehle

| Aktion | Tastenkombination / Menü |
|---|---|
| **Commit** | `Cmd + Enter` oder Menü: **"Commit to main"** |
| **Push** | `Ctrl + P` oder Menü: **"Publish branch"** |
| **Pull** | `Ctrl + T` oder Menü: **"Fetch origin"** |
| **Branch wechseln** | Menü: **"Current Branch"** |

### Filter in GitHub Desktop

Nutze die Suchleiste, um Dateien zu filtern:
- `*.swift` – Nur Swift-Dateien anzeigen
- `www/` – Nur Web-Inhalte anzeigen
- `docs/` – Nur Dokumentation anzeigen

---

## ✅ Fertig!

Das Projekt ist nun bereit für:
- 📱 **Simulator-Tests**
- 🎨 **UI-Anpassungen**
- 🔧 **SwiftUI-Entwicklung**
- 🌐 **Integration mit Web-App**

Viel Spaß beim Entwickeln! 🎉