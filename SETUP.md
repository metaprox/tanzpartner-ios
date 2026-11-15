# Lokal arbeiten

Projektordner: `/Users/svenschley/Documents/GitHub/tanzpartner-ios`.

1. In GitHub Desktop dieses lokale Repository auswählen. Vor Updates/Branchwechsel offene Änderungen prüfen und sichern.
2. `TanzpartnerOstfrieslandiOS.xcodeproj` in Xcode öffnen; vorhandene Bundle-ID und Signierung erhalten.
3. Einen installierten iOS-Simulator wählen und Run starten. Für ein echtes Gerät passende Signierung und Gerätefreigabe prüfen.
4. Xcode-Version, effektives Mindest-iOS, Gerät/OS, Commit und Ergebnis im Arbeitslog erfassen. Ein erfolgreicher Build ersetzt keine Funktionstests.
5. Nach der Arbeit in GitHub Desktop Diff prüfen, gewünschte Dateien committen und pushen. Lokale Änderungen sind erst danach auf GitHub.

Falls Kommandozeilen-Builds Xcode nicht finden: zunächst Xcodes Einstellung für Command Line Tools prüfen; keine systemweite Konfiguration ungefragt ändern.
