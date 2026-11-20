# K02 – Datenmodell und API-Vertrag

Stand: 20.11.2026, **vom Nutzer bestätigt** (Entwurf Claude). Grundlage: Entscheidungen in [ROADMAP.md](../ROADMAP.md) (K01). Kein Code. Mit „Vorschlag“ markierte Werte wurden am 20.11. bestätigt (Liste am Ende). Abläufe, Mailtexte und Fristen im Detail folgen in K03.

## 1. Grundsätze

- **Keine Konten.** Wer ein Gesuch aufgibt, verwaltet es nur über Links in Mails (Bestätigen, Verlängern, Löschen).
- **E-Mail-Adressen verlassen den Server nie** – weder in der Leseschnittstelle noch in Fehlermeldungen. Die Admin-Webseite (B07) zeigt sie nur dem Betreiber.
- **Datensparsamkeit:** Kontakt-Nachrichten werden weitergeleitet, aber nicht gespeichert. Für Spamschutz und Sperrliste werden Adressen und IP-Adressen nur als **HMAC-Hash** (SHA-256 mit geheimem Server-Schlüssel aus `private/`) gespeichert.
- **Tokens** (Links in Mails): 32 Zufallsbytes, im Link Base64url-kodiert; in der Datenbank steht nur der SHA-256-Hash.
- **Links aus Mails lösen nie direkt etwas aus.** `GET` zeigt eine Webseite mit Knopf, erst das Absenden (`POST`) bestätigt, verlängert oder löscht. Grund: Mailprogramme und Virenscanner rufen Links oft automatisch auf.
- **Zeiten** in der Datenbank als `DATETIME` in UTC; in der API als ISO 8601 mit `Z`. Reine Tagesangaben (`sichtbar_bis`) als `YYYY-MM-DD`.
- **Zeichensatz** `utf8mb4`; Längen gelten in Zeichen (nicht Bytes), Text wird vorher getrimmt, Steuerzeichen außer Zeilenumbruch entfernt.
- Die bestehende Tabelle `demo_gesuche` bleibt unverändert.

## 2. Felder eines Gesuchs und erlaubte Werte

| Feld (API) | Pflicht | Typ / Länge | Erlaubte Werte |
|---|---|---|---|
| `anzeigename` | ja | Text, 2–30 | Buchstaben, Ziffern, Leerzeichen, `-`, `.`, `'`. Keine Mail-Adresse, keine Telefonnummer. |
| `ort` | ja | Schlüssel | aus Tabelle `orte` (aktiv) |
| `tanzstile` | ja | Liste, 1–5 | Schlüssel aus Tabelle `tanzstile` (aktiv), ohne Doppelte |
| `rolle` | ja | Schlüssel | `fuehrend`, `folgend`, `beides` |
| `erfahrung` | nein | Schlüssel | `ohne_vorkenntnisse`, `grundkenntnisse`, `fortgeschritten` |
| `ziel` | nein | Schlüssel | `ersten_kurs_beginnen`, `wieder_einsteigen`, `regelmaessig_tanzen`, `kenntnisse_vertiefen` |
| `tanzorte` | nein | Liste, 0–5 | Schlüssel aus `orte` (wo die Person tanzen könnte) |
| `zeiten` | nein | Text, 0–100 | frei, z. B. „Di/Do abends“ |
| `freitext` | nein | Text, 0–600 | frei; Zeilenumbrüche erlaubt (höchstens 10) |
| `email` | ja | Text, 6–254 | gültige Adresse; wird **nie angezeigt** |
| `alter_bestaetigt` | ja | `true` | Bestätigung „mindestens 18 Jahre“ |
| `datenschutz_akzeptiert` | ja | `true` | Hinweis zur Datenverarbeitung gelesen |

Rollen, Erfahrung und Ziel entsprechen den bisherigen Auswahlwerten in `Models.swift`; die App zeigt die deutschen Bezeichnungen, die API arbeitet mit Schlüsseln.

**Inhaltsprüfung (serverseitig, automatisch):** In `anzeigename`, `zeiten` und `freitext` werden Mail-Adressen, Telefonnummern (≥ 7 Ziffern in Folge, auch mit Leer-/Trennzeichen) und Links (`http`, `www.`) abgelehnt (Fehler `kontaktdaten_im_text`). Eine kleine Wortliste anstößiger Begriffe führt nicht zur Ablehnung, sondern zu einem Hinweis in der Admin-Webseite. Die eigentliche Kontrolle ist die Freigabe durch den Betreiber.

### Startwerte für Orte und Tanzstile (Vorschlag)

Beide als Daten in der Datenbank, nicht im App-Code. Die App lädt sie über `GET /api/v1/optionen.php`.

- **Orte:** Aurich, Emden, Leer, Norden, Wittmund, Esens, Weener, Wiesmoor, Großefehn, Ihlow, Südbrookmerland, Moormerland, Rhauderfehn, Westoverledingen, Krummhörn, Hinte, Uplengen, Borkum, Norderney, Juist. (Bisher in der App nur Norden, Emden, Aurich.)
- **Tanzstile:** Standard/Latein, Discofox, Salsa, Bachata, Kizomba, Tango Argentino, Rock'n'Roll/Boogie-Woogie, West Coast Swing, Lindy Hop/Swing. (Zumba aus der bisherigen Liste entfällt, da kein Paartanz.)

## 3. Tabellen

Alle Tabellen `InnoDB`, `utf8mb4_unicode_ci`. Fremdschlüssel mit `ON DELETE CASCADE`, damit Löschen eines Gesuchs alle zugehörigen Daten entfernt.

### `orte`, `tanzstile` (Auswahlwerte)

| Spalte | Typ | Hinweis |
|---|---|---|
| `id` | INT UNSIGNED, PK | |
| `schluessel` | VARCHAR(40), eindeutig | z. B. `emden`, `salsa`; nie ändern |
| `name` | VARCHAR(60) | Anzeige |
| `sortierung` | SMALLINT | Reihenfolge in der App |
| `aktiv` | BOOLEAN | inaktive Werte nicht mehr wählbar, bestehende Gesuche behalten sie |

### `gesuche`

| Spalte | Typ | Hinweis |
|---|---|---|
| `id` | INT UNSIGNED, PK | öffentliche Nummer |
| `status` | ENUM | siehe Abschnitt 4 |
| `anzeigename` | VARCHAR(30) | |
| `ort_id` | FK → `orte` | |
| `rolle` | ENUM(`fuehrend`,`folgend`,`beides`) | |
| `erfahrung` | ENUM(…), NULL | |
| `ziel` | ENUM(…), NULL | |
| `zeiten` | VARCHAR(100), NULL | |
| `freitext` | VARCHAR(600), NULL | |
| `email` | VARCHAR(254) | Klartext, nötig für Mails; nur Server/Admin |
| `email_hash` | CHAR(64) | HMAC; Abgleich mit Sperrliste und Begrenzungen |
| `pruefhinweis` | VARCHAR(200), NULL | automatischer Hinweis für die Moderation |
| `ablehnungsgrund` | VARCHAR(200), NULL | vom Betreiber, wird per Mail mitgeteilt |
| `erstellt_am` | DATETIME | |
| `bestaetigt_am` | DATETIME, NULL | Mail-Link bestätigt |
| `freigegeben_am` | DATETIME, NULL | |
| `sichtbar_bis` | DATE, NULL | Freigabe + 30 Tage; Verlängern setzt heute + 30 Tage |
| `erinnert_am` | DATETIME, NULL | Erinnerungsmail vor Ablauf verschickt |
| `alter_bestaetigt_am` | DATETIME | Nachweis der Bestätigung |
| `geaendert_am` | DATETIME | |

Index auf (`status`, `sichtbar_bis`) für die Leseschnittstelle.

### `gesuch_tanzstile`, `gesuch_tanzorte` (Zuordnungen)

| Spalte | Typ |
|---|---|
| `gesuch_id` | FK → `gesuche` |
| `tanzstil_id` bzw. `ort_id` | FK → `tanzstile` bzw. `orte` |

Primärschlüssel aus beiden Spalten.

### `tokens`

| Spalte | Typ | Hinweis |
|---|---|---|
| `id` | INT UNSIGNED, PK | |
| `gesuch_id` | FK → `gesuche` | |
| `zweck` | ENUM(`bestaetigen`,`verwalten`) | |
| `token_hash` | CHAR(64), eindeutig | SHA-256 des Tokens |
| `erstellt_am` | DATETIME | |
| `gueltig_bis` | DATETIME | `bestaetigen`: 24 Stunden; `verwalten`: bis das Gesuch gelöscht wird |
| `verbraucht_am` | DATETIME, NULL | `bestaetigen` ist nur einmal nutzbar |

Je Gesuch ein Bestätigungs- und ein Verwaltungstoken. Der Verwaltungslink steht in jeder Mail an die Person (Bestätigt, Freigegeben, Erinnerung) und führt auf eine Seite mit „Verlängern“ und „Löschen“.

### `meldungen`

| Spalte | Typ | Hinweis |
|---|---|---|
| `id` | INT UNSIGNED, PK | |
| `gesuch_id` | FK → `gesuche` | |
| `grund` | ENUM(`unangemessen`,`kontaktdaten`,`spam`,`minderjaehrig`,`kein_tanzgesuch`,`sonstiges`) | |
| `text` | VARCHAR(500), NULL | Erläuterung, optional |
| `melder_hash` | CHAR(64) | HMAC der IP-Adresse; gegen Mehrfachmeldungen |
| `status` | ENUM(`offen`,`unbegruendet`,`entfernt`) | Entscheidung des Betreibers |
| `erstellt_am`, `erledigt_am` | DATETIME (NULL) | |

### `sperrliste`

| Spalte | Typ | Hinweis |
|---|---|---|
| `id` | INT UNSIGNED, PK | |
| `email_hash` | CHAR(64), eindeutig | HMAC der normalisierten Adresse (getrimmt, klein geschrieben) |
| `grund` | VARCHAR(200) | nur für den Betreiber |
| `erstellt_am` | DATETIME | |

Gesperrte Adressen können weder Gesuche aufgeben noch Kontaktnachrichten senden. Die Adresse selbst wird nicht gespeichert.

### `protokoll` (Begrenzung von Anfragen)

| Spalte | Typ | Hinweis |
|---|---|---|
| `id` | BIGINT UNSIGNED, PK | |
| `aktion` | ENUM(`gesuch`,`kontakt`,`meldung`) | |
| `schluessel_hash` | CHAR(64) | HMAC von IP-Adresse oder E-Mail-Adresse |
| `gesuch_id` | INT UNSIGNED, NULL | bei Kontakt/Meldung, ohne FK (bleibt nach Löschung nicht erhalten, siehe Fristen) |
| `zeitpunkt` | DATETIME | |

Einträge älter als 7 Tage werden gelöscht (Cronjob, B06).

### Begrenzungen (Vorschlag)

| Aktion | Je IP-Adresse | Je E-Mail-Adresse |
|---|---|---|
| Gesuch aufgeben | 3 pro Tag | 1 offenes bzw. sichtbares Gesuch gleichzeitig |
| Kontakt senden | 10 pro Tag | 5 pro Tag; 1 pro Gesuch und Tag |
| Meldung | 10 pro Tag | – (1 pro Gesuch und IP) |

Gesamtgrenze Mailversand: höchstens 100 pro Stunde (Hoster). Bei Erreichen antwortet der Server mit `503 dienst_ausgelastet`.

## 4. Status eines Gesuchs

| Status | Bedeutung | sichtbar in der App |
|---|---|---|
| `unbestaetigt` | angelegt, Mail-Link noch nicht bestätigt | nein |
| `wartet` | bestätigt, wartet auf Freigabe | nein |
| `sichtbar` | freigegeben, `sichtbar_bis` ≥ heute | ja |
| `abgelaufen` | `sichtbar_bis` überschritten | nein |
| `abgelehnt` | vom Betreiber abgelehnt | nein |
| `ausgeblendet` | nach Meldung vorläufig ausgeblendet (Schwelle in K03) | nein |

**Übergänge:**

```text
(neu) ──Aufgeben──▶ unbestaetigt ──Link bestätigt──▶ wartet ──Freigabe──▶ sichtbar
unbestaetigt ──24 h ohne Bestätigung──▶ (gelöscht)
wartet ──Ablehnung──▶ abgelehnt ──7 Tage──▶ (gelöscht)
sichtbar ──sichtbar_bis überschritten──▶ abgelaufen ──Verlängern──▶ sichtbar
abgelaufen ──14 Tage ohne Verlängerung──▶ (gelöscht)
sichtbar ──Meldung ab Schwelle──▶ ausgeblendet ──Betreiber: unbegründet──▶ sichtbar
ausgeblendet ──Betreiber: entfernen──▶ (gelöscht)
sichtbar / abgelaufen ──Verlängern──▶ sichtbar (sichtbar_bis = heute + 30 Tage)
jeder Status ──Löschen per Link oder durch Betreiber──▶ (gelöscht)
```

„Gelöscht“ ist kein Status: Die Zeile wird mit allen Zuordnungen, Tokens und Meldungen physisch gelöscht. Verlängern ist nur aus `sichtbar` und `abgelaufen` möglich; ein inhaltlich geändertes Gesuch gibt es in Version 1 nicht (stattdessen löschen und neu aufgeben). Fristen (24 h, 7 und 14 Tage) bestätigt am 20.11.; Abläufe dazu in [K03-ABLAEUFE-TEXTE.md](K03-ABLAEUFE-TEXTE.md).

## 5. Schnittstelle (API)

Basis: `https://tanzpartner-ostfriesland.de/api/v1/` – einzelne PHP-Dateien, damit keine Umleitungsregeln nötig sind. Bis zur Store-Version liegt alles hinter dem bestehenden Testzugangsschutz (HTTP Basic). Antworten immer `application/json; charset=utf-8`, `Cache-Control: no-store`. Anfragen mit Inhalt verlangen `Content-Type: application/json`, höchstens 8 KB. Die App sendet `X-App-Version: <Version>`.

### Einheitliches Fehlerformat

```json
{
  "fehler": {
    "code": "ungueltige_eingabe",
    "meldung": "Bitte prüfe die markierten Felder.",
    "felder": {
      "anzeigename": "Bitte 2 bis 30 Zeichen eingeben.",
      "tanzstile": "Bitte mindestens einen Tanzstil wählen."
    }
  }
}
```

`meldung` ist ein deutscher Text, den die App direkt anzeigen darf. `felder` gibt es nur bei `ungueltige_eingabe`. Nie Interna (SQL, Pfade, Ausnahmen).

| HTTP | `code` | Wann |
|---|---|---|
| 400 | `ungueltige_eingabe` | Pflichtfeld fehlt, Länge/Wert unzulässig, Bestätigung fehlt |
| 400 | `kontaktdaten_im_text` | Mail, Telefon oder Link in einem Textfeld |
| 400 | `ungueltiges_json` | Inhalt nicht lesbar |
| 403 | `nicht_moeglich` | Adresse gesperrt – bewusst ohne Begründung |
| 404 | `nicht_gefunden` | Gesuch existiert nicht oder ist nicht sichtbar |
| 405 | `methode_nicht_erlaubt` | falsche HTTP-Methode |
| 413 | `zu_gross` | Anfrage über 8 KB |
| 415 | `falscher_inhaltstyp` | nicht JSON |
| 426 | `app_veraltet` | `X-App-Version` zu alt (für spätere Änderungen) |
| 429 | `zu_viele_anfragen` | Begrenzung erreicht; Kopfzeile `Retry-After` in Sekunden |
| 500 | `serverfehler` | unerwarteter Fehler |
| 503 | `dienst_ausgelastet` | Mail-Limit erreicht oder Wartung; `Retry-After` |

Besteht für eine Adresse schon ein offenes oder sichtbares Gesuch, gibt es **keinen** eigenen Fehler – sonst ließe sich prüfen, ob eine fremde Adresse ein Gesuch hat. Der Server antwortet wie bei Erfolg (`202`) und schickt der Adresse stattdessen eine Mail mit dem Verwaltungslink des bestehenden Gesuchs. Aus demselben Grund antwortet er bei gesperrten Adressen nur knapp mit `403 nicht_moeglich`.

### `GET optionen.php` – Auswahlwerte

```json
{
  "orte": [
    { "schluessel": "aurich", "name": "Aurich" },
    { "schluessel": "emden", "name": "Emden" }
  ],
  "tanzstile": [
    { "schluessel": "discofox", "name": "Discofox" },
    { "schluessel": "salsa", "name": "Salsa" }
  ],
  "rollen": [
    { "schluessel": "fuehrend", "name": "Führend" },
    { "schluessel": "folgend", "name": "Folgend" },
    { "schluessel": "beides", "name": "Beides" }
  ],
  "erfahrung": [ { "schluessel": "ohne_vorkenntnisse", "name": "Ohne Vorkenntnisse" } ],
  "ziele": [ { "schluessel": "ersten_kurs_beginnen", "name": "Ersten Kurs beginnen" } ],
  "laufzeit_tage": 30,
  "mindestalter": 18
}
```

Nur aktive Werte, sortiert. Die App darf die Antwort zwischenspeichern (z. B. für den Offline-Fall).

### `GET gesuche.php` – sichtbare Gesuche

Liefert alle Gesuche mit `status = sichtbar` und `sichtbar_bis >= heute`, neueste Freigabe zuerst, höchstens 500. Filter und Suche macht die App lokal. Keine Parameter.

```json
{
  "stand": "2026-11-20T14:05:00Z",
  "gesuche": [
    {
      "id": 17,
      "anzeigename": "Anke",
      "ort": { "schluessel": "leer", "name": "Leer" },
      "tanzstile": [
        { "schluessel": "discofox", "name": "Discofox" },
        { "schluessel": "standard_latein", "name": "Standard/Latein" }
      ],
      "rolle": { "schluessel": "folgend", "name": "Folgend" },
      "erfahrung": { "schluessel": "grundkenntnisse", "name": "Grundkenntnisse" },
      "ziel": null,
      "tanzorte": [ { "schluessel": "emden", "name": "Emden" } ],
      "zeiten": "Mittwochs abends",
      "freitext": "Suche jemanden für den Fortgeschrittenenkurs ab Januar.",
      "freigegeben_am": "2026-11-18",
      "sichtbar_bis": "2026-12-18"
    }
  ]
}
```

Leerfall: `{"stand": "…", "gesuche": []}` mit HTTP 200. Fehler: 500/503 im einheitlichen Format.

Optional nicht gesetzte Felder sind `null` (Einzelwerte) bzw. `[]` (Listen). Nie enthalten: `email`, `status`, Hashes, Prüf- oder Ablehnungshinweise.

### `POST gesuch.php` – Gesuch aufgeben

```json
{
  "anzeigename": "Anke",
  "ort": "leer",
  "tanzstile": ["discofox", "standard_latein"],
  "rolle": "folgend",
  "erfahrung": "grundkenntnisse",
  "ziel": null,
  "tanzorte": ["emden"],
  "zeiten": "Mittwochs abends",
  "freitext": "Suche jemanden für den Fortgeschrittenenkurs ab Januar.",
  "email": "anke@example.org",
  "alter_bestaetigt": true,
  "datenschutz_akzeptiert": true
}
```

Erfolg – HTTP **202**:

```json
{
  "ergebnis": "bestaetigung_gesendet",
  "meldung": "Fast geschafft: Wir haben dir eine E-Mail geschickt. Bitte bestätige dein Gesuch innerhalb von 24 Stunden. Danach prüfen wir es und schalten es frei."
}
```

Ablauf auf dem Server: Eingaben prüfen → Sperrliste prüfen (gesperrt: `403`) → Begrenzung prüfen → Gesuch `unbestaetigt` anlegen, Tokens erzeugen → Bestätigungsmail senden. Schlägt der Mailversand fehl, wird das Gesuch wieder gelöscht und `503` gemeldet.

Fehlerbeispiel – HTTP 400:

```json
{
  "fehler": {
    "code": "kontaktdaten_im_text",
    "meldung": "Bitte keine E-Mail-Adressen, Telefonnummern oder Links ins Gesuch schreiben. Kontakt läuft über das Kontaktformular.",
    "felder": { "freitext": "Enthält eine Telefonnummer." }
  }
}
```

### `POST kontakt.php` – Nachricht an ein Gesuch

```json
{
  "gesuch_id": 17,
  "name": "Jens",
  "email": "jens@example.org",
  "nachricht": "Hallo Anke, ich tanze seit zwei Jahren Discofox und würde gern ...",
  "alter_bestaetigt": true,
  "datenschutz_akzeptiert": true
}
```

| Feld | Pflicht | Länge |
|---|---|---|
| `gesuch_id` | ja | Ganzzahl, Gesuch muss `sichtbar` sein, sonst `404` |
| `name` | ja | 2–30, Regeln wie `anzeigename` |
| `email` | ja | 6–254; wird als `Reply-To` gesetzt |
| `nachricht` | ja | 20–1000 |
| `alter_bestaetigt`, `datenschutz_akzeptiert` | ja | `true` |

Erfolg – HTTP **202**:

```json
{
  "ergebnis": "weitergeleitet",
  "meldung": "Deine Nachricht wurde weitergeleitet. Wenn Anke antworten möchte, meldet sie sich direkt per E-Mail bei dir."
}
```

Die Mail geht vom Versandpostfach an die Adresse des Gesuchs, `Reply-To` ist die Adresse des Absenders. Damit sieht die Person des Gesuchs die Adresse des Absenders, aber nicht umgekehrt – erst wenn sie antwortet. Die Nachricht wird nicht gespeichert, nur ein Protokolleintrag (Hash, Zeit, Gesuch) für die Begrenzung. Kontaktdaten in der Nachricht sind hier erlaubt.

### `POST meldung.php` – Gesuch melden

```json
{
  "gesuch_id": 17,
  "grund": "kontaktdaten",
  "text": "Telefonnummer im Text versteckt."
}
```

`grund` aus der Liste in Tabelle `meldungen`; `text` optional, höchstens 500 Zeichen. Keine E-Mail-Adresse nötig.

Erfolg – HTTP **202**:

```json
{
  "ergebnis": "gemeldet",
  "meldung": "Danke für deine Meldung. Wir prüfen das Gesuch zeitnah."
}
```

Der Betreiber erhält eine Benachrichtigungsmail ohne Daten der meldenden Person. Mehrfachmeldungen derselben IP zum selben Gesuch werden still ignoriert (trotzdem `202`).

### Links aus Mails (Webseiten, keine App-Schnittstelle)

| Seite | `GET` | `POST` |
|---|---|---|
| `bestaetigen.php?t=<Token>` | Zusammenfassung des Gesuchs, Knopf „Gesuch bestätigen“ | Status → `wartet`; Betreiber erhält Hinweis „neues Gesuch zur Freigabe“ |
| `verwalten.php?t=<Token>` | Status und `sichtbar_bis`, Knöpfe „Um 30 Tage verlängern“ und „Gesuch endgültig löschen“ | Verlängern bzw. Löschen mit Bestätigungsfrage |

Ungültiger, abgelaufener oder verbrauchter Token: verständliche Seite („Dieser Link ist nicht mehr gültig“) mit HTTP 404 bzw. 410, ohne zu verraten, ob es das Gesuch gab. Die Seiten setzen `Referrer-Policy: no-referrer` und `X-Robots-Tag: noindex`, damit der Token nicht weitergegeben wird.

### Admin-Webseite (B07)

Nicht Teil der App-Schnittstelle. Eigener Zugangsschutz, eigene Seiten unter `admin/`. Aktionen: Freigeben (`wartet` → `sichtbar`), Ablehnen mit Grund, Meldungen entscheiden, Gesuch löschen, Adresse eines Gesuchs auf die Sperrliste setzen. Details in K03/B07.

## 6. Vom Nutzer bestätigt (20.11.2026)

1. Startlisten **Orte** und **Tanzstile** (Abschnitt 2).
2. **Feldlängen:** Anzeigename 30, Zeiten 100, Freitext 600, Kontaktnachricht 20–1000, Meldungstext 500.
3. **Fristen:** Bestätigung 24 h; abgelehnte Gesuche nach 7 Tagen, abgelaufene nach 14 Tagen gelöscht; Protokoll 7 Tage (endgültig in K03).
4. **Begrenzungen** (Abschnitt 3).
5. Ein Gesuch je E-Mail-Adresse gleichzeitig.
6. Bei Kontakt sieht die Person des Gesuchs die Adresse des Absenders (über `Reply-To`).
